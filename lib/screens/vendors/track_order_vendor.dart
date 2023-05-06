import '../../utils/exports.dart';

// A page to track orders for vendors
class TrackOrderVendor extends StatefulWidget {
  final String orderId;
  const TrackOrderVendor({super.key, required this.orderId});

  @override
  State<TrackOrderVendor> createState() => _TrackOrderVendorState();
}

class _TrackOrderVendorState extends State<TrackOrderVendor> {
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
          "The order has been confirmed",
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
          "The order is being prepared",
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
          "The order has arrived at the specified location",
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
                      // A text to display the menu name
                      Text(order!.menu!.name!, style: TextStyles.buttonBlack),
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
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
