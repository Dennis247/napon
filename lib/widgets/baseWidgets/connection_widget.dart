import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:sizer/sizer.dart';

class ConnectionWidget extends StatelessWidget {
  final Widget childWidget;
  const ConnectionWidget({Key? key, required this.childWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
          connectivityBuilder: (context, connectivity, child) {
            final bool connected = connectivity != ConnectivityResult.none;
            return Stack(
              fit: StackFit.expand,
              children: [
                childWidget,
                Positioned(
                  height: 24.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    color: connected ? Colors.green : const Color(0xFFEE4400),
                    child: Center(
                      child: Text(connected ? 'CONNECTED' : 'OFFLINE'),
                    ),
                  ),
                ),
              ],
            );
          },
          child: Container()),
    );
  }
}
