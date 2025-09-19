import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tailor_mate/core/local_storage/i_local_storage_repository.dart';
import 'package:tailor_mate/core/theme/app_assets.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/customer/view/customer_list_page.dart';
import 'package:tailor_mate/dashboard/view/dashboard_page.dart';
import 'package:tailor_mate/login/view/login_page.dart';

final getIt = GetIt.instance;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isVerified = false;
  @override
  void initState() {
    super.initState();
    varifyUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.background,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.hardEdge,
                  height: 180,
                  width: 180,
                  child: Image.asset(
                    AppAssets.appLogo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> varifyUser() async {
    final localStorageRepository = getIt<ILocalStorageRepository>();

    final String? token = localStorageRepository.token;
    final userModel = localStorageRepository.getUser;

    Timer(
      const Duration(seconds: 3),
      (() {
        if (token != null && userModel != null) {
          if (userModel.role!.toLowerCase() == 'admin') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CustomerListPage(
                          isStaff: true,
                        )));
          }
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        }
      }),
    );
  }
}
