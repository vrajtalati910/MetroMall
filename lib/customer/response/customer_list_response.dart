import 'package:tailor_mate/customer/model/customer_model.dart';

class CustomerListResponse {
  String? message;
  List<CustomerModel>? data;
  int? status;

  CustomerListResponse({this.message, this.data, this.status});

  CustomerListResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <CustomerModel>[];
      json['data'].forEach((v) {
        data!.add(CustomerModel.fromJson(v));
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
