import 'package:flutter/material.dart';
import 'package:napon/ui/home/homeScreen/home_screen.dart';
import 'package:napon/widgets/buttons/app_buttons.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 0.1, // Android only - API >= 28
      asAlarm: true, // Android only - all APIs
    );
    Vibration.hasVibrator().then((value) {
      if (value!) {
        Vibration.vibrate(repeat: 5);
      }
    });

    return Scaffold(
      body: SizedBox(
        height: 100.0.h,
        width: 100.0.w,
        child: Center(
          child: Lottie.asset('assets/images/ringing-bell-loop.json',
              height: 50.0.h, width: 80.0.w),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 10.0.h),
        child: AppButton(
          title: "Stop Napping",
          onTap: () async {
            //stop the napping,
            await FlutterRingtonePlayer.stop();
            Vibration.cancel();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false);
          },
        ),
      ),
    );
  }
}
