// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:restaurant_app/application/auth/auth_bloc.dart' as _i282;
import 'package:restaurant_app/domain/auth/auth_repository.dart' as _i636;
import 'package:restaurant_app/infrastructure/auth/auth_repository_impl.dart'
    as _i65;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i636.AuthRepository>(() => _i65.AuthRepositoryImpl());
    gh.factory<_i282.AuthBloc>(
        () => _i282.AuthBloc(gh<_i636.AuthRepository>()));
    return this;
  }
}
