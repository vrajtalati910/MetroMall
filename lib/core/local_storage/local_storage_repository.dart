part of 'i_local_storage_repository.dart';

@Injectable(as: ILocalStorageRepository)
class LocalStorageRepository extends ILocalStorageRepository {
  LocalStorageRepository(super.preferences);

  @override
  Future<bool> setToken(String? value) async {
    if (value == null) return false;
    try {
      await preferences.setString("token", value);
      return true;
    } on Exception catch (e, s) {
      log('Error Set Token: $e \n $s');
      return false;
    }
  }

  @override
  String? get token => preferences.getString(AppStrings.tokenKey);

  @override
  Future<bool> clearAuth() async {
    try {
      final isRemoveToken = await preferences.remove(AppStrings.tokenKey);
      final isRemoveUser = await preferences.remove(AppStrings.userPrefKey);
      final isRemovePrint = await preferences.remove(AppStrings.printPrefKey);
      return isRemoveUser && isRemoveToken && isRemovePrint;
    } on Exception catch (e, s) {
      debugError('Error Clear Auth: $e \n $s');
      return false;
    }
  }

  @override
  Future<LoginModel> setUser(LoginModel? user) async {
    try {
      final isSuccess = await preferences.setString(AppStrings.userPrefKey, jsonEncode(user));
      if (!isSuccess) {
        throw Exception('Failed to save user data');
      }
      return user!;
    } catch (e) {
      throw Exception('Error saving user: ${e.toString()}');
    }
  }

  @override
  LoginModel? get getUser {
    try {
      final userKey = preferences.getString(AppStrings.userPrefKey);
      if (userKey != null) {
        final user = LoginModel.fromJson(jsonDecode(userKey) as Map<String, dynamic>);
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> clearPrintData() async {
    try {
      final isRemovePrint = await preferences.remove(AppStrings.printPrefKey);
      return isRemovePrint;
    } on Exception catch (e, s) {
      debugError('Error Clear Auth: $e \n $s');
      return false;
    }
  }

  @override
  Future<List<CustomerItemLocalModel>> setPrintData(CustomerItemLocalModel? value) async {
    try {
      if (value == null) return [];

      // 1️⃣ Load existing data
      final existingData = preferences.getString(AppStrings.printPrefKey);
      List<CustomerItemLocalModel> currentList = [];

      if (existingData != null) {
        final decoded = jsonDecode(existingData) as List<dynamic>;
        currentList = decoded.map((e) => CustomerItemLocalModel.fromJson(e as Map<String, dynamic>)).toList();
      }

      // 2️⃣ Check if customer already exists
      final existingCustomerIndex = currentList.indexWhere((c) => c.id == value.id);

      if (existingCustomerIndex != -1) {
        // ✅ Customer exists → merge items
        final existingCustomer = currentList[existingCustomerIndex];

        final updatedItems = List<CustomerItemDetailModel>.from(existingCustomer.itemsModel ?? []);

        for (final newItem in value.itemsModel ?? []) {
          // 🔍 Check if this item already exists
          final existingItemIndex = updatedItems.indexWhere((i) => i.id == newItem.id);

          if (existingItemIndex != -1) {
            // ✅ Item exists → merge/replace its records
            final existingItem = updatedItems[existingItemIndex];
            final mergedRecords = List<MeasurementRecords>.from(existingItem.measurementRecords ?? []);

            mergedRecords
              ..removeWhere((r) => newItem.measurementRecords?.any((nr) => nr.id == r.id) ?? false)
              ..addAll(newItem.measurementRecords ?? []);

            updatedItems[existingItemIndex] = existingItem.copyWith(measurementRecords: mergedRecords);
          } else {
            // ➕ New item → just add
            updatedItems.add(newItem);
          }
        }

        final updatedCustomer = existingCustomer.copyWith(itemsModel: updatedItems);
        currentList[existingCustomerIndex] = updatedCustomer;
      } else {
        // ➕ New customer → just add
        currentList.add(value);
      }

      // 3️⃣ Save updated list
      final isSuccess = await preferences.setString(
        AppStrings.printPrefKey,
        jsonEncode(currentList.map((e) => e.toJson()).toList()),
      );

      if (!isSuccess) throw Exception('Failed to save print data');
      return currentList;
    } catch (e) {
      throw Exception('Error saving print data: ${e.toString()}');
    }
  }

  @override
  List<CustomerItemLocalModel>? get getPrintData {
    try {
      final printKey = preferences.getString(AppStrings.printPrefKey);
      if (printKey != null) {
        final decoded = jsonDecode(printKey) as List<dynamic>;
        return decoded.map((e) => CustomerItemLocalModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
