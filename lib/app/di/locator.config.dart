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
import 'package:briewview/core/services/deep_link_services.dart' as _i756;
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
import 'package:briewview/features/profile/repository/profile_repository.dart'
    as _i631;
import 'package:briewview/features/profile/repository/profile_repository_impl.dart'
    as _i330;
import 'package:briewview/features/profile/services/profile_service.dart'
    as _i392;
import 'package:briewview/features/profile/viewmodel/profile_bloc.dart'
    as _i654;
import 'package:briewview/features/user_management/repository/user_repository.dart'
    as _i689;
import 'package:briewview/features/user_management/repository/user_repository_impl.dart'
    as _i595;
import 'package:briewview/features/user_management/services/user_service.dart'
    as _i480;
import 'package:briewview/features/user_management/viewmodel/user_bloc.dart'
    as _i310;
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
    gh.singleton<_i664.AppRouter>(() => _i664.AppRouter());
    gh.singleton<_i756.DeepLinkService>(() => _i756.DeepLinkService());
    gh.lazySingleton<_i439.TokenStorage>(() => _i439.TokenStorage());
    gh.lazySingleton<_i369.UserStorageServices>(
      () => _i369.UserStorageServices(),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i439.TokenStorage>()),
    );
    gh.singleton<_i367.AuthApi>(() => _i367.AuthApi(gh<_i361.Dio>()));
    gh.singleton<_i785.FacebookAuthService>(
      () => _i785.FacebookAuthService(gh<_i361.Dio>()),
    );
    gh.singleton<_i476.GoogleSignInService>(
      () => _i476.GoogleSignInService(gh<_i361.Dio>()),
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
    gh.singleton<_i46.AuthBloc>(
      () => _i46.AuthBloc(
        gh<_i564.AuthRepository>(),
        gh<_i785.FacebookAuthService>(),
        gh<_i476.GoogleSignInService>(),
      ),
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
    gh.factory<_i310.UserBloc>(
      () => _i310.UserBloc(gh<_i689.UserRepository>()),
    );
    gh.singleton<_i631.ProfileRepository>(
      () => _i330.ProfileRepositoryImpl(
        gh<_i392.ProfileService>(),
        gh<_i367.AuthApi>(),
        gh<_i369.UserStorageServices>(),
      ),
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
