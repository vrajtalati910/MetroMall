import 'package:injectable/injectable.dart';
import 'package:tailor_mate/core/constant/app_string.dart';
import 'package:tailor_mate/core/utils/extentions/fpdart_extentions.dart';
import 'package:tailor_mate/core/utils/network/client.dart';
import 'package:tailor_mate/measurement/response/measurement_list_response.dart';
import 'package:tailor_mate/measurement/response/measurement_response.dart';

part 'measurement_repository.dart';

abstract class IMeasurementRepository {
  IMeasurementRepository(this.client);
  final Client client;

  ApiResult<MeasurementsResponse> createMeasurement({
    required String name,
  });

  ApiResult<MeasurementsListResponse> getMeasurements({
    String? search,
    int? page,
    int? perPage,
  });

  ApiResult<MeasurementsResponse> updateMeasurement({
    required String name,
    required int id,
  });
}
