import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tailor_mate/core/constant/app_string.dart';
import 'package:tailor_mate/core/utils/extentions/fpdart_extentions.dart';
import 'package:tailor_mate/core/utils/network/client.dart';
import 'package:tailor_mate/customer/response/customer_item_add_response.dart';
import 'package:tailor_mate/customer/response/customer_item_response.dart';
import 'package:tailor_mate/customer/response/customer_list_response.dart';
import 'package:tailor_mate/customer/response/customer_response.dart';
import 'package:tailor_mate/measurement/model/measurement_model.dart';

part 'customer_repository.dart';

abstract class ICustomerRepository {
  ICustomerRepository(this.client);
  final Client client;

  ApiResult<CustomerResponse> createCustomer({
    required String name,
    required String city,
    required String mobile,
    String? reference,
    required String altMobile,
    File? image,
  });

  ApiResult<CustomerItemAddResponse> createCustomerMeasurent({
    required int itemId,
    required int customerId,
    required List<int>? styleIds,
    required List<MeasurementModel>? measurementList,
  });

  ApiResult<CustomerItemAddResponse> updateCustomerMeasurent({
    required int id,
    required List<int> styleIds,
    required List<MeasurementModel> measurementList,
  });

  ApiResult<CustomerResponse> updateCustomer({
    required String name,
    required String city,
    required String mobile,
    String? reference,
    required String altMobile,
    File? image,
    required int id,
  });

  ApiResult<CustomerResponse> getCustomerDetails({required int id});

  ApiResult<CustomerListResponse> getCustomers({
    String? search,
    int? page,
    int? perPage,
  });

  ApiResult<CustomerItemResponse> getCustomersItemDetails({required int id});
}
