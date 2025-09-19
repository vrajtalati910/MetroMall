import 'package:tailor_mate/Items/model/items_model.dart';

class ItemListResponse {
  String? message;
  List<ItemsModel>? data;
  int? status;

  ItemListResponse({this.message, this.data, this.status});

  ItemListResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <ItemsModel>[];
      json['data'].forEach((v) {
        data!.add(ItemsModel.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}
