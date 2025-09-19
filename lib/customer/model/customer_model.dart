// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tailor_mate/customer/model/customer_item_detail_model.dart';

class CustomerModel {
  int? id;
  String? imagePath;
  String? name;
  String? mobile;
  String? altMobile;
  String? city;
  String? reference;
  String? createdAt;
  String? updatedAt;
  List<CustomerItemDetailModel>? customerItems;
  bool isSelected = false;

  CustomerModel({
    this.id,
    this.imagePath,
    this.name,
    this.mobile,
    this.altMobile,
    this.city,
    this.reference,
    this.createdAt,
    this.updatedAt,
    this.customerItems,
    required this.isSelected,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagePath = json['image_path'];
    name = json['name'];
    mobile = json['mobile'];
    altMobile = json['alt_mobile'];
    city = json['city'];
    reference = json['reference'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['customer_items'] != null) {
      customerItems = <CustomerItemDetailModel>[];
      json['customer_items'].forEach((v) {
        customerItems!.add(CustomerItemDetailModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_path'] = imagePath;
    data['name'] = name;
    data['mobile'] = mobile;
    data['alt_mobile'] = altMobile;
    data['city'] = city;
    data['reference'] = reference;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (customerItems != null) {
      data['customer_items'] = customerItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  CustomerModel copyWith({
    int? id,
    String? imagePath,
    String? name,
    String? mobile,
    String? altMobile,
    String? city,
    String? reference,
    String? createdAt,
    String? updatedAt,
    List<CustomerItemDetailModel>? customerItems,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      altMobile: altMobile ?? this.altMobile,
      city: city ?? this.city,
      reference: reference ?? this.reference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customerItems: customerItems ?? this.customerItems,
      isSelected: isSelected,
    );
  }
}
