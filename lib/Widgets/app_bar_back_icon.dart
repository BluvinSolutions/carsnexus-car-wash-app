import 'package:voyzo/Theme/colors.dart';
import 'package:voyzo/Theme/theme.dart';
import 'package:flutter/material.dart';

class AppBarBack extends StatelessWidget {
  const AppBarBack({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        margin: const EdgeInsetsDirectional.only(
          start: 8,
          top: 8,
          bottom: 8,
          end: 5,
        ),
        padding: const EdgeInsetsDirectional.only(
          top: 8,
          bottom: 8,
          start: 11,
          end: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.k10,
          border: Border.all(
            color: AppColors.stroke,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: AppColors.icon,
        ),
      ),
    );
  }
}
