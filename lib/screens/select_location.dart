import 'package:ashfood/controllers/auth_controller.dart';
import 'package:ashfood/screens/gmap.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:loader_overlay/loader_overlay.dart';
// ignore: depend_on_referenced_packages

import '../utils/exports.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({super.key});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];
  TextEditingController controller = TextEditingController();
  final authController = Get.put(AuthController());

  @override
  void initState() {
    googlePlace = GooglePlace('AIzaSyDzYdJqertRHdlzpDm1UHt2l3vMa5_Ow7M');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.appBar("Add Location",false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                try {
                  await _handlePermission(true, false);
                } catch (e) {
                  context.loaderOverlay.hide();
                  print(e.toString());
                  Fluttertoast.showToast(
                      msg:
                          'Network error occured. Please check your connectivity and try again');
                }
              },
              child: Row(
                children: [
                  const CircleAvatar(
                      radius: 18,
                      backgroundColor: Constants.appBarColor,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      )),
                  const SizedBox(width: 20),
                  Text(
                    "Use Current Location".tr,
                    style: TextStyles.buttonBlack,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                try {
                  Get.to(() => GMap(
                      lat: authController.lat.value,
                      long: authController.lat.value));
                } catch (e) {
                  context.loaderOverlay.hide();
                  print(e.toString());
                  Fluttertoast.showToast(
                      msg:
                          'Network error occured. Please check your connectivity and try again');
                }
                //context.loaderOverlay.hide();
              },
              child: Row(
                children: [
                  const CircleAvatar(
                      radius: 18,
                      backgroundColor: Constants.appBarColor,
                      child: Icon(
                        Icons.map,
                        color: Colors.white,
                      )),
                  const SizedBox(width: 20),
                  Text(
                    "Select Location on Map".tr,
                    style: TextStyles.buttonBlack,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FormWidget(
              textStyle: TextStyles.bodyBlack,
              lableText: "Search Location",
              controller: controller,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    predictions = [];
                  });
                } else {
                  autoCompleteSearch(value);
                }
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return locationWidget(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace!.autocomplete.get(value, region: 'gh');
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  locationWidget({required int index}) {
    return GestureDetector(
      onTap: () async {
        context.loaderOverlay.show();
        authController.location.value.text =
            '${predictions[index].description}';
        user.value.location = '${predictions[index].description}';
        try {
          List<Location> locations =
              await locationFromAddress(predictions[index].description!,localeIdentifier: 'en_GH');
          authController.lat.value = locations[0].latitude;
         authController.long.value = locations[0].longitude;
          user.value.lat = locations[0].latitude;
          user.value.long = locations[0].longitude;

          
          print(locations[0].toJson());
          context.loaderOverlay.hide();
          Get.back();
        } catch (e) {
          Fluttertoast.showToast(msg: "Could not find coordinates for this address. Please use other options", toastLength: Toast.LENGTH_LONG);
          context.loaderOverlay.hide();
          print(e.toString());
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Constants.appBarColor,
              radius: 18,
              child: Icon(
                Icons.location_on,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(predictions[index].structuredFormatting!.mainText ?? '',
                      style: TextStyles.titleBlack),
                  Text(
                    predictions[index].structuredFormatting!.secondaryText ??
                        '',
                    style: TextStyles.bodyBlack,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _handlePermission(bool getPlacemark, bool gotoMap) async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.dialog(
          AlertDialog(
            title: const Text('Alert'),
            content: const Text(
                'Please note: you need to allow location permission to use this feature'),
            actions: [
              TextButton(
                child: const Text('ok'),
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                  Get.back();
                },
              ),
            ],
          ),
        );
        return false;
      }
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (permission != LocationPermission.denied && !serviceEnabled) {
      try {
        await _getCurrentPosition(getPlacemark).whenComplete(() {
          context.loaderOverlay.hide();
          Get.back();
        });
      } catch (e) {
        context.loaderOverlay.hide();
      }
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      Get.dialog(
        AlertDialog(
          title: const Text('Alert'),
          content: const Text(
              'Please note: you need to allow location permission to use this feature'),
          actions: [
            TextButton(
              child: const Text('ok'),
              onPressed: () async {
                await Geolocator.openAppSettings();
                Get.back();
              },
            ),
          ],
        ),
      );
      return false;
    }

    await _getCurrentPosition(getPlacemark).whenComplete(() {
      context.loaderOverlay.hide();
      Get.back();
    });

    return true;
  }

  Future<void> _getCurrentPosition(
    bool getPlacemark,
  ) async {
    context.loaderOverlay.show();
    final position = await Geolocator.getCurrentPosition();
    authController.long.value = position.longitude;
    authController.lat.value = position.latitude;
    user.value.lat = position.latitude;
    user.value.long = position.longitude;
    if (getPlacemark) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
     authController.location.value.text =
          "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country}";
      user.value.location =  "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country}";
    }

    print(position.toJson());
  }
}
