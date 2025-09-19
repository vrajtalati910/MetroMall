// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MeasurementModel {
  int? id;
  String? name;
  TextEditingController? textEditingController;
  bool isSelected;

  MeasurementModel({
    this.id,
    this.name,
    this.textEditingController,
    this.isSelected = false,
  });

  MeasurementModel.fromJson(Map<String, dynamic> json)
      : isSelected = false,
        textEditingController = TextEditingController() {
    id = json['id'];
    name = json['name'];
    textEditingController?.text = '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  MeasurementModel copyWith({
    int? id,
    String? name,
    TextEditingController? textEditingController,
    bool? isSelected,
  }) {
    return MeasurementModel(
      id: id ?? this.id,
      name: name ?? this.name,
      textEditingController: textEditingController ?? this.textEditingController,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  // Helper method to dispose the controller when no longer needed
  void dispose() {
    textEditingController?.dispose();
  }
}
