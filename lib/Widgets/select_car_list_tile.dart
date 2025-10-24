import 'package:voyzo/Localization/localization_constant.dart';
import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:voyzo/Widgets/constant_widget.dart';
import 'package:voyzo/lang_const.dart';
import 'package:flutter/material.dart';

class SelectCarListTile extends StatefulWidget {
  final bool isSelected;
  final Map<String, dynamic> vehicle;

  const SelectCarListTile(
      {super.key, this.isSelected = false, required this.vehicle});

  @override
  State<SelectCarListTile> createState() => _SelectCarListTileState();
}

class _SelectCarListTileState extends State<SelectCarListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Amount.screenMargin),
      decoration: BoxDecoration(
        color: widget.isSelected == true
            ? AppColors.primary.withAlpha(50)
            : AppColors.white,
        borderRadius: AppBorderRadius.k16,
        border: Border.all(
          color:
              widget.isSelected == true ? AppColors.primary : AppColors.stroke,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.vehicle['name'],
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.bodyText,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Checkbox(
                value: widget.isSelected,
                onChanged: (bool? value) {},
                visualDensity:
                    const VisualDensity(vertical: -4, horizontal: -4),
              ),
            ],
          ),
          const HeightBox(5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated(context, LangConst.registeredNum).toString(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.subText,
                        ),
                  ),
                  Text(
                    widget.vehicle['reg-num'],
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.bodyText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              )),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTranslated(context, LangConst.color).toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.subText,
                          ),
                    ),
                    Text(
                      widget.vehicle['color'],
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.bodyText,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
