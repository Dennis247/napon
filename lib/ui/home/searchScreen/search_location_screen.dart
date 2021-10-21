// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:napon/core/helpers/app_colors.dart';
import 'package:napon/core/helpers/app_styles.dart';
import 'package:napon/core/model/address.dart';
import 'package:napon/core/model/autosugesstion.dart';
import 'package:napon/ui/home/placePickerScreen/place_picker_screen.dart';
import 'package:napon/ui/home/searchScreen/search_location_viewmodel.dart';
import 'package:napon/widgets/baseWidgets/connection_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class SearchLocationScreen extends StatefulWidget {
  static const routeName = "place-picker-screen";
  const SearchLocationScreen({Key? key, required this.initialAddress})
      : super(key: key);

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
  final Address initialAddress;
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  // ignore: prefer_final_fields
  TextEditingController _myLoctionController = TextEditingController(text: "");
  // ignore: prefer_final_fields
  TextEditingController _myDestinationController =
      TextEditingController(text: "");

  FocusNode focusDestination = FocusNode();
  bool focused = false;
  PickResult? _pickResult;

  @override
  void initState() {
    _myLoctionController.text = widget.initialAddress.placeFormattedAddress!;
    context.read<SearchLocationViewModel>().setIsMyLocationSelected(true);
    context.read<SearchLocationViewModel>().setSugesstion(AutoSuggestion(
        placeId: widget.initialAddress.placeId!,
        mainText: widget.initialAddress.placeName!,
        secondaryText: widget.initialAddress.placeFormattedAddress!));
    super.initState();
  }

  void setFocusNode() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }

  Widget _buildSearchLocationWidget(
      {required String iconImage,
      required String hintText,
      required TextEditingController controller,
      required bool isMylocation,
      FocusNode? focusNode}) {
    final vm = context.read<SearchLocationViewModel>();
    return Row(
      children: [
        Image.asset(
          iconImage,
          scale: 3,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.colorLightGrayFair,
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextField(
                controller: controller,
                onTap: () {
                  vm.setIsMyLocationSelected(isMylocation);
                },
                onChanged: (value) {
                  // vm.setIsMyLocationSelected(isMylocation);
                  vm.searchPlace(value);
                },
                focusNode: focusNode,
                style: AppStyles.appTextStyle,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        top: 8, right: 8, left: 10, bottom: 8),
                    hintText: hintText,
                    hintStyle: AppStyles.appHintTextStyle,
                    fillColor: Colors.grey[300],
                    filled: true,
                    border: InputBorder.none,
                    isDense: true),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget suggestionTile(AutoSuggestion autoSuggestion) {
    return TextButton(
      onPressed: () async {
        final vm = context.read<SearchLocationViewModel>();

        if (vm.isMylocationSelected) {
          vm.setSugesstion(autoSuggestion);
          _myLoctionController.text = autoSuggestion.mainText;
          FocusScope.of(context).requestFocus(focusDestination);
          vm.setIsMyLocationSelected(false);
        } else {
          vm.setSugesstion(autoSuggestion);
          FocusScope.of(context).unfocus();
          _myDestinationController.text = autoSuggestion.mainText;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          children: [
            Icon(
              Icons.location_pin,
              size: 8.0.w,
              color: AppColors.colorDimText,
            ),
            SizedBox(
              width: 3.0.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Text(
                    autoSuggestion.mainText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.appTextStyle,
                  ),
                  Text(
                    autoSuggestion.secondaryText,
                    style: AppStyles.appHintTextStyle,
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setFocusNode();
    return ConnectionWidget(
      childWidget: SizedBox(
        width: 100.0.h,
        height: 100.0.h,
        child: Column(
          children: [
            Container(
              height: 30.0.h,
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7))
              ]),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.0.h,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.arrow_back)),
                        Center(
                          child: Text(
                            "Set Destination",
                            style: AppStyles.appBoldTextStyle,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    _buildSearchLocationWidget(
                        iconImage: "assets/images/start.png",
                        hintText: "Pick up Location",
                        controller: _myLoctionController,
                        isMylocation: true),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildSearchLocationWidget(
                        iconImage: "assets/images/end.png",
                        hintText: "Where To ?",
                        controller: _myDestinationController,
                        focusNode: focusDestination,
                        isMylocation: false),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Consumer<SearchLocationViewModel>(
                    builder: (context, vm, _) {
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            final suggestion = vm.autoSuggestionsList[index];
                            return suggestionTile(suggestion);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                                height: 1.0,
                                color: Color(0xFFe2e2e2),
                                thickness: 1.0,
                              ),
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: vm.autoSuggestionsList.length);
                    },
                  )),
            )
          ],
        ),
      ),
      bottomNavigator: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          _pickResult = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const PlacePickerScreen()));

          if (_pickResult != null) {
            var vm = context.read<SearchLocationViewModel>();
            if (vm.isMylocationSelected) {
              _myLoctionController.text = _pickResult!.formattedAddress!;
              FocusScope.of(context).requestFocus(focusDestination);
            } else {
              _myDestinationController.text = _pickResult!.formattedAddress!;
              FocusScope.of(context).unfocus();
            }

            vm.setSugesstion(
              AutoSuggestion(
                  placeId: _pickResult!.placeId!,
                  mainText: _pickResult!.formattedAddress!,
                  secondaryText: _pickResult!.formattedAddress!),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FontAwesomeIcons.mapPin,
                  size: 2.3.h, color: AppColors.primaryColor),
              SizedBox(
                width: 2.0.w,
              ),
              Text("Choose on map", style: AppStyles.appHintTextStyle)
            ],
          ),
          height: 8.0.h,
          width: 100.0.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x29000000),
                offset: Offset(0, -5),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Keys {}
