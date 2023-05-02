import 'package:ashfood/screens/riders/complain.dart';
import 'package:ashfood/screens/riders/order_updates.dart';
import 'package:ashfood/utils/exports.dart';
import 'package:ashfood/widgets/pagination.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/order.dart';

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
                        //enableInfiniteScroll: true,
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
                    const Text('Description', style: TextStyles.titleBlack),
                    const SizedBox(height: 10),
                    Text(widget.order.menu!.description!,
                        style: TextStyles.bodyBlack),
                    const SizedBox(height: 20),
                    widget.order.status == 'completed' ? SizedBox.shrink():
                    Padding(
                      padding:  EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () async {
                          final permistion = await Geolocator.checkPermission();
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
                              Text('View on Map', style: TextStyles.button),
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
                    widget.order.status == 'completed' ? SizedBox.shrink():
                    difference < 30 ? 
                   Text('Pickup in ${30 - difference} minutes', style: TextStyles.bodyRed):Text('Ready for pickup', style: TextStyles.bodyRed),
                    const SizedBox(height: 20),
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
                          onTap: () => Get.to(()=>Complain(order:widget.order)),
                            child: Container(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Constants.appBarColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text('File a Complain',
                                    style: TextStyles.button),
                              ),
                            ),
                          )
                        : SizedBox.fromSize(),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
            ),
    );
  }
}
