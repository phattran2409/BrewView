// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:briewview/app/router/app_router.dart' as _i664;
import 'package:briewview/core/network/network_module.dart' as _i757;
import 'package:briewview/core/network/token_storage.dart' as _i439;
import 'package:briewview/core/network/user_storage_services.dart' as _i369;
import 'package:briewview/core/services/deep_link_handler.dart' as _i42;
import 'package:briewview/core/services/deep_link_service.dart' as _i145;
import 'package:briewview/features/auth/repository/auth_repository.dart'
    as _i564;
import 'package:briewview/features/auth/repository/auth_repository_impl.dart'
    as _i60;
import 'package:briewview/features/auth/services/auth_services.dart' as _i367;
import 'package:briewview/features/auth/services/facebook_auth_service.dart'
    as _i785;
import 'package:briewview/features/auth/services/google_signin_service.dart'
    as _i476;
import 'package:briewview/features/auth/viewModel/Bloc/Auth_Bloc.dart' as _i46;
import 'package:briewview/features/auth/viewModel/Bloc/Otp_Bloc.dart' as _i940;
import 'package:briewview/features/cafe/repository/cafes_repository.dart'
    as _i994;
import 'package:briewview/features/cafe/repository/cafes_repository_impl.dart'
    as _i47;
import 'package:briewview/features/cafe/repository/review_repository.dart'
    as _i207;
import 'package:briewview/features/cafe/repository/review_repository_impl.dart'
    as _i808;
import 'package:briewview/features/cafe/services/cafe_service.dart' as _i762;
import 'package:briewview/features/cafe/services/review_service.dart' as _i458;
import 'package:briewview/features/cafe/viewmodel/cafe_bloc.dart' as _i237;
import 'package:briewview/features/cafe/viewmodel/review_bloc.dart' as _i661;
import 'package:briewview/features/payment/services/payment_service.dart'
    as _i714;
import 'package:briewview/features/post/repository/post_repository.dart'
    as _i909;
import 'package:briewview/features/post/repository/post_repository_impl.dart'
    as _i997;
import 'package:briewview/features/post/services/post_service.dart' as _i231;
import 'package:briewview/features/post/viewmodel/comment_bloc.dart' as _i838;
import 'package:briewview/features/post/viewmodel/post_bloc.dart' as _i642;
import 'package:briewview/features/premium/services/popUpPreferncesServices.dart'
    as _i357;
import 'package:briewview/features/premium/services/premium_service.dart'
    as _i427;
import 'package:briewview/features/premium/viewmodel/premium_bloc.dart'
    as _i484;
import 'package:briewview/features/profile/repository/profile_repository.dart'
    as _i631;
import 'package:briewview/features/profile/repository/profile_repository_impl.dart'
    as _i330;
import 'package:briewview/features/profile/services/profile_service.dart'
    as _i392;
import 'package:briewview/features/profile/viewmodel/profile_bloc.dart'
    as _i654;
import 'package:briewview/features/search/viewmodel/search_bloc.dart' as _i557;
import 'package:briewview/features/survey/repository/survey_repository.dart'
    as _i229;
import 'package:briewview/features/survey/repository/survey_repository_impl.dart'
    as _i546;
import 'package:briewview/features/survey/services/survey_service.dart'
    as _i434;
import 'package:briewview/features/survey/viewmodel/survey_bloc.dart' as _i327;
import 'package:briewview/features/user_management/repository/user_repository.dart'
    as _i689;
import 'package:briewview/features/user_management/repository/user_repository_impl.dart'
    as _i595;
import 'package:briewview/features/user_management/services/user_service.dart'
    as _i480;
import 'package:briewview/features/user_management/viewmodel/user_bloc.dart'
    as _i310;
import 'package:briewview/features/wishlist/repository/wishlist_repository.dart'
    as _i347;
import 'package:briewview/features/wishlist/repository/wishlist_repository_impl.dart'
    as _i1047;
import 'package:briewview/features/wishlist/services/wishlist_service.dart'
    as _i290;
import 'package:briewview/features/wishlist/services/wishlist_service_impl.dart'
    as _i131;
