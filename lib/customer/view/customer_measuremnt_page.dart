import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tailor_mate/Items/repository/i_items_repository.dart';
import 'package:tailor_mate/Items/widget/check_list_widget.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/utility.dart';
import 'package:tailor_mate/customer/model/customer_item_detail_model.dart';
import 'package:tailor_mate/customer/repository/i_customer_repository.dart';
import 'package:tailor_mate/injector/injector.dart';
import 'package:tailor_mate/measurement/model/measurement_model.dart';
import 'package:tailor_mate/widget/app_text_form_field.dart';
import 'package:tailor_mate/widget/common_app_bar.dart';
import 'package:tailor_mate/widget/common_button.dart';

class CustomerMeasurentPage extends StatefulWidget {
  final int itemId;
  final int id;
  final String itemName;
  final bool isForEdit;

  const CustomerMeasurentPage({
    super.key,
    required this.itemId,
    required this.id,
    required this.itemName,
    this.isForEdit = false,
  });

  @override
  State<CustomerMeasurentPage> createState() => _CustomerMeasurentPageState();
}

class _CustomerMeasurentPageState extends State<CustomerMeasurentPage> {
  final _formKey = GlobalKey<FormState>();
  List<MeasurementModel>? measurementModel;
  List<MeasurementModel>? styleModel;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isButtionLoading = ValueNotifier(false);
  CustomerItemDetailModel? itemDetailOfCustomer;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isLoading.value = true;
    await getItemDetail();
    Future.delayed(const Duration(seconds: 1));
    if (widget.isForEdit) await getItemDetailById();
    isLoading.value = false;
  }

  Future<void> getItemDetail() async {
    final failOrSuccess = await getIt<IItemsRepository>().getItemsDetails(id: widget.itemId);
    failOrSuccess.fold(
      (l) {
        Utility.toast(message: l.message);
      },
      (r) {
        measurementModel = r.data?.measurements;
        styleModel = r.data?.styles;
        _notify();
      },
    );
  }

  Future<void> getItemDetailById() async {
    final failOrSuccess = await getIt<ICustomerRepository>().getCustomersItemDetails(id: widget.id);
    failOrSuccess.fold(
      (l) {
        Utility.toast(message: l.message);
      },
      (r) {
        itemDetailOfCustomer = r.data;

        // Set measurement values
        for (var i = 0; i < measurementModel!.length; i++) {
          for (var j = 0; j < itemDetailOfCustomer!.measurementRecords!.length; j++) {
            if (measurementModel![i].id == itemDetailOfCustomer!.measurementRecords![j].measurementId) {
              // measurementModel![i].textEditingController ??= TextEditingController();
              measurementModel![i].textEditingController!.text =
                  itemDetailOfCustomer!.measurementRecords![j].value ?? '';
            }
          }
        }

        for (var i = 0; i < styleModel!.length; i++) {
          for (var j = 0; j < itemDetailOfCustomer!.styleRecords!.length; j++) {
            if (styleModel![i].id == itemDetailOfCustomer!.styleRecords![j].itemStyleId) {
              styleModel![i].isSelected = true;
            }
          }
        }

        // // Set styles selection
        // for (var style in styleModel ?? []) {
        //   final matched = itemDetailOfCustomer?.styleRecords?.any((record) => record.itemStyleId == style.id) ?? false;
        //   style.isSelected = matched;
        // }

        _notify();
      },
    );
  }

  _notify() {
    setState(() {});
  }

  Future<void> addMeasurentTOCustomer() async {
    isButtionLoading.value = true;
    final item = await getIt<ICustomerRepository>().createCustomerMeasurent(
      customerId: widget.id,
      itemId: widget.itemId,
      styleIds: styleModel
              ?.where((e) => e.isSelected) // filter only selected
              .map((e) => e.id!) // safely unwrap since you only keep selected
              .toList() ??
          [],
      measurementList: measurementModel!,
    );
    item.fold((l) {
      Utility.toast(message: l.message);
    }, (r) {
      // Utility.toast(message: r.message);
      Navigator.pop(context, r.data);
    });
    isButtionLoading.value = false;
  }

  Future<void> updateMeasurentTOCustomer() async {
    isButtionLoading.value = true;
    final item = await getIt<ICustomerRepository>().updateCustomerMeasurent(
      id: widget.id,
      styleIds: styleModel
              ?.where((e) => e.isSelected) // filter only selected
              .map((e) => e.id!) // safely unwrap since you only keep selected
              .toList() ??
          [],
      measurementList: measurementModel!,
    );
    item.fold((l) {
      Utility.toast(message: l.message);
    }, (r) {
      // Utility.toast(message: r.message);
      Navigator.pop(context, r.data);
    });
    isButtionLoading.value = false;
  }

  void _saveData() {
    if (validateMeasurements()) {
      if (widget.isForEdit) {
        updateMeasurentTOCustomer();
      } else {
        addMeasurentTOCustomer();
        // print('addMeasurentTOCustomer');
      }
    }
  }

  bool validateMeasurements() {
    for (final element in measurementModel!) {
      if (element.textEditingController?.text.isEmpty ?? true) {
        Utility.toast(message: "Please enter ${element.name}");
        return false; // stop checking further
      }
    }
    if (styleModel!.where((element) => element.isSelected).isEmpty) {
      Utility.toast(message: "Please select at least one style");
      return false;
    }
    return true; // all good
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        title: "Item (${widget.itemName})",
        onBackTap: () => Navigator.pop(context),
        titleSpacing: 0,
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
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    /// Measurements section
                    Text(
                      "Measurements",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...measurementModel!.map((m) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            /// Label
                            Expanded(
                              flex: 2,
                              child: Text(
                                m.name ?? '',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),

                            /// Input Field
                            Expanded(
                              flex: 3,
                              child: AppTextFormField(
                                height: 40,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                controller: m.textEditingController ?? TextEditingController(),
                                // keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                                hintText: "",
                                // validator: (val) => val == null || val.isEmpty ? "Enter ${m.name}" : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    Text(
                      "Style",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AppCheckboxTile(
                            title: styleModel?[index].name ?? '',
                            value: styleModel?[index].isSelected ?? false,
                            onChanged: (val) {
                              setState(() {
                                styleModel?[index].isSelected = val;
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                              height: 0,
                              color: AppColors.primary,
                            ),
                        itemCount: styleModel?.length ?? 0),
                    const SizedBox(height: 20),
                    ValueListenableBuilder(
                        valueListenable: isButtionLoading,
                        builder: (context, value, _) {
                          return CommonButton(
                            text: "Save",
                            onTap: _saveData,
                            isLoading: value,
                          );
                        }),
                  ],
                ),
              ),
            );
          }),
    );
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
