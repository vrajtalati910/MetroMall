import 'package:tailor_mate/customer/model/customer_item_detail_model.dart';

class CustomerItemResponse {
  String? message;
  CustomerItemDetailModel? data;
  int? status;

  CustomerItemResponse({this.message, this.data, this.status});

  CustomerItemResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? CustomerItemDetailModel.fromJson(json['data']) : null;
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
