// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:voyzo/HomeAndOrder/model/home_screen_response.dart';
// import 'package:voyzo/HomeAndOrder/shop_details_screen.dart';
// import 'package:voyzo/Theme/colors.dart';
// import 'package:voyzo/Theme/theme.dart';
// import 'package:voyzo/Widgets/constant_widget.dart';
// import 'package:flutter/material.dart';
//
// class ShopListTileWidget extends StatelessWidget {
//   final BestShops items;
//
//   const ShopListTileWidget({super.key, required this.items});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => ShopDetailsScreen(
//               id: items.id!,
//             ),
//           ),
//         );
//       },
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: AppBorderRadius.k08,
//             child: CachedNetworkImage(
//               imageUrl: items.imageUri!,
//               width: 60,
//               height: 60,
//               fit: BoxFit.cover,
//               progressIndicatorBuilder: (context, url, downloadProgress) =>
//                   CircularProgressIndicator(
//                 value: downloadProgress.progress,
//               ),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//             ),
//           ),
//           const WidthBox(15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   items.name!,
//                   style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 Text(
//                   items.address!,
//                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                         color: AppColors.subText,
//                         fontSize: 14,
//                       ),
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.star_rounded,
//                       color: AppColors.warningMedium,
//                     ),
//                     const WidthBox(3),
//                     Text(
//                       items.avgRating != null ? items.avgRating! : '0.0',
//                       style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                             color: AppColors.subText,
//                           ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voyzo/HomeAndOrder/model/home_screen_response.dart';
import 'package:voyzo/HomeAndOrder/shop_details_screen.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
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
          /// Shop Image
          ClipRRect(
            borderRadius: AppBorderRadius.k08,
            child: CachedNetworkImage(
              imageUrl: items.imageUri ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: downloadProgress.progress,
                      color: AppColors.primary,
                    ),
                  ),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                color: AppColors.subText,
              ),
            ),
          ),

          const WidthBox(15),

          /// Shop Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  items.name ?? "Unnamed Shop",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),

                /// ✅ Address — Inter Regular
                if (items.address != null && items.address!.isNotEmpty)
                  Text(
                    items.address!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.subText,
                    ),
                  ),

                /// ✅ Rating Row — Inter
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.warningMedium,
                      size: 18,
                    ),
                    const WidthBox(3),
                    Text(
                      items.avgRating ?? '0.0',
                      style: GoogleFonts.inter(
                        fontSize: 13,
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
