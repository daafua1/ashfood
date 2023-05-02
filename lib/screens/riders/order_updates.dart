import 'dart:async';

import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:ashfood/utils/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/order.dart';
import '../../utils/services.dart';

class OrderUpdates extends StatefulWidget {
  final String orderId;
  Position position;
  OrderUpdates({super.key, required this.orderId, required this.position});

  @override
  State<OrderUpdates> createState() => _OrderUpdatesState();
}

class _OrderUpdatesState extends State<OrderUpdates> {
  int? activeIndex;
  Geolocator locator = Geolocator();
  UserOrder? order;

  @override
  void initState() {
    super.initState();
    getOrder();
    // getCurrentLocation();
    if (mounted) {
      positionStream();
    }else{
      positionStream().cancel();
    }
  }

  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCurrentLocation = [];
  // Rx<Position>? currentLocation;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 2,
  );

  // void getCurrentLocation() async {
  //   currentLocation = await Geolocator.getCurrentPosition().then((location) {
  //     setState(() {
  //       currentLocation = location;
  //     });

  //     print('init: $currentLocation');

  //   });
  // }

  StreamSubscription<Position> positionStream() =>
      Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position? newPosition) {
          if (newPosition != null) {
            widget.position = newPosition;

            setState(() {});
            print('stream: ${widget.position}');
          }
        },
      );
  @override
  void dispose(){
    super.dispose();
    positionStream().cancel();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    // if (order != null) {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDzYdJqertRHdlzpDm1UHt2l3vMa5_Ow7M',
      PointLatLng(order!.menu!.vendor!.lat!, order!.menu!.vendor!.long!),
      const PointLatLng(5.76172812553667, -0.2200464159250259),
    );
    PolylineResult resultCurrentLocation =
        await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDzYdJqertRHdlzpDm1UHt2l3vMa5_Ow7M',
      PointLatLng(widget.position.latitude, widget.position.longitude),
      PointLatLng(order!.menu!.vendor!.lat!, order!.menu!.vendor!.long!),
    );
    if (result.points.isNotEmpty) {
      print('adding');
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {});
      //}
    } else {
      print('no points');
    }
    if (resultCurrentLocation.points.isNotEmpty) {
      print('adding');
      resultCurrentLocation.points.forEach((PointLatLng point) {
        polylineCurrentLocation.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {});
      //}
    } else {
      print('no points');
    }
  }

  void getOrder() async {
    final docOrder = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .get();
    if (docOrder.exists && docOrder.data() != null) {
      setState(() {
        order = UserOrder.fromJson(docOrder.data()!);
        print('good order');
      });
      calculateActiveIndex();
      getPolyPoints();
    } else {
      print('no order');
    }
  }

  void calculateActiveIndex() {
    if (order != null) {
      switch (order!.riderStatus) {
        case 1:
          activeIndex = 1;
          break;
        case 2:
          activeIndex = 2;
          break;
        case 3:
          activeIndex = 3;
          break;
        default:
          activeIndex = 0;
      }
    } else {
      activeIndex = 0;
    }
    print('activeIndex: $activeIndex');
  }

  List<StepperData> buildStepper() {
    List<StepperData> stepperData = [
      StepperData(
        title: StepperText(
          "Dispatched",
          textStyle: activeIndex! >= 1
              ? TextStyles.buttonBlack
              : TextStyles.activeTimeLine,
        ),
        subtitle: StepperText(
          "Let the user know your are comming",
          textStyle: activeIndex! >= 1
              ? TextStyles.bodyBlack
              : TextStyles.activeTimeLineBody,
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Constants.appBarColor,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: const Icon(Icons.looks_one, color: Colors.white),
        ),
      ),
      StepperData(
        title: StepperText(
          "Arrived",
          textStyle: activeIndex! >= 2
              ? TextStyles.buttonBlack
              : TextStyles.activeTimeLine,
        ),
        subtitle: StepperText(
          "Let the the user know you're are the location",
          textStyle: activeIndex! >= 2
              ? TextStyles.bodyBlack
              : TextStyles.activeTimeLineBody,
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Constants.appBarColor,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: const Icon(Icons.looks_two, color: Colors.white),
        ),
      ),
      StepperData(
        title: StepperText(
          "Delivered",
          textStyle: activeIndex! >= 3
              ? TextStyles.buttonBlack
              : TextStyles.activeTimeLine,
        ),
        subtitle: StepperText(
          "Confirm you have delivered the food",
          textStyle: activeIndex! >= 3
              ? TextStyles.bodyBlack
              : TextStyles.activeTimeLineBody,
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: activeIndex! >= 3 ? Constants.appBarColor : Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
    ];
    return stepperData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.appBar('Order Update', false),
      body: order == null || activeIndex == null
          ? const Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 4,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Constants.size.width * 0.55,
                              child: AnotherStepper(
                                stepperList: buildStepper(),
                                stepperDirection: Axis.vertical,
                                iconWidth: 40,
                                iconHeight: 40,
                                activeBarColor: Constants.appBarColor,
                                inActiveBarColor: Colors.grey,
                                inverted: false,
                                verticalGap: 30,
                                activeIndex: activeIndex!,
                                barThickness: 8,
                              ),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Services().sendNotification(title: order!.menu!.name!, message: 'The rider is on his way', token: order!.user!.fcmToken!);
                                    if (activeIndex! < 1) {
                                      setState(() {
                                        activeIndex = 1;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(order!.id)
                                          .update(
                                        {'riderStatus': 1},
                                      );
                                      if (order!.user!.fcmToken != null &&
                                          order!.user!.fcmToken!.isNotEmpty) {
                                        Services().sendNotification(
                                            token: order!.user!.fcmToken!,
                                            content:
                                                'The rider is on his way to deliver your food',
                                            heading: order!.menu!.name!);
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 30),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Constants.appBarColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      activeIndex! >= 1
                                          ? 'Confirmed'
                                          : 'Confirm',
                                      style: TextStyles.button,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (activeIndex! < 2) {
                                      setState(() {
                                        activeIndex = 2;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(order!.id)
                                          .update(
                                        {'riderStatus': 2},
                                      );
                                      if (order!.user!.fcmToken != null &&
                                          order!.user!.fcmToken!.isNotEmpty) {
                                        Services().sendNotification(
                                            token: order!.user!.fcmToken!,
                                            content:
                                                'The rider has arrived at your location',
                                            heading: order!.menu!.name!);
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 60),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: activeIndex! >= 1
                                          ? Constants.appBarColor
                                          : Constants.appBarColor
                                              .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      activeIndex! >= 2
                                          ? 'Confirmed'
                                          : 'Confirm',
                                      style: TextStyles.button,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (activeIndex! < 3) {
                                      setState(() {
                                        activeIndex = 3;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(order!.id)
                                          .update(
                                        {
                                          'riderStatus': 3,
                                          'status': 'completed'
                                        },
                                      );
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(order!.riderId)
                                          .update({
                                        "numOfOrders":
                                            order!.rider!.numOfOrders! - 1,
                                      });
                                      if (order!.user!.fcmToken != null &&
                                          order!.user!.fcmToken!.isNotEmpty) {
                                        Services().sendNotification(
                                            token: order!.user!.fcmToken!,
                                            content:
                                                'Your order has been delivered. Thank you for using our service. Please rate the rider',
                                            heading: order!.menu!.name!);
                                      }
                                      if (order!.menu!.vendor!.fcmToken !=
                                              null &&
                                          order!.user!.fcmToken!.isNotEmpty) {
                                        Services().sendNotification(
                                            token: order!.user!.fcmToken!,
                                            content:
                                                'The rider has delivered the order to the customer',
                                            heading:
                                                "${order!.user!.name}: ${order!.menu!.name!}");
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 60),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: activeIndex! >= 2
                                          ? Constants.appBarColor
                                          : Constants.appBarColor
                                              .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      activeIndex! >= 3
                                          ? 'Confirmed'
                                          : 'Confirm',
                                      style: TextStyles.button,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: Constants.size.width,
                      height: Constants.size.height * 0.4,
                      child:
                          // currentLocation == null
                          //     ? Center(
                          //         child: Text(
                          //           'Loading Map...',
                          //           style: TextStyles.bodyBlack,
                          //         ),
                          //       )
                          //     :
                          GoogleMap(
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            order!.menu!.vendor!.lat!,
                            order!.menu!.vendor!.long!,
                          ),
                          zoom: 12,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('pickup'),
                            position: LatLng(
                              order!.menu!.vendor!.lat!,
                              order!.menu!.vendor!.long!,
                            ),
                            infoWindow: InfoWindow(
                                title: order!.menu!.vendor!.name!,
                                snippet: 'Pickup Location'),
                          ),
                          Marker(
                            markerId: MarkerId('destination'),
                            position: LatLng(
                              5.76172812553667,
                              -0.2200464159250259,
                            ),
                            infoWindow: InfoWindow(
                                title: order!.user!.name,
                                snippet: 'Delivery Location'),
                          ),
                        },
                        polylines: {
                          Polyline(
                            polylineId: PolylineId('route'),
                            points: polylineCoordinates,
                            color: Constants.appBarColor,
                            width: 5,
                          ),
                          Polyline(
                            polylineId: PolylineId('currentRoute'),
                            points: polylineCurrentLocation,
                            color: Color.fromARGB(255, 63, 145, 131),
                            width: 5,
                          ),
                        },
                        onTap: (position) {
                          print(position.latitude);
                          print(position.longitude);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
