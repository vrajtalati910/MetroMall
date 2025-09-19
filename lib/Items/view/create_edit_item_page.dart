import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tailor_mate/Items/model/items_model.dart';
import 'package:tailor_mate/Items/repository/i_items_repository.dart';
import 'package:tailor_mate/Items/widget/check_list_widget.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/utility.dart';
import 'package:tailor_mate/injector/injector.dart';
import 'package:tailor_mate/measurement/model/measurement_model.dart';
import 'package:tailor_mate/measurement/repository/i_measurement_repository.dart';
import 'package:tailor_mate/widget/app_text_form_field.dart';
import 'package:tailor_mate/widget/common_app_bar.dart';
import 'package:tailor_mate/widget/common_button.dart';

class ItemEditPage extends StatefulWidget {
  final ItemsModel? item;
  const ItemEditPage({super.key, this.item});

  @override
  State<ItemEditPage> createState() => _ItemEditPageState();
}

class _ItemEditPageState extends State<ItemEditPage> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isButtionLoading = ValueNotifier(false);

  Future<void> getItemDetail() async {
    final item = await getIt<IItemsRepository>().getItemsDetails(id: widget.item?.id ?? 0);
    item.fold(
        (l) => Utility.toast(
              message: l.message,
            ), (r) {
      _nameController.text = r.data!.name ?? '';
      selectedMeasurements = (r.data!.measurements ?? []);
      styleControllers = (r.data!.styles ?? []).map((s) => TextEditingController(text: s.name)).toList();
      _notify();
    });
  }

  Future<void> getAllMeasurements() async {
    final item = await getIt<IMeasurementRepository>().getMeasurements();
    item.fold(
        (l) => Utility.toast(
              message: l.message,
            ), (r) {
      allMeasurements = r.data ?? [];
      _notify();
      // Utility.toast(message: r.message);
    });
  }

  _notify() => setState(() {});

  final TextEditingController _nameController = TextEditingController();

  List<MeasurementModel> allMeasurements = [];
  List<MeasurementModel> selectedMeasurements = [];
  List<TextEditingController> styleControllers = [];

  @override
  void initState() {
    super.initState();
    inital();
  }

  inital() async {
    isLoading.value = true;
    await getAllMeasurements();
    _nameController.text = widget.item?.name ?? '';
    if (widget.item != null) {
      await getItemDetail();
    } else {
      styleControllers.add(TextEditingController());
    }
    isLoading.value = false;
  }

  void _addStyleField() {
    setState(() {
      styleControllers.add(TextEditingController());
    });
  }

  Future<void> createItem() async {
    isButtionLoading.value = true;
    final item = await getIt<IItemsRepository>().createItems(
      name: _nameController.text.trim(),
      measurements: selectedMeasurements,
      styles: styleControllers.map((c) => c.text.trim()).toList(),
    );
    item.fold((l) {
      Utility.toast(message: l.message);
    }, (r) {
      // Utility.toast(message: r.message);
      Navigator.pop(context, r.data);
    });
    isButtionLoading.value = false;
  }

  Future<void> editItem() async {
    isButtionLoading.value = true;

    // Current values from form
    final newMeasurements = selectedMeasurements;
    final newStyles = styleControllers.map((c) => c.text.trim()).toList();

    final item = await getIt<IItemsRepository>().updateItem(
      id: widget.item!.id!,
      name: _nameController.text.trim(),
      measurements: newMeasurements,
      styles: newStyles,
    );

    log('item: $item');

    item.fold((l) {
      Utility.toast(message: l.message);
    }, (r) {
      Navigator.pop(context, r.data);
    });
    isButtionLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CommonAppBar(
          titleSpacing: 0,
          titleWidget: Text(widget.item == null ? "Add Item" : "Edit Item"),
          isLeading: true,
          onBackTap: () => Navigator.pop(context),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12.0),
          child: ValueListenableBuilder(
              valueListenable: isButtionLoading,
              builder: (context, loading, child) {
                return CommonButton(
                  isLoading: loading,
                  text: "Save Item",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.item == null ? createItem() : editItem();
                    }
                  },
                );
              }),
        ),
        body: ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, load, _) {
              if (load) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: 5,
                  itemBuilder: (context, index) => _shimmer(),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      /// Item Name
                      AppTextFormField(
                        controller: _nameController,
                        label: "Item Name",
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (val) => val == null || val.isEmpty ? "Enter item name" : null,
                      ),
                      const SizedBox(height: 20),

                      /// Measurements with checkboxes
                      const Text(
                        "Measurements",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AppCheckboxTile(
                            title: allMeasurements[index].name ?? '',
                            value: selectedMeasurements.any((m) => m.id == allMeasurements[index].id),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  // Add if not already in list
                                  if (!selectedMeasurements.any((m) => m.id == allMeasurements[index].id)) {
                                    selectedMeasurements.add(allMeasurements[index]);
                                  }
                                } else {
                                  // Remove by ID
                                  selectedMeasurements.removeWhere((m) => m.id == allMeasurements[index].id);
                                }
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(height: 0),
                        itemCount: allMeasurements.length,
                      ),

                      const SizedBox(height: 20),

                      /// Styles section
                      const Text(
                        "Styles",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                        children: styleControllers
                            .asMap()
                            .entries
                            .map(
                              (entry) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: AppTextFormField(
                                  height: 50,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  controller: entry.value,
                                  // hintText: "Style ",
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.remove_circle, color: AppColors.red),
                                    onPressed: () {
                                      setState(() {
                                        styleControllers.removeAt(entry.key);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),

                      /// Add style button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CommonButton(
                            text: "Add Style",
                            onTap: _addStyleField,
                            maximumSize: const Size(120, 40),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Submit button
                    ],
                  ),
                ),
              );
            }));
  }

  _shimmer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
