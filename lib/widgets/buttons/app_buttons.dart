import 'package:flutter/material.dart';
import 'package:napon/core/helpers/app_styles.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final double curveRadius;
  final Function onTap;
  final Color buttonColor;
  final bool isDisabled;
  final Color disabledColor;
  final bool isLoading;
  final TextStyle? textStyle;
  final int? index;

  const AppButton(
      {Key? key,
      required this.title,
      this.width,
      required this.onTap,
      this.isDisabled = false,
      this.disabledColor = const Color(0xffe6eefc),
      this.buttonColor = Colors.green,
      this.isLoading = false,
      this.height,
      this.curveRadius = 10.0,
      this.textStyle,
      this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled == false ? () => onTap() : null,
      child: Container(
        child: Center(
          child: isLoading
              ? const SpinKitWave(
                  color: Colors.white,
                  type: SpinKitWaveType.center,
                )
              : Text(title, style: textStyle ?? AppStyles.appLightTextStyle),
        ),
        width: width ?? 80.0.w,
        height: height ?? 6.0.h,
        decoration: BoxDecoration(
          color: isDisabled == false ? buttonColor : disabledColor,
          borderRadius: BorderRadius.circular(curveRadius),
        ),
      ),
    );
  }
}
