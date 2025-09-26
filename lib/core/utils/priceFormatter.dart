import 'package:intl/intl.dart';  

class PriceFormatter {
   static String format(int? price, {String currency = 'VND'}) {
      if (price == null) return 'N/A';
      final formatter = NumberFormat('#,###', 'en_US');
      return '${formatter.format(price)} $currency';
   }

  static String formatWithDots(int? price, {String currency = 'VND'}) {
    if (price == null) return 'N/A';
    final formatter = NumberFormat('#.###', 'vi_VN');
    String formatted = formatter.format(price).replaceAll(',', '.') ;
    return '$formatted $currency';
  }

   static String formatRange(int? minPrice, int? maxPrice, {String currency = 'VND'}) {
      if (minPrice == null && maxPrice == null) return 'N/A';
      if (minPrice == null) return 'under ${format(maxPrice, currency: currency)}';
      if (maxPrice == null) return 'to ${format(minPrice, currency: currency)}';
      return '${format(minPrice, currency: currency)} - ${format(maxPrice, currency: currency)}';
   }   

   static String formatWithSymbol(int? price, {String currency = 'đ'}) {
      if (price == null) return 'N/A';
      if (price >= 1000000) {
         double millions = price / 1000000;
         return '${millions.toStringAsFixed(millions.truncateToDouble() == millions ? 0 : 1)}M $currency';
      } else if (price >= 1000) {
         double thousands = price / 1000;
         return '${thousands.toStringAsFixed(thousands.truncateToDouble() == thousands ? 0 : 1)}K $currency';
      } else {
         return format(price, currency: currency);
      }
   }  
}
