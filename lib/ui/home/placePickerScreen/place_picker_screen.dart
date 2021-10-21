import 'package:flutter/material.dart';
import 'package:napon/core/helpers/app_styles.dart';
import 'package:napon/core/helpers/constants.dart';
import 'package:napon/core/model/autosugesstion.dart';
import 'package:napon/ui/home/homeScreen/home_viewmodel.dart';
import 'package:napon/ui/home/searchScreen/search_location_viewmodel.dart';
import 'package:napon/widgets/baseWidgets/connection_widget.dart';
//import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:napon/widgets/buttons/app_buttons.dart';
import 'package:sizer/sizer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class PlacePickerScreen extends StatelessWidget {
  static const routeName = "place-picker-screen";
  const PlacePickerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initialLocation = context.read<HomeViewModel>().currentPosition;
    return ConnectionWidget(
      childWidget: Stack(
        children: [
          SizedBox(
            height: 100.0.h,
            width: 100.0.w,
            child: PlacePicker(
              usePlaceDetailSearch: false,

              autocompleteLanguage: "en",
              automaticallyImplyAppBarLeading: false,
              strictbounds: true,
              onMapCreated: (controller) {
                controller.setMapStyle(Constants.mapStyle);
              },
              enableMyLocationButton: true,

              selectedPlaceWidgetBuilder:
                  (_, selectedPlace, state, isSearchBarFocused) {
                return isSearchBarFocused
                    ? Container()
                    : FloatingCard(
                        bottomPosition: 20,
                        leftPosition: 15,
                        rightPosition: 15,
                        width: 100.0.w,
                        height: 20.0.h,
                        borderRadius: BorderRadius.circular(10.0),
                        child: state == SearchingState.Searching
                            ? const Center(child: CircularProgressIndicator())
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${selectedPlace!.formattedAddress}",
                                        textAlign: TextAlign.center,
                                        style: AppStyles.appTextStyle),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AppButton(
                                      title: "Pick Place",
                                      onTap: () async {
                                        Navigator.of(context)
                                            .pop(selectedPlace);
                                      },
                                      width: 50.0.w,
                                    ),
                                  ],
                                ),
                              ));
              },
              apiKey: Constants.apiKey,
              initialPosition: LatLng(
                initialLocation!.latitude,
                initialLocation.longitude,
              ),
              useCurrentLocation: true,
              selectInitialPosition: true,

              //usePlaceDetailSearch: true,
              onPlacePicked: (PickResult result) {},
            ),
          ),
        ],
      ),
    );
  }
}
