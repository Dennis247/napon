import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:napon/home/home_viewmodel.dart';
import 'package:napon/widgets/baseWidgets/connection_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _mapStyle = "";

  // ignore: unused_field
  BitmapDescriptor? _startIcon;
  // ignore: unused_field
  BitmapDescriptor? _endIcon;

  final CameraPosition _lagos = const CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    initializeMapAppearance();
  }

  void initializeMapAppearance() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/start.png')
        .then((onValue) {
      _startIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/end.png')
        .then((onValue) {
      _endIcon = onValue;
    });

    rootBundle.loadString('assets/images/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionWidget(
      childWidget: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            mapToolbarEnabled: true,
            initialCameraPosition: _lagos,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              controller.setMapStyle(_mapStyle);
              context.read<HomeViewModel>().getCurrentPosition(controller);
            },
          ),
        ],
      ),
    );
  }
}
