import 'package:tailor_mate/customer/model/customer_model.dart';

class CustomerResponse {
  String? message;
  CustomerModel? data;
  int? status;

  CustomerResponse({this.message, this.data, this.status});

  CustomerResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? CustomerModel.fromJson(json['data']) : null;
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
