import 'package:injectable/injectable.dart';
import 'package:tailor_mate/Items/response/items_list_response.dart';
import 'package:tailor_mate/Items/response/items_response.dart';
import 'package:tailor_mate/core/constant/app_string.dart';
import 'package:tailor_mate/core/utils/extentions/fpdart_extentions.dart';
import 'package:tailor_mate/core/utils/network/client.dart';
import 'package:tailor_mate/measurement/model/measurement_model.dart';

part 'items_repository.dart';

abstract class IItemsRepository {
  IItemsRepository(this.client);
  final Client client;

  ApiResult<ItemsResponse> createItems({
    required String name,
    required List<MeasurementModel> measurements,
    required List<String> styles,
  });

  ApiResult<ItemListResponse> getItems({
    String? search,
    int? page,
    int? perPage,
  });

  ApiResult<ItemsResponse> getItemsDetails({required int id});

  // ApiResult<ItemsResponse> updateItem({
  //   required int id,
  //   required String name,
  //   required List<int> removeMeasurementIds,
  //   required List<int> removeStyleIds,
  //   required List<int> addMeasurementIds,
  //   required List<String> addStyleNames,
  // });

  ApiResult<ItemsResponse> updateItem({
    required int id,
    required String name,
    required List<MeasurementModel> measurements,
    required List<String> styles,
  });
}
