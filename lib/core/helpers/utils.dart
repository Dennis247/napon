import 'package:flutter/cupertino.dart';

import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class Utils {
  static void showErrorSnackBar(
      {required BuildContext context, required String message}) {
    showTopSnackBar(
      context,
      CustomSnackBar.error(message: message,
      ),
    );
  }
}
