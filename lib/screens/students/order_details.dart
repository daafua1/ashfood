import 'package:ashfood/utils/exports.dart';

// A page to display the details of an order
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
  // The rating of the order by the user if the order is completed
  num rating = 0;
  // The controller for the review text field
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
              // a carousel slider to display the menu images
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
                  // a text to display the price of the menu
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
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // a text to display the rider details
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
                              // a rating bar to display the rider rating
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
                                  return const Icon(
                                    Icons.star,
                                    size: 10,
                                    color: Constants.appBarColor,
                                  );
                                },
                                onRatingUpdate: (rating) {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              height: 16,
                              width: 2,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 16),
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
              // a text to display the delivery location
              const Text('Delivery Location', style: TextStyles.titleBlack),
              const SizedBox(height: 7),
              Text(widget.order.user!.location!, style: TextStyles.bodyBlack),
              const SizedBox(height: 20),
              // a button to track the order if the order is not completed
              widget.order.status == 'completed'
                  ? const SizedBox.shrink()
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
              // a rating bar to rate the order if the order is completed
              widget.order.status == 'completed'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rate your experience',
                            style: TextStyles.buttonBlack),
                        const SizedBox(height: 10),
                        RatingBar.builder(
                          itemSize: 28,
                          //glowColor: Constants.appBarColor,
                          unratedColor: Colors.grey,
                          maxRating: 5,
                          minRating: 0,
                          allowHalfRating: true,
                          initialRating: rating.toDouble(),

                          itemBuilder: (_, rating) {
                            return const Icon(
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
                        const SizedBox(height: 10),
                        FormWidget(
                          controller: reviewController,
                          lableText: 'Comment',
                          textStyle: TextStyles.bodyBlack,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            if (rating != 0 &&
                                rating != widget.order.userRating) {
                              // a function to submit the rider review
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
                            }
                          },
                          // a button to submit the rider review
                          child: Container(
                            decoration: BoxDecoration(
                              color: Constants.appBarColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: const Center(
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

// a function to submit the rider review
  void submitRiderReview() async {
    num averageRating = 0.0;

    if (rider != null) {
      if (rider!.averageRating != null) {
        // averageRating =
        //     (rider!.averageRating! + rating) / (rider!.totalRating! + 1);

        FirebaseFirestore.instance.collection('users').doc(rider!.id).update({
          'averageRating': (rider!.averageRating! + rating) / 2,
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

// a function to get the rider details
  void getRider() async {
    AppUser? deliveryGuy = await Services.getAnyUser(widget.order.rider!.id!);
    setState(() {
      rider = deliveryGuy;
    });
  }
}
