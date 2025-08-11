// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:briewview/app/router/app_router.dart' as _i664;
import 'package:briewview/core/network/token_storage.dart' as _i439;
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
    gh.singleton<_i664.AppRouter>(() => _i664.AppRouter());
    gh.lazySingleton<_i439.TokenStorage>(() => _i439.TokenStorage());
    gh.lazySingleton<_i480.UserService>(
      () => _i480.UserService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i689.UserRepository>(
      () => _i595.UserRepositoryImpl(gh<_i480.UserService>()),
    );
    gh.factory<_i310.UserBloc>(
      () => _i310.UserBloc(gh<_i689.UserRepository>()),
    );
    return this;
  }
}
