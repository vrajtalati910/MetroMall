import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_mate/core/theme/app_assets.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/utility.dart';
import 'package:tailor_mate/customer/model/customer_model.dart';
import 'package:tailor_mate/customer/repository/i_customer_repository.dart';
import 'package:tailor_mate/injector/injector.dart';
import 'package:tailor_mate/widget/app_text_form_field.dart';
import 'package:tailor_mate/widget/common_app_bar.dart';
import 'package:tailor_mate/widget/common_button.dart';

class CustomerFormPage extends StatefulWidget {
  final CustomerModel? customer; // For edit case
  const CustomerFormPage({super.key, this.customer});

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _altMobileController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? _localImage; // local picked file
  String? _networkImage; // existing profile URL from server

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _localImage = File(pickedFile.path);
        _networkImage = null; // clear old network if user selects new
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameController.text = widget.customer?.name ?? "";
      _mobileController.text = widget.customer?.mobile ?? "";
      _altMobileController.text = widget.customer?.altMobile ?? "";
      _cityController.text = widget.customer?.city ?? "";
      _referenceController.text = widget.customer?.reference ?? "";
      _networkImage = widget.customer?.imagePath;
    }
  }

  void _saveCustomer() async {
    if (_formKey.currentState!.validate()) {
      if (widget.customer != null) {
        final customer = await getIt<ICustomerRepository>().updateCustomer(
          id: widget.customer!.id!,
          name: _nameController.text.trim(),
          mobile: _mobileController.text.trim(),
          altMobile: _altMobileController.text.trim(),
          city: _cityController.text.trim(),
          reference: _referenceController.text.trim(),
          image: _localImage,
        );
        customer.fold((l) {
          Utility.toast(message: l.message);
        }, (r) {
          if (r.data != null) {
            // Utility.toast(message: r.message);
            Navigator.pop(context, r.data); // Return data to previous page
          }
        });
      } else {
        final customer = await getIt<ICustomerRepository>().createCustomer(
          name: _nameController.text.trim(),
          mobile: _mobileController.text.trim(),
          altMobile: _altMobileController.text.trim(),
          city: _cityController.text.trim(),
          reference: _referenceController.text.trim(),
          image: _localImage,
        );
        customer.fold((l) {
          Utility.toast(message: l.message);
        }, (r) {
          if (r.data != null) {
            // Utility.toast(message: r.message);
            Navigator.pop(context, r.data); // Return data to previous page
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        title: widget.customer == null ? "Add Customer" : "Edit Customer",
        titleSpacing: 0,
        onBackTap: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  if (kIsWeb) {
                    Utility.toast(message: "Only available for Android");
                  } else if (Platform.isAndroid) {
                    _pickImage();
                  } else {
                    Utility.toast(message: "Only available for Android");
                  }
                },
                child: _localImage != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(_localImage!),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ],
                      )
                    : (_networkImage != null && _networkImage!.isNotEmpty)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Utility.imageLoader(
                                url: _networkImage!,
                                placeholder: AppAssets.placeholder,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                isShapeCircular: false,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          )
                        : Image.asset(
                            AppAssets.pickProfileIcon,
                            height: 100,
                            width: 100,
                          ),
              ),
              const SizedBox(height: 20),

              // const SizedBox(height: 20),

              /// Name
              AppTextFormField(
                controller: _nameController,
                label: "Name",
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (val) => val == null || val.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 12),

              /// Mobile
              AppTextFormField(
                controller: _mobileController,
                label: "Mobile",
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (val) => val == null || val.isEmpty ? "Enter mobile" : null,
              ),
              const SizedBox(height: 12),

              /// Alt Mobile
              AppTextFormField(
                controller: _altMobileController,
                label: "Alt Mobile",
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),

              /// City
              AppTextFormField(
                controller: _cityController,
                label: "City",
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),

              /// Reference
              AppTextFormField(
                controller: _referenceController,
                label: "Reference",
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),

              /// Save Button
              CommonButton(
                text: "Save",
                onTap: _saveCustomer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
