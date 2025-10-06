import 'package:carq_user/HomeAndOrder/model/address_list_response.dart';
import 'package:carq_user/Theme/colors.dart';
import 'package:carq_user/Theme/theme.dart';
import 'package:flutter/material.dart';

class AddressListTile extends StatefulWidget {
  final bool isSelected;
  final AddressListData address;

  const AddressListTile(
      {super.key, this.isSelected = false, required this.address});

  @override
  State<AddressListTile> createState() => _AddressListTileState();
}

class _AddressListTileState extends State<AddressListTile> {
  @override
  void initState() {
    super.initState();
  }

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.address.type! == 0
                      ? "Home"
                      : widget.address.type! == 1
                          ? "Office"
                          : "Other",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.bodyText,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  widget.address.line1!,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.subText,
                      ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: widget.isSelected,
            onChanged: (bool? value) {},
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          ),
        ],
      ),
    );
  }
}
