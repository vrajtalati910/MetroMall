import 'package:tailor_mate/customer/model/customer_item_detail_model.dart';

class CustomerItemLocalModel {
  int? id;
  String? name;
  String? mobile;
  String? altMobile;
  String? city;
  String? reference;
  List<CustomerItemDetailModel>? itemsModel;

  CustomerItemLocalModel({
    this.id,
    this.name,
    this.mobile,
    this.altMobile,
    this.city,
    this.reference,
    this.itemsModel,
  });

  CustomerItemLocalModel copyWith({
    int? id,
    String? name,
    String? mobile,
    String? altMobile,
    String? city,
    String? reference,
    List<CustomerItemDetailModel>? itemsModel,
  }) {
    return CustomerItemLocalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      altMobile: altMobile ?? this.altMobile,
      city: city ?? this.city,
      reference: reference ?? this.reference,
      itemsModel: itemsModel ?? this.itemsModel,
    );
  }

  /// ✅ Convert from JSON
  factory CustomerItemLocalModel.fromJson(Map<String, dynamic> json) {
    return CustomerItemLocalModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      altMobile: json['altMobile'] as String?,
      city: json['city'] as String?,
      reference: json['reference'] as String?,
      itemsModel: (json['itemsModel'] as List<dynamic>?)
          ?.map((e) => CustomerItemDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// ✅ Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'altMobile': altMobile,
      'city': city,
      'reference': reference,
      'itemsModel': itemsModel?.map((e) => e.toJson()).toList(),
    };
  }
}
