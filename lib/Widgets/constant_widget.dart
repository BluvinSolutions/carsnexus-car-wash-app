import 'package:flutter/material.dart';

class HeightBox extends StatelessWidget {
  final double height;

  const HeightBox(
    this.height, [
    Key? key,
  ]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class WidthBox extends StatelessWidget {
  final double width;

  const WidthBox(
    this.width, [
    Key? key,
  ]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
