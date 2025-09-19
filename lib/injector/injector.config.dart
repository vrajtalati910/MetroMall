// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:tailor_mate/core/local_storage/i_local_storage_repository.dart'
    as _i1068;
import 'package:tailor_mate/core/utils/network/client.dart' as _i395;
import 'package:tailor_mate/core/utils/network/http_client.dart' as _i12;
import 'package:tailor_mate/customer/repository/i_customer_repository.dart'
    as _i967;
import 'package:tailor_mate/injector/shared_preference_injectable_module.dart'
    as _i223;
import 'package:tailor_mate/Items/repository/i_items_repository.dart' as _i219;
import 'package:tailor_mate/measurement/repository/i_measurement_repository.dart'
    as _i839;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final sharedPrefrenceInjectableModule = _$SharedPrefrenceInjectableModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPrefrenceInjectableModule.prefs,
      preResolve: true,
    );
    gh.factory<_i1068.ILocalStorageRepository>(
        () => _i1068.LocalStorageRepository(gh<_i460.SharedPreferences>()));
    gh.factory<_i395.Client>(
        () => _i12.HttpClient(gh<_i1068.ILocalStorageRepository>()));
    gh.factory<_i219.IItemsRepository>(
        () => _i219.ItemsRepository(gh<_i395.Client>()));
    gh.factory<_i967.ICustomerRepository>(
        () => _i967.CustomerRepository(gh<_i395.Client>()));
    gh.factory<_i839.IMeasurementRepository>(
        () => _i839.MeasurementRepository(gh<_i395.Client>()));
    return this;
  }
}

class _$SharedPrefrenceInjectableModule
    extends _i223.SharedPrefrenceInjectableModule {}
