import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:napon/core/helpers/app_colors.dart';
import 'package:napon/core/helpers/constants.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: AppColors.primaryColor,
        type: SpinKitWaveType.center,
      ),
    );
  }
}
