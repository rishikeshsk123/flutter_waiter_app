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
import 'package:restaurant_app/application/product/product_bloc.dart' as _i287;
import 'package:restaurant_app/domain/auth/auth_repository.dart' as _i636;
import 'package:restaurant_app/domain/products/product_repository.dart'
    as _i668;
import 'package:restaurant_app/infrastructure/auth/auth_repository_impl.dart'
    as _i65;
import 'package:restaurant_app/infrastructure/product/product_repository_impl.dart'
    as _i175;

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
    gh.lazySingleton<_i668.ProductRepository>(
        () => _i175.ProductRepositoryImpl());
    gh.factory<_i287.ProductBloc>(
        () => _i287.ProductBloc(gh<_i668.ProductRepository>()));
    return this;
  }
}
