import 'package:allia_health_inc_test_app/widget/dimensions.dart';
import 'package:allia_health_inc_test_app/widget/theme.dart';
import 'package:flutter/material.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    Key? key,
    this.buttonColor,
    this.onPressed,
    this.isOutlined = false,
    this.borderColor,
    this.textColor,
    required this.buttonText,
    this.height = 45,
    this.width,
    this.tapTargetSize,
  }) : super(key: key);

  final Function()? onPressed;
  final String buttonText;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final bool isOutlined;
  final double height;
  final double? width;
  final MaterialTapTargetSize? tapTargetSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? appColors.purple,
        elevation: 0,
        side: isOutlined
            ? BorderSide(
                color: borderColor ?? appColors.purple,
              )
            : BorderSide.none,
        minimumSize: Size(width?.dy ?? double.infinity, height.dy),
        tapTargetSize: tapTargetSize,
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor ?? appColors.white,
        ),
      ),
    );
  }
}
