import 'package:ashfood/screens/vendors/track_order_vendor.dart';
import 'package:ashfood/utils/exports.dart';
import 'package:ashfood/widgets/pagination.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/order.dart';

class OrderDetailsVendor extends StatefulWidget {
  final UserOrder order;
  const OrderDetailsVendor({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsVendor> createState() => _OrderDetailsVendorState();
}

class _OrderDetailsVendorState extends State<OrderDetailsVendor> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.appBar('Order Details', false),
      body: SingleChildScrollView(
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
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Constants.appBarColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                        widget.order.quantity == 1
                            ? '${widget.order.quantity} Plate'
                            : '${widget.order.quantity} Plates',
                        style: TextStyles.button),
                  ),
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
              const SizedBox(height: 7),
              Text(widget.order.menu!.description!,
                  style: TextStyles.bodyBlack),
              const SizedBox(height: 30),
              const Text('Delivery Rider', style: TextStyles.titleBlack),
              const SizedBox(height: 7),
              Text(widget.order.rider!.name!, style: TextStyles.bodyBlack),
              const SizedBox(height: 7),
              Text(widget.order.rider!.phoneNumber!,
                  style: TextStyles.bodyBlack),
              const SizedBox(height: 7),
              Row(
                children: [
                  IgnorePointer(
                    child: RatingBar.builder(
                      itemSize: 20,
                      //glowColor: Constants.appBarColor,
                      unratedColor: Colors.grey,
                      maxRating: 5,
                      minRating: 0,
                      initialRating: widget.order.rider!.averageRating == null
                          ? 0
                          : widget.order.rider!.averageRating!.toDouble(),
                      itemBuilder: (_, rating) {
                        return Icon(
                          Icons.star,
                          size: 10,
                          color: Constants.appBarColor,
                        );
                      },
                      onRatingUpdate: (rating) {},
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    height: 16,
                    width: 2,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 16),
                  Text(
                      widget.order.rider!.totalRating == null
                          ? '0'
                          : widget.order.rider!.totalRating.toString(),
                      style: TextStyles.bodyBlack),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Delivery Location', style: TextStyles.titleBlack),
              const SizedBox(height: 7),
              Text(widget.order.user!.name!, style: TextStyles.bodyBlack),
              const SizedBox(height: 7),
              Text(widget.order.user!.phoneNumber!,
                  style: TextStyles.bodyBlack),
              const SizedBox(height: 7),
              Text(widget.order.user!.location!, style: TextStyles.bodyBlack),
              const SizedBox(height: 20),
              widget.order.status == 'completed'
                  ? SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(() => TrackOrderVendor(
                                orderId: widget.order.id!,
                              )),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Constants.appBarColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Track Order', style: TextStyles.button),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.timeline,
                                  size: 24,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (widget.order.isServed != true) {
                              FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(widget.order.id)
                                  .update({'isServed': true});
                              setState(() {
                                widget.order.isServed = true;
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.order.isServed == true
                                  ? Constants.appBarColor.withOpacity(0.5)
                                  : Constants.appBarColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                                widget.order.isServed == true
                                    ? 'Served'
                                    : 'Served?',
                                style: TextStyles.button),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