import 'package:briewview/features/wishlist/viewmodel/wishlist_bloc.dart'
    as _i635;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.factory<_i357.PopupPreferencesServices>(
      () => _i357.PopupPreferencesServices(),
    );
    gh.singleton<_i664.AppRouter>(() => _i664.AppRouter());
    gh.singleton<_i145.DeepLinkService>(() => _i145.DeepLinkService());
    gh.lazySingleton<_i439.TokenStorage>(() => _i439.TokenStorage());
    gh.lazySingleton<_i369.UserStorageServices>(
      () => _i369.UserStorageServices(),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i439.TokenStorage>()),
    );
    gh.factory<_i762.CafeService>(
      () => _i762.CafeService(gh<_i361.Dio>(), gh<_i369.UserStorageServices>()),
    );
    gh.factory<_i231.PostService>(
      () => _i231.PostService(gh<_i361.Dio>(), gh<_i369.UserStorageServices>()),
    );
    gh.factory<_i290.WishlistService>(
      () => _i131.WishlistServiceImpl(
        gh<_i361.Dio>(),
        gh<_i369.UserStorageServices>(),
      ),
    );
    gh.factory<_i458.ReviewService>(() => _i458.ReviewService(gh<_i361.Dio>()));
    gh.singleton<_i367.AuthApi>(() => _i367.AuthApi(gh<_i361.Dio>()));
    gh.singleton<_i785.FacebookAuthService>(
      () => _i785.FacebookAuthService(gh<_i361.Dio>()),
    );
    gh.singleton<_i476.GoogleSignInService>(
      () => _i476.GoogleSignInService(gh<_i361.Dio>()),
    );
    gh.singleton<_i714.PaymentService>(
      () => _i714.PaymentService(gh<_i361.Dio>()),
    );
    gh.singleton<_i427.PremiumService>(
      () => _i427.PremiumService(gh<_i361.Dio>()),
    );
    gh.singleton<_i434.SurveyService>(
      () => _i434.SurveyService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i480.UserService>(
      () => _i480.UserService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i564.AuthRepository>(
      () => _i60.AuthRepositoryImpl(
        gh<_i367.AuthApi>(),
        gh<_i439.TokenStorage>(),
        gh<_i476.GoogleSignInService>(),
        gh<_i785.FacebookAuthService>(),
        gh<_i369.UserStorageServices>(),
      ),
    );
    gh.factory<_i484.PremiumBloc>(
      () => _i484.PremiumBloc(
        gh<_i427.PremiumService>(),
        gh<_i357.PopupPreferencesServices>(),
      ),
    );
    gh.singleton<_i46.AuthBloc>(
      () => _i46.AuthBloc(
        gh<_i564.AuthRepository>(),
        gh<_i785.FacebookAuthService>(),
        gh<_i476.GoogleSignInService>(),
      ),
    );
    gh.factory<_i347.WishlistRepository>(
      () => _i1047.WishlistRepositoryImpl(gh<_i290.WishlistService>()),
    );
    gh.factory<_i635.WishlistBloc>(
      () => _i635.WishlistBloc(gh<_i347.WishlistRepository>()),
    );
    gh.singleton<_i229.SurveyRepository>(
      () => _i546.SurveyRepositoryImpl(gh<_i434.SurveyService>()),
    );
    gh.singleton<_i994.CafesRepository>(
      () => _i47.CafesRepositoryImpl(gh<_i762.CafeService>()),
    );
    gh.singleton<_i909.PostRepository>(
      () => _i997.PostRepositoryImpl(gh<_i231.PostService>()),
    );
    gh.factory<_i940.OtpBloc>(() => _i940.OtpBloc(gh<_i564.AuthRepository>()));
    gh.singleton<_i392.ProfileService>(
      () => _i392.ProfileService(
        gh<_i369.UserStorageServices>(),
        gh<_i361.Dio>(),
      ),
    );
    gh.lazySingleton<_i689.UserRepository>(
      () => _i595.UserRepositoryImpl(gh<_i480.UserService>()),
    );
    gh.factory<_i42.DeepLinkHandler>(
      () => _i42.DeepLinkHandler(gh<_i145.DeepLinkService>()),
    );
    gh.lazySingleton<_i207.ReviewRepository>(
      () => _i808.ReviewRepositoryImpl(gh<_i458.ReviewService>()),
    );
    gh.factory<_i310.UserBloc>(
      () => _i310.UserBloc(gh<_i689.UserRepository>()),
    );
    gh.factory<_i661.ReviewBloc>(
      () => _i661.ReviewBloc(gh<_i207.ReviewRepository>()),
    );
    gh.factory<_i237.CafeBloc>(
      () => _i237.CafeBloc(gh<_i994.CafesRepository>()),
    );
    gh.factory<_i557.SearchBloc>(
      () => _i557.SearchBloc(gh<_i994.CafesRepository>()),
    );
    gh.factory<_i327.SurveyBloc>(
      () => _i327.SurveyBloc(
        gh<_i229.SurveyRepository>(),
        gh<_i369.UserStorageServices>(),
      ),
    );
    gh.singleton<_i631.ProfileRepository>(
      () => _i330.ProfileRepositoryImpl(
        gh<_i392.ProfileService>(),
        gh<_i367.AuthApi>(),
        gh<_i369.UserStorageServices>(),
      ),
    );
    gh.factory<_i642.PostBloc>(
      () => _i642.PostBloc(postRepository: gh<_i909.PostRepository>()),
    );
    gh.factory<_i838.CommentBloc>(
      () => _i838.CommentBloc(postRepository: gh<_i909.PostRepository>()),
    );
    gh.factory<_i654.ProfileBloc>(
      () => _i654.ProfileBloc(
        gh<_i631.ProfileRepository>(),
        gh<_i564.AuthRepository>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i757.NetworkModule {}
