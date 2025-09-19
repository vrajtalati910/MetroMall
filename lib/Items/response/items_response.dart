import 'package:tailor_mate/Items/model/items_model.dart';

class ItemsResponse {
  String? message;
  ItemsModel? data;
  int? status;

  ItemsResponse({this.message, this.data, this.status});

  ItemsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? ItemsModel.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    return data;
  }
}
