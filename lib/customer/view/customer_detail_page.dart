import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' as SharePlus;
import 'package:shimmer/shimmer.dart';
import 'package:tailor_mate/Items/model/items_model.dart';
import 'package:tailor_mate/Items/repository/i_items_repository.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/utility.dart';
import 'package:tailor_mate/customer/model/customer_item_detail_model.dart';
import 'package:tailor_mate/customer/model/customer_item_local_model.dart';
import 'package:tailor_mate/customer/model/customer_model.dart';
import 'package:tailor_mate/customer/repository/i_customer_repository.dart';
import 'package:tailor_mate/customer/view/add_new_customer_page.dart';
import 'package:tailor_mate/customer/view/customer_measurement_detail_page.dart';
import 'package:tailor_mate/customer/view/customer_measuremnt_page.dart';
import 'package:tailor_mate/customer/widget/customer_list_card.dart';
import 'package:tailor_mate/customer/widget/pdf_design.dart';
import 'package:tailor_mate/injector/injector.dart';
import 'package:tailor_mate/measurement/widget/measurement_card_widget.dart';
import 'package:tailor_mate/widget/common_app_bar.dart';
import 'package:tailor_mate/widget/floating_action_widget.dart';

class CustomerDetailPage extends StatefulWidget {
  final CustomerModel customer;

  const CustomerDetailPage({
    super.key,
    required this.customer,
  });

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  List<ItemsModel> allItemsList = [];
  CustomerModel? customer;
  // bool isLoading = true;
  final List<CustomerItemDetailModel> selectedItems = [];
  final isLoading = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    isLoading.value = true;
    await Future.wait([
      getItemsList(),
      getCustomerDetail(),
    ]);
    isLoading.value = false;
  }

  Future<void> getItemsList() async {
    final failOrSuccess = await getIt<IItemsRepository>().getItems();
    failOrSuccess.fold(
      (l) {
        Utility.toast(message: l.message);
      },
      (r) {
        allItemsList = r.data ?? [];
      },
    );
  }

  Future<void> getCustomerDetail() async {
    final failOrSuccess = await getIt<ICustomerRepository>().getCustomerDetails(id: widget.customer.id ?? 0);
    failOrSuccess.fold(
      (l) {
        Utility.toast(message: l.message);
      },
      (r) {
        customer = r.data;
      },
    );
  }

  // Get customer's current item IDs
  List<int> get customerItemIds {
    return customer?.customerItems?.map((item) => item.itemId ?? 0).toList() ?? [];
  }

  // Get customer's current items with full details
  List<ItemsModel> get customerItems {
    if (customer?.customerItems == null) return [];

    List<ItemsModel> items = [];
    for (var customerItem in customer!.customerItems!) {
      final item = allItemsList.firstWhere(
        (item) => item.id == customerItem.itemId,
        orElse: () => ItemsModel(id: 0, name: 'Unknown Item'),
      );
      if (item.id != 0) {
        items.add(item.copyWith(customerItemid: customerItem.id));
      }
    }
    return items;
  }

  // Get available items (not yet added to customer)
  List<ItemsModel> get availableItems {
    final customerItemIds = this.customerItemIds;
    return allItemsList.where((item) => !customerItemIds.contains(item.id)).toList();
  }

  /// Add new item bottom sheet
  void _showAddItemOptions() {
    final available = availableItems;

    if (available.isEmpty) {
      Utility.toast(message: "All items have been added to this customer");
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // curve top edges
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag handle (optional, nice UX)
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(
                "Add Items",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 16),

              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: available.length,
                  itemBuilder: (context, index) {
                    final item = available[index];
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        item.name ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.darkCerulean,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _addItemToCustomer(item);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Add item to customer (you'll need to implement the API call)
  Future<void> _addItemToCustomer(ItemsModel item) async {
    final newValue = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CustomerMeasurentPage(
          itemName: item.name ?? '',
          id: customer?.id ?? 0,
          itemId: item.id ?? 0,
        ),
      ),
    );
    if (newValue != null) {
      // customer?.customerItems?.add(CustomerItems(id: 0, customerId: customer?.id, itemId: item.id));
      _initializeData();
    }
  }

  /// Items title
  Widget _buildItemsTitle() {
    return Text(
      "Items",
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  /// Items list
  Widget _buildItemsList() {
    final items = customerItems;

    if (items.isEmpty) {
      return const Center(
        child: Text("No items added yet"),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final item = items[index];
        return MeasurementCardWidget(
          isCheckedUse: true,
          isChecked: selectedItems.any((ci) => ci.id == item.customerItemid),
          onCheckChanged: (value) {
            setState(() {
              final customerItem = customer?.customerItems?.firstWhere((ci) => ci.id == item.customerItemid);

              if (value ?? false) {
                if (customerItem != null && !selectedItems.contains(customerItem)) {
                  selectedItems.add(customerItem);
                }
              } else {
                selectedItems.removeWhere((ci) => ci.id == item.customerItemid);
              }
            });
          },
          onEdit: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CustomerMeasurentDetailPage(
                  itemName: item.name ?? '',
                  id: item.customerItemid ?? 0,
                  customerModel: customer,
                ),
              ),
            );
          },
          label: item.name ?? '',
          value: '',
          onTapEdit: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CustomerMeasurentPage(
                  isForEdit: true,
                  itemName: item.name ?? '',
                  id: item.customerItemid ?? 0,
                  itemId: item.id ?? 0,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customerData = widget.customer;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        title: "Customer Detail",
        titleSpacing: 0,
        onBackTap: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              if (selectedItems.isEmpty) {
                Utility.toast(message: "Please select at least one item");
                return;
              }

              final pdfData = await generateCustomerPdf(CustomerItemLocalModel(
                  name: customerData.name,
                  mobile: customerData.mobile,
                  altMobile: customerData.altMobile,
                  city: customerData.city,
                  reference: customerData.reference,
                  itemsModel: selectedItems));

              final now = DateTime.now();
              final formattedDate = DateFormat('dd-MM-yyyy').format(now);

              final dir = await getTemporaryDirectory();
              final file = File("${dir.path}/customer_data_$formattedDate.pdf");
              await file.writeAsBytes(pdfData);
              // Navigator.pop(context);
              await SharePlus.Share.shareXFiles(
                [SharePlus.XFile(file.path)],
                text: "Customer Data $formattedDate}",
              );
            },
          )
        ],
      ),
      body: ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, load, _) {
            if (load) return _shimmer();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Customer card using reusable widget
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  child: CustomerCard(
                    customer: customerData,
                    isForEdit: true,
                    onTap: () async {
                      final newValue = await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomerFormPage(
                                customer: customer,
                                // items: const [],
                              )));

                      if (newValue != null) {
                        setState(() {
                          customer = newValue;
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildItemsTitle(),
                ),
                const SizedBox(height: 8),
                Expanded(child: _buildItemsList()),
              ],
            );
          }),

      /// Reusable floating button
      floatingActionButton: FloatingActionWidget(
        onPressed: _showAddItemOptions,
        icon: Icons.add,
        backgroundColor: AppColors.primary,
      ),
    );
  }

  _shimmer() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
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
      ),
    );
  }
}
