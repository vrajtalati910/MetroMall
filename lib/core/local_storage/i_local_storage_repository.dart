import 'dart:convert';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tailor_mate/core/constant/app_string.dart';
import 'package:tailor_mate/core/utils/logger_config.dart';
import 'package:tailor_mate/customer/model/customer_item_detail_model.dart';
import 'package:tailor_mate/customer/model/customer_item_local_model.dart';
import 'package:tailor_mate/login/response/login_response.dart';

part 'local_storage_repository.dart';

abstract class ILocalStorageRepository {
  ILocalStorageRepository(this.preferences);
  final SharedPreferences preferences;

  Future<bool> setToken(String? value);

  String? get token;

  Future<LoginModel> setUser(LoginModel? user);

  LoginModel? get getUser;

  Future<List<CustomerItemLocalModel>> setPrintData(CustomerItemLocalModel? value);

  List<CustomerItemLocalModel>? get getPrintData;

  Future<bool> clearPrintData();

  Future<bool> clearAuth();
}
