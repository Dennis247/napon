import 'dart:async';
import 'package:flutter/material.dart';
import 'package:napon/core/helpers/constants.dart';
import 'package:napon/ui/routeScreen/route_viewmodel.dart';
import 'package:napon/widgets/baseWidgets/connection_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:napon/widgets/loader/loader.dart';
import 'package:provider/provider.dart';

class RouteScreen extends StatefulWidget {
  final String myLocationPlaceId;
  final String myDestinationPlaceId;

  const RouteScreen(
      {Key? key,
      required this.myLocationPlaceId,
      required this.myDestinationPlaceId})
      : super(key: key);

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  //String _mapStyle = "";

  // ignore: unused_field
  BitmapDescriptor? _startIcon;
  // ignore: unused_field
  BitmapDescriptor? _endIcon;

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

    context.read<RouteViewModel>().setTripOnMap(
        startId: widget.myLocationPlaceId, endId: widget.myDestinationPlaceId);
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionWidget(
      childWidget: Consumer<RouteViewModel>(
        builder: (context, vm, _) => Stack(
          children: [
            vm.isLoadingMap
                ? const Loader()
                : GoogleMap(
                    mapType: MapType.normal,
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                    mapToolbarEnabled: true,
                    markers: vm.markers,
                    polylines: vm.polyline,
                    circles: vm.locationCircle,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                          vm.endPlaceAddress.latitude!,
                          vm.endPlaceAddress.longitude!,
                        ),
                        zoom: 3),
                    onMapCreated: (GoogleMapController controller) {
                      if (!_controller.isCompleted) {
                        _controller.complete(controller);
                        vm.setMapController(controller);
                        controller.setMapStyle(Constants.mapStyle);
                        //  Future.delayed(const Duration(seconds: 3));
                        controller.animateCamera(
                            CameraUpdate.newLatLngBounds(vm.bounds!, 100));
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
