// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tailor_mate/measurement/model/measurement_model.dart';

class CustomerItemDetailModel {
  int? id;
  int? customerId;
  int? itemId;
  List<MeasurementRecords>? measurementRecords;
  List<StyleRecords>? styleRecords;
  ItemModelLite? item;

  CustomerItemDetailModel(
      {this.id, this.customerId, this.itemId, this.measurementRecords, this.styleRecords, this.item});

  CustomerItemDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    itemId = json['item_id'];
    if (json['measurement_records'] != null) {
      measurementRecords = <MeasurementRecords>[];
      json['measurement_records'].forEach((v) {
        measurementRecords!.add(MeasurementRecords.fromJson(v));
      });
    }
    if (json['style_records'] != null) {
      styleRecords = <StyleRecords>[];
      json['style_records'].forEach((v) {
        styleRecords!.add(StyleRecords.fromJson(v));
      });
    }
    item = json['item'] != null ? ItemModelLite.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['item_id'] = itemId;
    if (measurementRecords != null) {
      data['measurement_records'] = measurementRecords!.map((v) => v.toJson()).toList();
    }
    if (styleRecords != null) {
      data['style_records'] = styleRecords!.map((v) => v.toJson()).toList();
    }
    if (item != null) {
      data['item'] = item!.toJson();
    }

    return data;
  }

  CustomerItemDetailModel copyWith({
    int? id,
    int? customerId,
    int? itemId,
    List<MeasurementRecords>? measurementRecords,
    List<StyleRecords>? styleRecords,
  }) {
    return CustomerItemDetailModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      itemId: itemId ?? this.itemId,
      measurementRecords: measurementRecords ?? this.measurementRecords,
      styleRecords: styleRecords ?? this.styleRecords,
    );
  }
}

class MeasurementRecords {
  int? id;
  int? customerItemId;
  int? measurementId;
  String? value;
  MeasurementModel? measurement;

  MeasurementRecords({this.id, this.customerItemId, this.measurementId, this.value, this.measurement});

  MeasurementRecords.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerItemId = json['customer_item_id'];
    measurementId = json['measurement_id'];
    value = json['value'];
    measurement = json['measurement'] != null ? MeasurementModel.fromJson(json['measurement']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_item_id'] = customerItemId;
    data['measurement_id'] = measurementId;
    data['value'] = value;
    if (measurement != null) {
      data['measurement'] = measurement!.toJson();
    }
    return data;
  }
}

class StyleRecords {
  int? id;
  int? customerItemId;
  int? itemStyleId;
  MeasurementModel? style;

  StyleRecords({this.id, this.customerItemId, this.itemStyleId, this.style});

  StyleRecords.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerItemId = json['customer_item_id'];
    itemStyleId = json['item_style_id'];
    style = json['style'] != null ? MeasurementModel.fromJson(json['style']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_item_id'] = customerItemId;
    data['item_style_id'] = itemStyleId;
    if (style != null) {
      data['style'] = style!.toJson();
    }
    return data;
  }
}

class ItemModelLite {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  ItemModelLite({this.id, this.name, this.createdAt, this.updatedAt});

  factory ItemModelLite.fromJson(Map<String, dynamic> json) {
    return ItemModelLite(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
