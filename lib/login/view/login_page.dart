import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tailor_mate/core/constant/app_string.dart';
import 'package:tailor_mate/core/local_storage/i_local_storage_repository.dart';
import 'package:tailor_mate/core/theme/app_assets.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/network/client.dart';
import 'package:tailor_mate/core/utils/utility.dart';
import 'package:tailor_mate/customer/view/customer_list_page.dart';
import 'package:tailor_mate/dashboard/view/dashboard_page.dart';
import 'package:tailor_mate/injector/injector.dart';
import 'package:tailor_mate/login/response/login_response.dart';
import 'package:tailor_mate/widget/app_svg_image.dart';
import 'package:tailor_mate/widget/app_text_form_field.dart';
import 'package:tailor_mate/widget/common_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final forgotEmailController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final obscurePassword = ValueNotifier<bool>(true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.appLogo, height: 100, width: 100),
                  const Gap(16),
                  Text('Tailor Mate',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary)),
                  const Gap(16),
                  AppTextFormField(
                    controller: emailController,
                    label: 'Email',
                    focusNode: emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const Gap(16),
                  ValueListenableBuilder<bool>(
                      valueListenable: obscurePassword,
                      builder: (context, obscure, _) {
                        return AppTextFormField(
                          controller: passwordController,
                          label: 'Password',
                          focusNode: passwordFocus,
                          obscureText: obscure,
                          suffixIcon: IconButton(
                            onPressed: () {
                              obscurePassword.value = !obscure;
                            },
                            icon: AppSvgImage(
                              obscure ? AppAssets.openEyeIcon : AppAssets.closeEyeIcon,
                            ),
                          ),
                        );
                      }),
                  const Gap(16),
                  Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: CommonButton(
                        text: 'Login',
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          login();
                        },
                      )),
                ]),
          ),
        ));
  }

  Future<void> login() async {
    final client = getIt<Client>();
    final loginResult = await client.post(
      url: AppStrings.login,
      requests: {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      },
    );
    return loginResult.fold(
      (l) {
        Utility.toast(message: l.message);
        log(l.toString());
      },
      (r) async {
        final response = LoginResponse.fromJson(r);
        if (response.status == 1) {
          log("LoginResponse: token=${response.token}, status=${response.status}");

          await getIt<ILocalStorageRepository>().setToken(response.token);
          await getIt<ILocalStorageRepository>().setUser(response.data);
          Utility.toast(message: response.message);
          if (response.data!.role?.toLowerCase() == 'admin') {
            Navigator.of(context)
                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const DashboardPage()), (_) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const CustomerListPage(
                          isStaff: true,
                        )),
                (_) => false);
          }
          // ignore: use_build_context_synchronously
        }
      },
    );
  }
}
