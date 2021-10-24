import 'dart:async';
import 'package:flutter/material.dart';
import 'package:napon/core/helpers/app_styles.dart';
import 'package:napon/core/helpers/constants.dart';
import 'package:napon/ui/routeScreen/route_viewmodel.dart';
import 'package:napon/ui/routeScreen/trip_duration_viewmodel.dart';
import 'package:napon/widgets/baseWidgets/connection_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:napon/widgets/buttons/app_buttons.dart';
import 'package:napon/widgets/loader/loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

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

    final routeVm = context.read<RouteViewModel>();

    routeVm.setTaxiIconMarker();

    routeVm
        .setTripOnMap(
            startId: widget.myLocationPlaceId,
            endId: widget.myDestinationPlaceId)
        .whenComplete(() => context
            .read<TripDurationViewModel>()
            .setTripDirection(routeVm.directionDetails));
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    context.read<RouteViewModel>().mapController.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      check(u, c);
    }
  }

  Future<void> startNapping() async {
    final routeVM = context.read<RouteViewModel>();
    final tripVM = context.read<TripDurationViewModel>();

    //start timer counter
//    tripVM.startTripTimer();

    //get real time update of taxi moving
    routeVM.setNapLocationUpdate(context);

    //end timer & nap when it get to destination
  }

  Future<void> endNap() async {
    //end timer

    //end nap

    //go to end Nap SCreen
  }

  @swidget
  _buildAddressWIdget(String icon, String address) {
    return Row(
      children: <Widget>[
        Image.asset(
          icon,
          scale: 3.5,
        ),
        SizedBox(
          width: 2.0.w,
        ),
        Expanded(
          child: Container(
            child: Text(
              address,
              style: AppStyles.appTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  @swidget
  Widget napDetails() {
    final routeVm = context.read<RouteViewModel>();
    return Consumer<TripDurationViewModel>(
      builder: (conntext, vm, _) => Container(
          height: 35.0.h,
          width: 100.0.w,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7))
              ]),
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 2.5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Estimated Nap Time",
                          style: AppStyles.cardMediumBoldDarkTextStyle
                              .copyWith(fontSize: 2.2.h)),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          vm.tripDuration,
                          style: AppStyles.appPurpleTextStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.5.h,
                  ),
                  _buildAddressWIdget(
                    'assets/images/start.png',
                    routeVm.startPlaceAddress.placeFormattedAddress!,
                  ),
                  SizedBox(
                    height: 2.0.h,
                  ),
                  _buildAddressWIdget(
                    'assets/images/end.png',
                    routeVm.endPlaceAddress.placeFormattedAddress!,
                  ),
                  SizedBox(
                    height: 4.0.h,
                  ),
                  AppButton(
                    title: "Start Napping",
                    onTap: () {
                      startNapping();
                    },
                    width: 100.0.w,
                  )
                  // Consumer<NewTripViewModel>(
                  //   builder: (context, ntv, _) => TaxiButton(
                  //     title: ntv.tripPendingAction,
                  //     containerColor: ntv.tripPendingActionColor,
                  //     appTextStyle: AppStyles.appBoldWhiteTextStyle,
                  //     onPressed: () async {
                  //       await ntv.updateTripPendingAction(
                  //           ntv.tripPendingAction, context);
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          )),
    );
  }

  @swidget
  Widget mapWidget() {
    final vm = context.read<RouteViewModel>();
    return SizedBox(
      height: 65.0.h,
      width: 100.0.w,
      child: GoogleMap(
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
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (!_controller.isCompleted) {
              _controller.complete(controller);
              vm.setMapController(controller);
              controller.setMapStyle(Constants.mapStyle);
              CameraUpdate u2 = CameraUpdate.newLatLngBounds(vm.bounds!, 75);
              controller.animateCamera(u2).then((void v) {
                check(u2, controller);
              });
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionWidget(
      childWidget: Consumer<RouteViewModel>(
        builder: (context, vm, _) => Stack(
          children: [
            vm.isLoadingMap
                ? const Loader()
                : Column(
                    children: [mapWidget(), napDetails()],
                  ),
          ],
        ),
      ),
    );
  }
}
