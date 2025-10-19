import 'package:briewview/features/premium/services/popUpPreferncesServices.dart';
import 'package:briewview/features/premium/services/premium_service.dart';
import 'package:briewview/features/premium/viewmodel/premium_event.dart';
import 'package:briewview/features/premium/viewmodel/premium_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  final PremiumService _premiumService;
  final PopupPreferencesServices _popupPreferencesServices;

  PremiumBloc(this._premiumService, this._popupPreferencesServices)
    : super(PremiumInitial()) {
    on<LoadPremiumPlans>(_onLoadPremiumPlans);
    on<CheckPremiumStatus>(_onCheckPremiumStatus);
    on<SelectPlan>(_onSelectPlan);
    on<CreateSubscription>(_onCreateSubscription);
    on<CancelSubscription>(_onCancelSubscription);
    on<LoadSubscriptionHistory>(_onLoadSubscriptionHistory);
    on<ShowPremiumPopup>(_onShowPremiumPopup);
    on<HidePremiumPopup>(_onHidePremiumPopup);
    on<NavigateToPayment>(_onNavigateToPayment);
    on<ShowHomePagePopup>(_onShowHomePagePopup);
  }

  Future<void> _onLoadPremiumPlans(
    LoadPremiumPlans event,
    Emitter<PremiumState> emit,
  ) async {
    emit(PremiumLoading());

    try {
      final plans = await _premiumService.getPremiumPlans();
      final currentSubscription =
          await _premiumService.getCurrentSubscription();
      final hasPremiumAccess = await _premiumService.hasPremiumAccess();

      emit(
        PremiumLoaded(
          plans: plans,
          currentSubscription: currentSubscription,
          hasPremiumAccess: hasPremiumAccess,
        ),
      );
    } catch (e) {
      emit(PremiumError('Không thể tải danh sách gói premium: $e'));
    }
  }

  Future<void> _onCheckPremiumStatus(
    CheckPremiumStatus event,
    Emitter<PremiumState> emit,
  ) async {
    try {
      final currentSubscription =
          await _premiumService.getCurrentSubscription();
      final hasPremiumAccess = await _premiumService.hasPremiumAccess();

      if (state is PremiumLoaded) {
        final currentState = state as PremiumLoaded;
        emit(
          currentState.copyWith(
            currentSubscription: currentSubscription,
            hasPremiumAccess: hasPremiumAccess,
          ),
        );
      } else {
        emit(
          PremiumLoaded(
            plans: [],
            currentSubscription: currentSubscription,
            hasPremiumAccess: hasPremiumAccess,
          ),
        );
      }
    } catch (e) {
      emit(PremiumError('Không thể kiểm tra trạng thái premium: $e'));
    }
  }

  void _onSelectPlan(SelectPlan event, Emitter<PremiumState> emit) {
    if (state is PremiumLoaded) {
      final currentState = state as PremiumLoaded;
      emit(currentState.copyWith(selectedPlanId: event.planId));
    }
  }

  Future<void> _onCreateSubscription(
    CreateSubscription event,
    Emitter<PremiumState> emit,
  ) async {
    emit(PremiumProcessing('Đang tạo đăng ký premium...'));

    try {
      final result = await _premiumService.createSubscription(
        userId: event.userId,
      );

      // Reload premium status after successful subscription
      add(CheckPremiumStatus());

      emit(PremiumSuccess(message: 'Đăng ký premium thành công!'));
    } catch (e) {
      emit(PremiumError('Không thể tạo đăng ký: $e'));
    }
  }

  Future<void> _onCancelSubscription(
    CancelSubscription event,
    Emitter<PremiumState> emit,
  ) async {
    emit(PremiumProcessing('Đang hủy đăng ký premium...'));

    try {
      final success = await _premiumService.cancelSubscription(
        event.subscriptionId,
      );

      if (success) {
        // Reload premium status after cancellation
        add(CheckPremiumStatus());

        emit(PremiumSuccess(message: 'Hủy đăng ký premium thành công!'));
      } else {
        emit(PremiumError('Không thể hủy đăng ký premium'));
      }
    } catch (e) {
      emit(PremiumError('Lỗi khi hủy đăng ký: $e'));
    }
  }

  Future<void> _onLoadSubscriptionHistory(
    LoadSubscriptionHistory event,
    Emitter<PremiumState> emit,
  ) async {
    // This could be implemented if needed for a subscription history page
    emit(PremiumLoading());
    // Implementation would go here
  }

  void _onShowPremiumPopup(ShowPremiumPopup event, Emitter<PremiumState> emit) {
    if (state is PremiumLoaded) {
      final currentState = state as PremiumLoaded;
      emit(
        currentState.copyWith(
          showPopup: true,
          popupFeature: event.feature,
          popupMessage: event.message,
        ),
      );
    } else {
      emit(
        PremiumLoaded(
          plans: [],
          hasPremiumAccess: false,
          showPopup: true,
          popupFeature: event.feature,
          popupMessage: event.message,
        ),
      );
    }
  }

  void _onHidePremiumPopup(HidePremiumPopup event, Emitter<PremiumState> emit) {
    if (state is PremiumLoaded) {
      final currentState = state as PremiumLoaded;
      emit(
        currentState.copyWith(
          showPopup: false,
          popupFeature: null,
          popupMessage: null,
        ),
      );
    }
  }

  void _onNavigateToPayment(
    NavigateToPayment event,
    Emitter<PremiumState> emit,
  ) {
    if (state is PremiumLoaded) {
      final currentState = state as PremiumLoaded;
      emit(
        currentState.copyWith(selectedPlanId: event.planId, showPopup: false),
      );
    }
  }

  // Helper method to check if user has premium access
  bool get hasPremiumAccess {
    if (state is PremiumLoaded) {
      return (state as PremiumLoaded).hasPremiumAccess;
    }
    return false;
  }

  Future<void> _onShowHomePagePopup(
    ShowHomePagePopup event,
    Emitter<PremiumState> emit,
  ) async {
    if (!hasPremiumAccess) {
      final canShow = await _popupPreferencesServices.canShowPopup();
      if (canShow) {
        await _popupPreferencesServices.markPopupShown();

        if (state is PremiumLoaded) {
          final currentState = state as PremiumLoaded;
          emit(
            currentState.copyWith(
              showPopup: true,
              popupFeature: 'Home',
              popupMessage:
                  event.message ?? 'Update to premium to access this feature.',
            ),
          );
        } else {
          emit(
            PremiumLoaded(
              plans: [],
              hasPremiumAccess: false,
              showPopup: true,
              popupFeature: 'Trang chủ',
              popupMessage: event.message,
            ),
          );
        }
      }
    }
  }

  // Helper method to show premium popup for specific feature
  void showPremiumPopupForFeature(String feature, {String? message}) {
    if (!hasPremiumAccess) {
      add(ShowPremiumPopup(feature: feature, message: message));
    }
  }

  Future<void> showHomePopupIfAllowed({String? message}) async {
    add(ShowHomePagePopup(message: message));
  }
}





