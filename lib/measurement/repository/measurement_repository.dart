part of 'i_measurement_repository.dart';

@Injectable(as: IMeasurementRepository)
class MeasurementRepository extends IMeasurementRepository {
  MeasurementRepository(
    super.client,
  );

  @override
  ApiResult<MeasurementsResponse> createMeasurement({
    required String name,
  }) async {
    final response = await client.post(
      url: AppStrings.createMeasurement,
      requests: {
        'name': name.trim(),
      },
    );

    return response.parseResponse(MeasurementsResponse.fromJson);
  }

  @override
  ApiResult<MeasurementsListResponse> getMeasurements({String? search, int? page, int? perPage}) async {
    final response = await client.get(
      url: AppStrings.measurementsList,
      params: {
        if (search != null && search.trim().isNotEmpty) 'search': search,
        if (page != null) 'page': page.toString(),
        if (perPage != null) 'per_page': perPage.toString(),
      },
    );

    return response.parseResponse(MeasurementsListResponse.fromJson);
  }

  @override
  ApiResult<MeasurementsResponse> updateMeasurement({required String name, required int id}) async {
    final response = await client.post(
      url: AppStrings.updateMeasurement(id),
      requests: {
        'name': name.trim(),
      },
    );

    return response.parseResponse(MeasurementsResponse.fromJson);
  }
}
