part of 'i_customer_repository.dart';

@Injectable(as: ICustomerRepository)
class CustomerRepository extends ICustomerRepository {
  CustomerRepository(
    super.client,
  );

  @override
  ApiResult<CustomerListResponse> getCustomers({String? search, int? page, int? perPage}) async {
    final response = await client.get(
      url: AppStrings.customersList,
      params: {
        if (search != null && search.trim().isNotEmpty) 'search': search,
        if (page != null) 'page': page.toString(),
        if (perPage != null) 'per_page': perPage.toString(),
      },
    );

    return response.parseResponse(CustomerListResponse.fromJson);
  }

  @override
  ApiResult<CustomerResponse> getCustomerDetails({required int id}) async {
    final response = await client.get(
      url: AppStrings.customersDetail(id),
      params: {},
    );

    return response.parseResponse(CustomerResponse.fromJson);
  }

  @override
  ApiResult<CustomerItemResponse> getCustomersItemDetails({required int id}) async {
    final response = await client.get(
      url: AppStrings.customerItemDetail(id),
      params: {},
    );

    return response.parseResponse(CustomerItemResponse.fromJson);
  }

  @override
  ApiResult<CustomerResponse> createCustomer(
      {required String name,
      required String city,
      required String mobile,
      String? reference,
      required String altMobile,
      File? image}) async {
    final Map<String, String> body = {
      'name': name.trim(),
      'city': city.trim(),
      'mobile': mobile.trim(),
      if (reference != null) 'reference': reference.trim(),
      'alt_mobile': altMobile.trim(),
    };

    final response = await client.multipart(
      url: AppStrings.createCustomers,
      requests: body,
      files: image != null ? [MapEntry('image', image)] : [],
    );

    return response.parseResponse(CustomerResponse.fromJson);
  }

  @override
  ApiResult<CustomerItemAddResponse> createCustomerMeasurent({
    required int itemId,
    required int customerId,
    required List<int>? styleIds,
    required List<MeasurementModel>? measurementList,
  }) async {
    final response = await client.multipart(
      url: AppStrings.customerItemAdd(customerId),
      requests: {
        "item_id": itemId.toString(),
        for (var i = 0; i < (styleIds?.length ?? 0); i++) "style[id][$i]": styleIds?[i].toString() ?? "",
        for (var i = 0; i < (measurementList?.length ?? 0); i++)
          "measurement[$i][id]": measurementList?[i].id.toString() ?? "",
        for (var i = 0; i < (measurementList?.length ?? 0); i++)
          "measurement[$i][value]": measurementList?[i].textEditingController?.text.toString() ?? '',
      },
    );

    return response.parseResponse(CustomerItemAddResponse.fromJson);
  }

  @override
  ApiResult<CustomerItemAddResponse> updateCustomerMeasurent({
    required int id,
    // required int customerId,
    required List<int> styleIds,
    required List<MeasurementModel> measurementList,
  }) async {
    final response = await client.multipart(
      url: AppStrings.customerItemUpdate(id),
      requests: {
        for (var i = 0; i < styleIds.length; i++) "style[id][$i]": styleIds[i].toString(),
        for (var i = 0; i < measurementList.length; i++) "measurement[$i][id]": measurementList[i].id.toString(),
        for (var i = 0; i < measurementList.length; i++)
          "measurement[$i][value]": measurementList[i].textEditingController?.text.toString() ?? '',
      },
    );

    return response.parseResponse(CustomerItemAddResponse.fromJson);
  }

  @override
  ApiResult<CustomerResponse> updateCustomer(
      {required String name,
      required String city,
      required String mobile,
      String? reference,
      required String altMobile,
      required int id,
      File? image}) async {
    final Map<String, String> body = {
      'name': name.trim(),
      'city': city.trim(),
      'mobile': mobile.trim(),
      if (reference != null) 'reference': reference.trim(),
      'alt_mobile': altMobile.trim(),
    };

    final response = await client.multipart(
      url: AppStrings.updateCustomers(id),
      requests: body,
      files: image != null ? [MapEntry('image', image)] : [],
    );

    return response.parseResponse(CustomerResponse.fromJson);
  }
}
