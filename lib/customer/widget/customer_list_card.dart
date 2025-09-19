import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tailor_mate/core/theme/app_assets.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/extentions/colors_extnetions.dart';
import 'package:tailor_mate/customer/model/customer_model.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onTap;
  final bool isForEdit;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onTap,
    this.isForEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
            /// Avatar
            CircleAvatar(
              radius: 26,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity2(0.1),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),

            /// Name, phone, location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name ?? "",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customer.mobile ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    customer.city ?? "",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),

            /// Action Icon
            if (isForEdit)
              InkWell(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: SvgPicture.asset(
                    AppAssets.editIcon,
                    height: 14,
                    width: 14,
                    colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                  ),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade500,
              ),
          ],
        ),
      ),
    );
  }
}
