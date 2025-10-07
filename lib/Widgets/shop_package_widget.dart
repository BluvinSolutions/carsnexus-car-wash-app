import 'package:carsnexus_user/HomeAndOrder/model/shop_details_response.dart';
import 'package:carsnexus_user/Theme/colors.dart';
import 'package:carsnexus_user/Theme/theme.dart';
import 'package:flutter/material.dart';

class ShopPackageWidget extends StatelessWidget {
  final PackageData package;

  const ShopPackageWidget({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius.k16,
        border: Border.all(
          color: AppColors.stroke,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(50),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  package.name!,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${package.currency}${package.price!}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Amount.screenMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: package.packageServiceData!.length,
                  itemBuilder: (context, index) => Text(
                    "• ${package.packageServiceData![index].name}",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.subText,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
