import 'package:ashfood/screens/students/track_order.dart';
import 'package:ashfood/utils/exports.dart';
import 'package:ashfood/utils/services.dart';
import 'package:ashfood/widgets/pagination.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/app_user.dart';
import '../../models/order.dart';

class OrderDetails extends StatefulWidget {
  final UserOrder order;
  const OrderDetails({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  num rating = 0;
  TextEditingController reviewController = TextEditingController();
  int current = 0;
  AppUser? rider;

  @override
  void initState() {
    super.initState();
    getRider();
    if (widget.order.userComment != null) {
      setState(() {
        reviewController.text = widget.order.userComment!;
      });
    }
    if (widget.order.userRating != null) {
      setState(() {
        rating = widget.order.userRating!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.appBar('Order Details', true),
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
              const SizedBox(height: 7),
              Text(widget.order.menu!.description!,
                  style: TextStyles.bodyBlack),
              const SizedBox(height: 30),
              rider == null
                  ? SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Delivery Rider',
                            style: TextStyles.titleBlack),
                        const SizedBox(height: 7),
                        Text(rider!.name!, style: TextStyles.bodyBlack),
                        const SizedBox(height: 7),
                        Text(rider!.phoneNumber!, style: TextStyles.bodyBlack),
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
                                allowHalfRating: true,
                                initialRating: rider!.averageRating == null
                                    ? 0
                                    : rider!.averageRating!.toDouble(),
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
                                rider!.totalRating == null
                                    ? '0'
                                    : rider!.totalRating.toString(),
                                style: TextStyles.bodyBlack),
                          ],
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              const Text('Delivery Location', style: TextStyles.titleBlack),
              const SizedBox(height: 7),
              Text(widget.order.user!.location!, style: TextStyles.bodyBlack),
              const SizedBox(height: 20),
              widget.order.status == 'completed'
                  ? SizedBox.shrink()
                  : GestureDetector(
                      onTap: () => Get.to(() => TrackOrder(
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
              widget.order.status == 'completed'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rate your experience',
                            style: TextStyles.buttonBlack),
                        SizedBox(height: 10),
                        RatingBar.builder(
                          itemSize: 28,
                          //glowColor: Constants.appBarColor,
                          unratedColor: Colors.grey,
                          maxRating: 5,
                          minRating: 0,
                          allowHalfRating: true,
                          initialRating: rating.toDouble(),

                          itemBuilder: (_, rating) {
                            return Icon(
                              Icons.star,
                              size: 10,
                              color: Constants.appBarColor,
                            );
                          },
                          onRatingUpdate: (newRating) {
                            setState(() {
                              rating = newRating;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        FormWidget(
                          controller: reviewController,
                          lableText: 'Comment',
                          textStyle: TextStyles.bodyBlack,
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            if (rating != 0 && rating != widget.order.userRating) {
                             
                                submitRiderReview();
                              
                              FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(widget.order.id)
                                  .update({
                                'userRating': rating,
                                'userComment': reviewController.text
                              });

                              setState(() {
                                widget.order.userRating = rating;
                              });
                              Fluttertoast.showToast(msg: 'Review submitted');
                            } else {
                              print('not rated');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Constants.appBarColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Center(
                                child:
                                    Text('Submit', style: TextStyles.button)),
                          ),
                        ),
                        const SizedBox(height: 30)
                      ],
                    )
                  : const SizedBox(height: 20),
              const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  void submitRiderReview() async {
    num averageRating = 0.0;

    if (rider != null) {
      if (rider!.averageRating != null) {
        // averageRating =
        //     (rider!.averageRating! + rating) / (rider!.totalRating! + 1);

        FirebaseFirestore.instance.collection('users').doc(rider!.id).update({
          'averageRating': (rider!.averageRating! + rating)/2,
          'totalRating': rider!.totalRating! + 1
        });
      } else {
        averageRating = rating;
        FirebaseFirestore.instance
            .collection('users')
            .doc(rider!.id)
            .update({'averageRating': averageRating, 'totalRating': 1});
      }
    }
  }

  void getRider() async {
    AppUser? deliveryGuy = await Services.getAnyUser(widget.order.rider!.id!);
    setState(() {
      rider = deliveryGuy;
    });
  }
}
