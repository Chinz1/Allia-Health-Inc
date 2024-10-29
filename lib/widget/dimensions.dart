import 'dart:math';

import 'package:flutter/material.dart';

const double hPadding = 25;
const double vPadding = 10;

class Dims {
  const Dims._();

  static Size designSize = const Size(375, 812);

  static late Size deviceSize;

  static void setSize(MediaQueryData media) {
    deviceSize = Size(
      media.size.width,
      media.size.height,
    );
  }

  static double quotient(double dim1, double dim2) {
    return dim1 > dim2 ? dim1 / dim2 : dim2 / dim1;
  }

  static double space(double x) {
    final deviceRatio = quotient(deviceSize.height, deviceSize.width);
    final designRatio = quotient(designSize.height, designSize.width);
    final ratio = deviceRatio / designRatio;

    return ratio * x;
  }

  static double dxQuotient() {
    final quotient = deviceSize.width / designSize.width;

    return quotient;
  }

  static double dyQuotient() {
    final quotient = deviceSize.width / designSize.width;

    return quotient;
  }

  static double dxPercent(num extent) {
    return deviceSize.width * extent;
  }

  static double dyPercent(num extent) {
    return deviceSize.height * extent;
  }

  static double dx(num x) {
    final quotient = dxQuotient();

    return quotient * x;
  }

  static double dy(num x) {
    final quotient = dyQuotient();

    return quotient * x;
  }

  static double sp(num x) {
    final _dxQuotient = dxQuotient();
    final _dyQuotient = dyQuotient();
    final ratio = min(_dxQuotient, _dyQuotient);

    return ratio * x;
  }
}

extension DimsExtension on num {
  double get dx => Dims.dx(this);
  // vertical spacing
  double get dy => Dims.dy(this);
  // vertical spacing [in percentage]
  double get dyPercent => Dims.dyPercent(this);
  // horizontal spacing [in percentage]
  double get dxPercent => Dims.dxPercent(this);
  // font size
  double get sp => Dims.sp(this);
}

class XBox extends StatelessWidget {
   const XBox(this._width, {Key? key}) : super(key: key);

  final double _width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
    );
  }
}

class YBox extends StatelessWidget {
   const YBox(this._height, {Key? key}) : super(key: key);

  final double _height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
    );
  }
}
