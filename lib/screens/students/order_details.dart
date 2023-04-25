import 'package:ashfood/screens/students/track_order.dart';
import 'package:ashfood/utils/exports.dart';
import 'package:ashfood/widgets/pagination.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../models/order.dart';

class OrderDetails extends StatefulWidget {
  
  final UserOrder order;
  const OrderDetails({super.key, required this.order, });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  int current = 0;
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
              const SizedBox(height: 10),
              Text(widget.order.menu!.description!,
                  style: TextStyles.bodyBlack),
              const SizedBox(height: 30),
              const Text('Delivery Location', style: TextStyles.titleBlack),
              const SizedBox(height: 10),
              Text(widget.order.user!.location!,
                  style: TextStyles.bodyBlack),
              const SizedBox(height: 20),
              GestureDetector(
                onTap:()=>Get.to(() => TrackOrder(orderId: widget.order.id!,)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.appBarColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Text('Track Order', style: TextStyles.button),
                    SizedBox(width: 10),
                    Icon(Icons.timeline,size: 24,color: Colors.white,)
                  ],),
                ),
              )    
            ],
          ),
        ),
      ),
    );
  }
}
