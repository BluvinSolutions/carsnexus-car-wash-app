import 'package:cached_network_image/cached_network_image.dart';
import 'package:carq_user/HomeAndOrder/model/home_screen_response.dart';
import 'package:carq_user/HomeAndOrder/shop_details_screen.dart';
import 'package:carq_user/Theme/colors.dart';
import 'package:carq_user/Theme/theme.dart';
import 'package:carq_user/Widgets/constant_widget.dart';
import 'package:flutter/material.dart';

class ShopListTileWidget extends StatelessWidget {
  final BestShops items;

  const ShopListTileWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShopDetailsScreen(
              id: items.id!,
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppBorderRadius.k08,
            child: CachedNetworkImage(
              imageUrl: items.imageUri!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(
                value: downloadProgress.progress,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const WidthBox(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  items.name!,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  items.address!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.subText,
                        fontSize: 14,
                      ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.warningMedium,
                    ),
                    const WidthBox(3),
                    Text(
                      items.avgRating != null ? items.avgRating! : '0.0',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.subText,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
