import 'package:tailor_mate/measurement/model/measurement_model.dart';

class MeasurementsResponse {
  String? message;
  MeasurementModel? data;
  int? status;

  MeasurementsResponse({this.message, this.data, this.status});

  MeasurementsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? MeasurementModel.fromJson(json['data']) : null;
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
