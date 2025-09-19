import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tailor_mate/core/local_storage/i_local_storage_repository.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/utility.dart';
import 'package:tailor_mate/customer/model/customer_item_detail_model.dart';
import 'package:tailor_mate/customer/model/customer_item_local_model.dart';
import 'package:tailor_mate/customer/model/customer_model.dart';
import 'package:tailor_mate/customer/repository/i_customer_repository.dart';
import 'package:tailor_mate/injector/injector.dart';
import 'package:tailor_mate/widget/common_app_bar.dart';

class CustomerMeasurentDetailPage extends StatefulWidget {
  final int id;
  final String itemName;
  final CustomerModel? customerModel;

  const CustomerMeasurentDetailPage({
    super.key,
    required this.id,
    required this.itemName,
    this.customerModel,
  });

  @override
  State<CustomerMeasurentDetailPage> createState() => _CustomerMeasurentDetailPageState();
}

class _CustomerMeasurentDetailPageState extends State<CustomerMeasurentDetailPage> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  CustomerItemDetailModel? itemDetailOfCustomer;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isLoading.value = true;
    await getItemDetailById();
    isLoading.value = false;
  }

  Future<void> getItemDetailById() async {
    final failOrSuccess = await getIt<ICustomerRepository>().getCustomersItemDetails(id: widget.id);

    failOrSuccess.fold(
      (l) {
        Utility.toast(message: l.message);
      },
      (r) {
        itemDetailOfCustomer = r.data;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        title: "Item (${widget.itemName})",
        onBackTap: () => Navigator.pop(context),
        titleSpacing: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                final customerItem = CustomerItemLocalModel(
                  altMobile: widget.customerModel?.altMobile,
                  city: widget.customerModel?.city,
                  mobile: widget.customerModel?.mobile,
                  reference: widget.customerModel?.reference,
                  id: widget.id,
                  name: widget.customerModel?.name,
                  itemsModel: [itemDetailOfCustomer!],
                );
                getIt<ILocalStorageRepository>().setPrintData(customerItem);
              }),
        ],
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

          if (itemDetailOfCustomer == null) {
            return const Center(child: Text("No details found"));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
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
                ...itemDetailOfCustomer!.measurementRecords!.map((m) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            m.measurement?.name ?? '',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            m.value ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 20),

                /// Style section
                Text(
                  "Style",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...itemDetailOfCustomer!.styleRecords!.map((s) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "• ${s.style?.name ?? ''}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )),
              ],
            ),
          );
        },
      ),
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
