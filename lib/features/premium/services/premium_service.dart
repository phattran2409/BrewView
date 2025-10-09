import 'package:briewview/core/constants/app_constants.dart';
import 'package:briewview/core/network/user_storage_services.dart';
import 'package:briewview/features/premium/model/premium_plan_model.dart';
import 'package:briewview/features/premium/model/subscription_model.dart';
import 'package:briewview/features/premium/data/premium_data.dart';
import 'package:briewview/features/user_management/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class PremiumService {
  final Dio _dio;

  PremiumService(this._dio);

  // Get available premium plans
  Future<List<PremiumPlanModel>> getPremiumPlans() async {
    try {
      // Use hardcoded data for now
      return PremiumData.getPremiumPlans();

      // TODO: Uncomment when API is ready
      // final response = await _dio.get(AppConstants.premiumPlansEndpoint);
      // if (response.statusCode == 200) {
      //   final data = response.data as Map<String, dynamic>;
      //   if (data['isSuccess'] == true && data['data'] != null) {
      //     final plans = (data['data'] as List)
      //         .map((planJson) => PremiumPlanModel.fromJson(planJson))
      //         .toList();
      //     return plans;
      //   }
      // }
      // throw Exception('Failed to load premium plans');
    } catch (e) {
      print('Error loading premium plans: $e');
      rethrow;
    }
  }

  // Get user's current subscription
  Future<SubscriptionModel?> getCurrentSubscription() async {
    try {
      // Use hardcoded data for now
      final subscriptionData = PremiumData.getCurrentSubscription();
      if (subscriptionData != null) {
        return SubscriptionModel.fromJson(subscriptionData);
      }
      return null;

      // TODO: Uncomment when API is ready
      // final response = await _dio.get(AppConstants.currentSubscriptionEndpoint);
      // if (response.statusCode == 200) {
      //   final data = response.data as Map<String, dynamic>;
      //   if (data['isSuccess'] == true && data['data'] != null) {
      //     return SubscriptionModel.fromJson(data['data']);
      //   }
      // }
      // return null;
    } catch (e) {
      print('Error loading current subscription: $e');
      return null;
    }
  }

  // Check if user has premium access
  Future<bool> hasPremiumAccess() async {
    try {
      UserStorageServices userStorage = UserStorageServices();
      if (userStorage.getCurrentUser() != null) {
        UserModel userModel = await userStorage.getCurrentUser() as UserModel;
        if (userModel.isPremium != null && userModel.isPremium == true) {
          return true;
        } 
      }
      return false;
    } catch (e) {
      print('Error checking premium access: $e');
      return false;
    }
  }

  // Create new subscription
  Future<Map<String, dynamic>> createSubscription({
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.createSubscriptionEndpoint,
        data: {'userId': userId},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true) {
          return data['data'];
        }
      }
      throw Exception('Failed to create subscription');
    } catch (e) {
      print('Error creating subscription: $e');
      rethrow;
    }
  }

  // Cancel subscription
  Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      final response = await _dio.post(
        '${AppConstants.cancelSubscriptionEndpoint}/$subscriptionId',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['isSuccess'] == true;
      }
      return false;
    } catch (e) {
      print('Error cancelling subscription: $e');
      return false;
    }
  }

  // Get subscription history
  Future<List<SubscriptionModel>> getSubscriptionHistory() async {
    try {
      final response = await _dio.get(AppConstants.subscriptionHistoryEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['isSuccess'] == true && data['data'] != null) {
          final subscriptions =
              (data['data'] as List)
                  .map((subJson) => SubscriptionModel.fromJson(subJson))
                  .toList();
          return subscriptions;
        }
      }
      return [];
    } catch (e) {
      print('Error loading subscription history: $e');
      return [];
    }
  }
}
