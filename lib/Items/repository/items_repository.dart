part of 'i_items_repository.dart';

@Injectable(as: IItemsRepository)
class ItemsRepository extends IItemsRepository {
  ItemsRepository(
    super.client,
  );

  @override
  ApiResult<ItemsResponse> createItems({
    required String name,
    required List<MeasurementModel> measurements,
    required List<String> styles,
  }) async {
    final Map<String, String> body = {
      'name': name.trim(),
    };

    // Add styles with index
    for (int i = 0; i < styles.length; i++) {
      body['style[$i]'] = styles[i];
    }

    // Add measurements with index
    for (int i = 0; i < measurements.length; i++) {
      body['measurement_ids[$i]'] = measurements[i].id.toString();
    }

    final response = await client.multipart(
      url: AppStrings.createItem,
      requests: body,
    );

    return response.parseResponse(ItemsResponse.fromJson);
  }

  @override
  ApiResult<ItemListResponse> getItems({String? search, int? page, int? perPage}) async {
    final response = await client.get(
      url: AppStrings.itemsList,
      params: {
        if (search != null && search.trim().isNotEmpty) 'search': search,
        if (page != null) 'page': page.toString(),
        if (perPage != null) 'per_page': perPage.toString(),
      },
    );

    return response.parseResponse(ItemListResponse.fromJson);
  }

  @override
  ApiResult<ItemsResponse> updateItem({
    required int id,
    required String name,
    required List<MeasurementModel> measurements,
    required List<String> styles,
  }) async {
    final Map<String, String> body = {
      'name': name.trim(),
    };

    // Add styles with index
    for (int i = 0; i < styles.length; i++) {
      body['style[$i]'] = styles[i];
    }

    // Add measurements with index
    for (int i = 0; i < measurements.length; i++) {
      body['measurement_ids[$i]'] = measurements[i].id.toString();
    }

    final response = await client.multipart(
      url: AppStrings.updateitems(id),
      requests: body,
    );

    return response.parseResponse(ItemsResponse.fromJson);
  }

  // @override
  // ApiResult<ItemsResponse> updateItem({
  //   required int id,
  //   required String name,
  //   required List<int> removeMeasurementIds,
  //   required List<int> removeStyleIds,
  //   required List<int> addMeasurementIds,
  //   required List<String> addStyleNames,
  // }) async {
  //   final response = await client.multipart(
  //     url: AppStrings.updateitems(id),
  //     requests: {
  //       "name": name,
  //       // remove
  //       for (var i = 0; i < removeMeasurementIds.length; i++)
  //         "remove[measurements][id][$i]": removeMeasurementIds[i].toString(),
  //       for (var i = 0; i < removeStyleIds.length; i++) "remove[styles][id][$i]": removeStyleIds[i].toString(),
  //       // add
  //       for (var i = 0; i < addMeasurementIds.length; i++) "add[measurements][id][$i]": addMeasurementIds[i].toString(),
  //       for (var i = 0; i < addStyleNames.length; i++) "add[styles][name][$i]": addStyleNames[i],
  //     },
  //   );

  //   return response.parseResponse(ItemsResponse.fromJson);
  // }

  @override
  ApiResult<ItemsResponse> getItemsDetails({required int id}) async {
    final response = await client.get(
      url: AppStrings.itemsDetail(id),
      params: {},
    );

    return response.parseResponse(ItemsResponse.fromJson);
  }
}
