import 'package:flutter/material.dart';
import 'package:tailor_mate/Items/view/items_list_page.dart';
import 'package:tailor_mate/core/local_storage/i_local_storage_repository.dart';
import 'package:tailor_mate/core/theme/app_assets.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/customer/view/customer_list_page.dart';
import 'package:tailor_mate/dashboard/widget/dashboard_card_widget.dart';
import 'package:tailor_mate/injector/injector.dart';
import 'package:tailor_mate/measurement/view/measurement_page.dart';
import 'package:tailor_mate/widget/common_app_bar.dart';
import 'package:tailor_mate/widget/logout_alert.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        title: 'Dashboard',
        isLeading: false,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 16),
            icon: const Icon(Icons.logout_sharp),
            onPressed: () =>
                // Dialogs.showLogoutDialog(context),
                showLogoutDialog(context, getIt<ILocalStorageRepository>()),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          DashboardCardWidget(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MeasurementPage(),
                ),
              );
            },
            icon: AppAssets.measurementIcon,
            value: '',
            label: 'Measurements',
          ),
          DashboardCardWidget(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ItemListPage()));
            },
            icon: AppAssets.itemsIcon,
            value: '',
            label: 'Items',
          ),
          DashboardCardWidget(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CustomerListPage()));
            },
            icon: AppAssets.customerIcon,
            value: '',
            label: 'Customers',
          ),
        ],
      ),
    );
  }
}

 //for (var customer in customers) {
//                 debugPrint("🧑 Customer: ${customer.name} (ID: ${customer.id})");
//                 if (customer.itemsModel != null && customer.itemsModel!.isNotEmpty) {
//                   for (var i = 0; i < customer.itemsModel!.length; i++) {
//                     final item = customer.itemsModel![i];
//                     debugPrint("   📦 Item: ${customer.itemsModel![i].itemId} (ID: ${customer.itemsModel![i].id})");
//                     for (var j = 0; j < item.measurementRecords!.length; j++) {
//                       debugPrint(
//                           "   📦 Record: ${item.measurementRecords![j].measurement?.name} (ID: ${item.measurementRecords![j].value})");
//                     }
//                   }
//                 } else {
//                   debugPrint("   ⚠️ No items for this customer");
//                 }
//               }