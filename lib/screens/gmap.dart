import 'package:ashfood/controllers/auth_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../utils/exports.dart';

class GMap extends StatefulWidget {
  final double lat;
  final double long;
  const GMap({
    Key? key,
    required this.lat,
    required this.long,
  }) : super(key: key);

  @override
  State<GMap> createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  GoogleMapController? myMapController;
  late double markerlad;
  late double markerLong;
  final controller = Get.put(AuthController());

  @override
  void initState() {
    markerlad = 5.598804726505225;
    markerLong = -0.18236942589282992;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: GoogleMap(
          onCameraMove: (va) {
            setState(() {
              markerlad = va.target.latitude;
              markerLong = va.target.longitude;
            });
          },
          onMapCreated: (controller) {
            setState(() {
              myMapController = controller;
            });
          },
          onTap: (val) {},
          initialCameraPosition: const CameraPosition(
              target: LatLng(
                5.598804726505225,
                -0.18236942589282992,
              ),
              zoom: 13),
          markers: <Marker>{
            Marker(
                markerId: const MarkerId("location"),
                position: LatLng(markerlad, markerLong),
                onTap: () async {
                  await getAddressFromDevice(markerlad, markerLong);
                }),
          },
        ),
      ),
    );
  }

  Future<void> getAddressFromDevice(double lat, double long) async {
    print("$lat $long");
    context.loaderOverlay.show();
    try {
      // Get the address from the coordinates and put them into the various text editing controllers.
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      Placemark place = placemarks.last;
      print(place.toJson());
     controller.location.value.text =
          "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country}";
      controller.lat.value = lat;
      controller.long.value = long;
      user.value.location =  "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country}";
      user.value.lat = lat;
      user.value.long = long;
      context.loaderOverlay.hide();

      Get.close(2);
    } catch (e) {
      controller.lat.value = lat;
      controller.long.value = long;
     controller.location.value.text = "$lat, $long";
      user.value.lat = lat;
      user.value.long = long;
      user.value.location = "$lat, $long";
      print(e.toString());
      context.loaderOverlay.hide();
      Get.close(2);
    }
  }
}
