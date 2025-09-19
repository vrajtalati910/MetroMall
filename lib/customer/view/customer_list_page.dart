import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tailor_mate/core/local_storage/i_local_storage_repository.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/utility.dart';
import 'package:tailor_mate/customer/model/customer_model.dart';
import 'package:tailor_mate/customer/repository/i_customer_repository.dart';
import 'package:tailor_mate/customer/view/add_new_customer_page.dart';
import 'package:tailor_mate/customer/view/customer_detail_page.dart';
import 'package:tailor_mate/customer/widget/customer_list_card.dart';
import 'package:tailor_mate/injector/injector.dart';
import 'package:tailor_mate/widget/app_text_form_field.dart';
import 'package:tailor_mate/widget/common_app_bar.dart';
import 'package:tailor_mate/widget/floating_action_widget.dart';
import 'package:tailor_mate/widget/logout_alert.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key, this.isStaff = false});
  final bool isStaff;

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final isLoading = ValueNotifier<bool>(false);
  final isPageLoading = ValueNotifier<bool>(false);
  final customerList = ValueNotifier<List<CustomerModel>>([]);
  int page = 0;
  bool stop = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    getCustomerList();
  }

  Future<void> getCustomerList() async {
    page += 1;
    if (page == 1) {
      isLoading.value = true;
    } else {
      isPageLoading.value = true;
    }

    final failOrSucess = await getIt<ICustomerRepository>().getCustomers(
      page: page,
      perPage: 10,
      search: _searchController.text,
    );

    failOrSucess.fold(
      (l) {
        isLoading.value = false;
        isPageLoading.value = false;
        Utility.toast(message: l.message);
      },
      (r) {
        if ((r.data?.length ?? 0) < 10) {
          stop = true;
        }
        customerList.value = [...customerList.value, ...r.data ?? []];

        isLoading.value = false;
        isPageLoading.value = false;
      },
    );
  }

  void _refresh() {
    stop = false;
    page = 0;
    customerList.value = [];
    getCustomerList();
  }

  final TextEditingController _searchController = TextEditingController();

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        titleSpacing: widget.isStaff ? 24 : 0,
        titleWidget: const Text("Customers"),
        isLeading: widget.isStaff ? false : true,
        onBackTap: () => Navigator.pop(context),
        actions: [
          if (widget.isStaff)
            IconButton(
              icon: const Icon(Icons.logout_sharp),
              onPressed: () =>
                  // Dialogs.showLogoutDialog(context),
                  showLogoutDialog(context, getIt<ILocalStorageRepository>()),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Search Bar
            AppTextFormField(
              controller: _searchController,
              label: "Search",
              prefixIcon: const Icon(Icons.search),
              textInputAction: TextInputAction.search,
              onChanged: (val) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _refresh();
                });
              },
            ),
            const SizedBox(height: 12),

            /// Customer List
            ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, load, _) {
                  if (load) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index) => _shimmer());
                  }
                  return ValueListenableBuilder<List<CustomerModel>>(
                    valueListenable: customerList,
                    builder: (context, list, _) {
                      if (list.isEmpty) {
                        return const Center(child: Text("No customers found"));
                      }
                      return Flexible(
                        child: RefreshIndicator(
                          onRefresh: () {
                            _refresh();
                            return Future.value();
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 75),
                            itemCount: list.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index == (list.length - 1)) {
                                return VisibilityDetector(
                                  key: Key(index.toString()),
                                  onVisibilityChanged: (info) {
                                    if (!isPageLoading.value && !stop) {
                                      getCustomerList();
                                    }
                                  },
                                  child: ValueListenableBuilder<bool>(
                                      valueListenable: isPageLoading,
                                      builder: (context, loading, _) {
                                        return Column(
                                          children: [
                                            customerCard(list[index]),
                                            if (loading) _shimmer(),
                                          ],
                                        );
                                      }),
                                );
                              }
                              return customerCard(list[index]);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }),
          ],
        ),
      ),

      /// FAB
      floatingActionButton: FloatingActionWidget(
        onPressed: () async {
          final newCustomer =
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CustomerFormPage()));
          if (newCustomer != null) {
            customerList.value = [newCustomer, ...customerList.value];
          }
        },
      ),
    );
  }

  Widget customerCard(CustomerModel customer) {
    return CustomerCard(
      customer: customer,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustomerDetailPage(
            customer: customer,
          ),
        ));
      },
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Avatar placeholder
            const CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 12),

            /// Name, phone, location placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 120,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 14,
                    width: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 12,
                    width: 80,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            /// Arrow placeholder
            Container(
              height: 16,
              width: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
