import 'package:flutter/material.dart';

void customBottomModal(BuildContext context,
    {Widget? child,
    double? height,
    bool isDismissible = true,
    double borderRadius = 50,
    bool enableDrag = true}) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      ),
    ),
    context: context,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
          ),
          height: height,
          child: child,
        ),
      );
    },
  );
}