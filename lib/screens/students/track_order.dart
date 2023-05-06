import '../../utils/exports.dart';

// A page to track order for students
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

// A method to get the order
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
    } else {
    }
  }

// A method to calculate the active index of the stepper based on the order status
  void calculateActiveIndex() {
    if (order != null) {
      final createdAt =
          DateTime.fromMillisecondsSinceEpoch(int.parse(order!.createdAt!));
      final now = DateTime.now();
      final difference = now.difference(createdAt).inMinutes;

      if (difference > 30) {
        setState(() {
          activeIndex = 2;
        });
      } else {
        activeIndex = 1;
      }
      if (order!.riderStatus == 1) {
        setState(() {
          activeIndex = 3;
        });
      }
      if (order!.riderStatus == 2) {
        setState(() {
          activeIndex = 4;
        });
      }
      if (order!.riderStatus == 3) {
        setState(() {
          activeIndex = 5;
        });
      }
    }
  }

// A method to build the stepper
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
          "Order Arrived",
          textStyle: activeIndex! >= 4
              ? TextStyles.buttonBlack
              : TextStyles.activeTimeLine,
        ),
        subtitle: StepperText(
          "Your order has arrived at the specified location",
          textStyle: activeIndex! >= 4
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
          child: const Icon(Icons.looks_4, color: Colors.white),
        ),
      ),
      StepperData(
        title: StepperText(
          "Delivered",
          textStyle: activeIndex! >= 5
              ? TextStyles.buttonBlack
              : TextStyles.activeTimeLine,
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: activeIndex! >= 5 ? Constants.appBarColor : Colors.grey,
            borderRadius: const BorderRadius.all(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      // A text to show the menu name and vendor name
                      Text(
                          "${order!.menu!.name!}: ${order!.menu!.vendor!.name}",
                          style: TextStyles.buttonBlack),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        // The stepper widget
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
                      const SizedBox(height: 30),
                      // A cancel button to cancel the order if the order is not 30 minutes old
                      activeIndex! <= 1
                          ? Container(
                              decoration: BoxDecoration(
                                color: Constants.appBarColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            // A custom popup to confirm the cancellation of the order
                                            return CustomPopUp(
                                              message:
                                                  'Are you sure you want to cancel this order?',
                                              confirmText: 'Yes, Cancel',
                                              cancelText: "No, Don't Cancel",
                                              onTapCancel: () => Get.back(),
                                              onTapConfirm: () {
                                                // Updating the status of the order to cancelled
                                                FirebaseFirestore.instance
                                                    .collection('orders')
                                                    .doc(order!.id)
                                                    .update({
                                                  'status': 'cancelled'
                                                }).then((value) {
                                                  Fluttertoast.showToast(
                                                      msg: 'Order cancelled');
                                                  Get.close(3);
                                                });
                                              },
                                            );
                                          });
                                    },
                                    child: const Text('Cancel Order',
                                        style: TextStyles.button),
                                  ),
                                  const SizedBox(width: 10),
                                  const JustTheTooltip(
                                    showDuration: Duration(seconds: 3),
                                    content: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'You can cancel your order withing 30 minutes of placing it.',
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
