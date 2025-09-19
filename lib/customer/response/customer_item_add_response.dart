import 'package:tailor_mate/customer/model/customer_add_item_model.dart';

class CustomerItemAddResponse {
  String? message;
  CustomerrItemAddModel? data;
  int? status;

  CustomerItemAddResponse({this.message, this.data, this.status});

  CustomerItemAddResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? CustomerrItemAddModel.fromJson(json['data']) : null;
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
