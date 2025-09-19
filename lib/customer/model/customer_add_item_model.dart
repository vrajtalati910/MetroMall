import 'package:tailor_mate/measurement/model/measurement_model.dart';

class CustomerrItemAddModel {
  int? customerId;
  String? itemId;
  int? id;
  List<MeasurementModel>? measurements;
  List<MeasurementModel>? styles;

  CustomerrItemAddModel({this.customerId, this.itemId, this.id, this.measurements, this.styles});

  CustomerrItemAddModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    itemId = json['item_id'];
    id = json['id'];
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
    data['customer_id'] = customerId;
    data['item_id'] = itemId;
    data['id'] = id;
    if (measurements != null) {
      data['measurements'] = measurements!.map((v) => v.toJson()).toList();
    }
    if (styles != null) {
      data['styles'] = styles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
