import 'package:ashfood/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/order.dart';
import '../../utils/exports.dart';
import 'package:another_stepper/another_stepper.dart';

class TrackOrder extends StatefulWidget {
  final String orderId;
  const TrackOrder({super.key, required this.orderId});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  int? activeIndex;

  UserOrder? order;

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  void getOrder() async {
    final docOrder = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .get();
    if (docOrder.exists && docOrder.data() != null) {
      setState(() {
        order = UserOrder.fromJson(docOrder.data()!);
      });
      calculateActiveIndex();
    }
  }

  void calculateActiveIndex() {
    if (order != null) {
      final createdAt =
          DateTime.fromMillisecondsSinceEpoch(int.parse(order!.createdAt!));
      final now = DateTime.now();
      final difference = now.difference(createdAt).inMinutes;

      if (difference > 30) {
        setState(() {
          activeIndex = 2;
          print(difference);
        });
      }
      if(Utilities.timeToDispatch(createdAt)){
        setState(() {
          activeIndex = 3;
        });
      }
    }
  }

  List<StepperData> buildStepper() {
    List<StepperData> stepperData = [
      StepperData(
        title: StepperText(
          "Order Confirmed",
          textStyle: activeIndex! >= 1
              ? TextStyles.buttonBlack
              : TextStyles.activeTimeLine,
        ),
        subtitle: StepperText(
          "Your order has been confirmed",
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
          "Preparing",
          textStyle: activeIndex! >= 2
              ? TextStyles.buttonBlack
              : TextStyles.activeTimeLine,
        ),
        subtitle: StepperText(
          "Your order is being prepared",
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
          "On the way",
          textStyle: activeIndex! >= 3
              ? TextStyles.buttonBlack
              : TextStyles.activeTimeLine,
        ),
        subtitle: StepperText(
          "Our delivery executive is on the way to deliver your item",
          textStyle: activeIndex! >= 3
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
          child: const Icon(Icons.looks_3, color: Colors.white),
        ),
      ),
      StepperData(
        title: StepperText(
          "Delivered",
          textStyle: activeIndex! >= 4
              ? TextStyles.buttonBlack
              : TextStyles.activeTimeLine,
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.grey,
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: Constants.appBar('Track Order', true),
        body: order == null || activeIndex == null
            ? Center(
                child: Container(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 4,
                  ),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                ],
              ),
      ),
    );
  }
}
