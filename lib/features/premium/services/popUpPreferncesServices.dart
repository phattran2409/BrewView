import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class PopupPreferencesServices {
  static const String _lastDismissTimeKey = 'premium_popup_last_dismiss_time';
  static const String _popupCountKey = 'premium_popup_count_today';
  static const String _lastShowDateKey = 'premium_popup_last_show_date';

  static const int cooldownMinutes = 5; // 5 phút cooldown
  static const int maxPopupsPerDay = 3;

  Future<void> markPopupDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    await prefs.setInt(_lastDismissTimeKey, now.millisecondsSinceEpoch);

    // Increment daily counter
    await _incrementDailyCount();
  }

  Future<void> _incrementDailyCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayKey();
    final lastShowDate = prefs.getString(_lastShowDateKey);

    if (lastShowDate != today) {
      // New day, reset counter
      await prefs.setInt(_popupCountKey, 1);
      await prefs.setString(_lastShowDateKey, today);
    } else {
      final currentCount = prefs.getInt(_popupCountKey) ?? 0;
      await prefs.setInt(_popupCountKey, currentCount + 1);
    }
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<int> getRemainingCooldownMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDismissTime = prefs.getInt(_lastDismissTimeKey);

    if (lastDismissTime == null) return 0;

    final lastDismiss = DateTime.fromMillisecondsSinceEpoch(lastDismissTime);
    final now = DateTime.now();
    final difference = now.difference(lastDismiss);

    final remaining = cooldownMinutes - difference.inMinutes;
    return remaining > 0 ? remaining : 0;
  }

  Future<void> resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastDismissTimeKey);
    await prefs.remove(_popupCountKey);
    await prefs.remove(_lastShowDateKey);
  }

  Future<bool> canShowPopup() async {
    final prefs = await SharedPreferences.getInstance();
    final remainingCooldown = await getRemainingCooldownMinutes();
    if (remainingCooldown > 0) {
      // Still in cooldown period
      return false;
    }

    final today = _getTodayKey();
    final lastShowDate = prefs.getString(_lastShowDateKey);
    int currentCount = prefs.getInt(_popupCountKey) ?? 0;

    if (lastShowDate != today) {
      // New day, reset counter
      currentCount = 0;
      await prefs.setString(_lastShowDateKey, today);
      await prefs.setInt(_popupCountKey, 0);
    }

    if (currentCount >= maxPopupsPerDay) {
      // Reached max popups for today
      return false;
    }

    return true;
  }
  
  Future<void> markPopupShown() async {
    final prefs = await SharedPreferences.getInstance();
    await _incrementDailyCount();
    final now = DateTime.now();
    await prefs.setInt(_lastDismissTimeKey, now.millisecondsSinceEpoch);
  }
}
