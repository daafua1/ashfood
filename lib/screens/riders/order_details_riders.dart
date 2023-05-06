import 'package:ashfood/utils/exports.dart';

// A page for riders to view order details
class OrderDetailsRiders extends StatefulWidget {
  final UserOrder order;
  const OrderDetailsRiders({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsRiders> createState() => _OrderDetailsRidersState();
}

class _OrderDetailsRidersState extends State<OrderDetailsRiders> {
  int current = 0;
  bool gettingLocation = false;
  @override
  Widget build(BuildContext context) {
    final createdAt =
        DateTime.fromMillisecondsSinceEpoch(int.parse(widget.order.createdAt!));
    final now = DateTime.now();
    final difference = now.difference(createdAt).inMinutes;
    return Scaffold(
      appBar: Constants.appBar('Order Details', false),
      body: gettingLocation
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
                    const SizedBox(height: 20),
                    Text(
                      widget.order.menu!.name!,
                      style: TextStyles.titleBlack,
                    ),
                    // The carousel slider to display the images of the menu
                    CarouselSlider(
                      items: widget.order.menu!.media!
                          .map((e) => Image.network(e))
                          .toList(),
                      options: CarouselOptions(
                        height: 200,
                        padEnds: false,
                        disableCenter: true,
                        viewportFraction: 0.9,
                        initialPage: 0,
                        reverse: false,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            current = index;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Pagination(
                      itemsLength: widget.order.menu!.media!.length,
                      current: current,
                    ),
                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Spacer(),
                        // A Container to display the price of the menu
                        Container(
                          decoration: BoxDecoration(
                            color: Constants.appBarColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text('GHS ${widget.order.menu!.price}',
                              style: TextStyles.button),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // A text to display the description of the menu
                    const Text('Description', style: TextStyles.titleBlack),
                    const SizedBox(height: 10),
                    Text(widget.order.menu!.description!,
                        style: TextStyles.bodyBlack),
                    const SizedBox(height: 20),
                    widget.order.status == 'completed'
                        ? const SizedBox.shrink()
                        // View on map button to view the pickup and delivery locations on a map and to provide updates
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: GestureDetector(
                              onTap: () async {
                                final permistion =
                                    await Geolocator.checkPermission();
                                if (widget.order.status == "completed") {
                                  return;
                                }
                                setState(() {
                                  gettingLocation = true;
                                });
                                if (permistion == LocationPermission.denied) {
                                  await Geolocator.requestPermission();
                                  setState(() {
                                    gettingLocation = false;
                                  });
                                } else {
                                  await Geolocator.getCurrentPosition().then(
                                    (position) {
                                      setState(() {
                                        gettingLocation = false;
                                      });
                                      Get.to(
                                        () => OrderUpdates(
                                          orderId: widget.order.id!,
                                          position: position,
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.order.status == "completed"
                                      ? Constants.appBarColor.withOpacity(0.5)
                                      : Constants.appBarColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text('View on Map',
                                        style: TextStyles.button),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.map,
                                      size: 24,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    // A text to display the pickup time of the order
                    widget.order.status == 'completed'
                        ? const SizedBox.shrink()
                        : difference < 30
                            ? Text('Pickup in ${30 - difference} minutes',
                                style: TextStyles.bodyRed)
                            : const Text('Ready for pickup',
                                style: TextStyles.bodyRed),
                    const SizedBox(height: 20),
                    // A text to display the pickup information of the order.
                    const Text('Pick-Up Info', style: TextStyles.buttonBlack),
                    const SizedBox(height: 10),
                    Text(widget.order.menu!.vendor!.name!,
                        style: TextStyles.bodyBlack),
                    const SizedBox(height: 10),
                    Text(widget.order.menu!.vendor!.phoneNumber!,
                        style: TextStyles.bodyBlack),
                    const SizedBox(height: 10),
                    Text(widget.order.menu!.vendor!.location!,
                        style: TextStyles.bodyBlack),
                    const SizedBox(height: 20),
                    // A text to display the delivery information of the order
                    const Text('Delivery Info', style: TextStyles.buttonBlack),
                    const SizedBox(height: 10),
                    Text(widget.order.user!.name!, style: TextStyles.bodyBlack),
                    const SizedBox(height: 10),
                    Text(widget.order.user!.phoneNumber!,
                        style: TextStyles.bodyBlack),
                    const SizedBox(height: 10),
                    Text(widget.order.user!.location!,
                        style: TextStyles.bodyBlack),
                    const SizedBox(height: 20),

                    widget.order.status == 'completed'
                        ? GestureDetector(
                            onTap: () =>
                                Get.to(() => Complain(order: widget.order)),
                            // A button to file a complain about the order
                            child: Container(
                              decoration: BoxDecoration(
                                color: Constants.appBarColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: const Text('File a Complain',
                                  style: TextStyles.button),
                            ),
                          )
                        : SizedBox.fromSize(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
