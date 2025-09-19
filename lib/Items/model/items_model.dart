// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tailor_mate/measurement/model/measurement_model.dart';

class ItemsModel {
  int? id;
  int? customerItemid;
  String? name;
  String? createdAt;
  String? updatedAt;
  List<MeasurementModel>? measurements;
  List<MeasurementModel>? styles;

  ItemsModel({this.id, this.name, this.createdAt, this.updatedAt, this.measurements, this.styles, this.customerItemid});

  ItemsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['measurements'] != null) {
      measurements = <MeasurementModel>[];
      json['measurements'].forEach((v) {
        measurements!.add(MeasurementModel.fromJson(v));
      });
    }
    if (json['styles'] != null) {
      styles = <MeasurementModel>[];
      json['styles'].forEach((v) {
        styles!.add(MeasurementModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (measurements != null) {
      data['measurements'] = measurements!.map((v) => v.toJson()).toList();
    }
    if (styles != null) {
      data['styles'] = styles!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  ItemsModel copyWith({
    int? id,
    int? customerItemid,
    String? name,
    String? createdAt,
    String? updatedAt,
    List<MeasurementModel>? measurements,
    List<MeasurementModel>? styles,
  }) {
    return ItemsModel(
      id: id ?? this.id,
      customerItemid: customerItemid ?? this.customerItemid,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      measurements: measurements ?? this.measurements,
      styles: styles ?? this.styles,
    );
  }
}
