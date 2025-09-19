import 'package:tailor_mate/measurement/model/measurement_model.dart';

class MeasurementsListResponse {
  String? message;
  List<MeasurementModel>? data;
  int? status;

  MeasurementsListResponse({this.message, this.data, this.status});

  MeasurementsListResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <MeasurementModel>[];
      json['data'].forEach((v) {
        data!.add(MeasurementModel.fromJson(v));
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
