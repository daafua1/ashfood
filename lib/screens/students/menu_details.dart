import '../../utils/exports.dart';

// A page to display the details of a menu
class MenuDetails extends StatefulWidget {
  final Menu menu;
  const MenuDetails({super.key, required this.menu});

  @override
  State<MenuDetails> createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {
  int current = 0;
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Constants.appBar("Menu Details", true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  widget.menu.name!,
                  style: TextStyles.titleBlack,
                ),
                // a carousel slider to display the menu images
                CarouselSlider(
                  items:
                      widget.menu.media!.map((e) => Image.network(e)).toList(),
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
                  itemsLength: widget.menu.media!.length,
                  current: current,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Spacer(),
                    // a container to display the price of the menu
                    Container(
                      decoration: BoxDecoration(
                        color: Constants.appBarColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text('GHS ${widget.menu.price}',
                          style: TextStyles.button),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Description', style: TextStyles.titleBlack),
                const SizedBox(height: 10),
                Text(widget.menu.description!, style: TextStyles.bodyBlack),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // add the menu to cart
                          addToCart();
                        },
                        // a container to display the add to cart button
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Constants.appBarColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Center(
                              child: Text('Add to Cart',
                                  style: TextStyles.button)),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (quantity > 1) {
                                quantity--;
                              }
                            });
                          },
                          // a remove button to reduce the quantity of the menu to be added to cart by 1
                          child: Container(
                            decoration: BoxDecoration(
                              color: quantity == 1
                                  ? Constants.appBarColor.withOpacity(0.5)
                                  : Constants.appBarColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: const Center(
                                child: Text('-', style: TextStyles.button)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(quantity.toString(),
                              style: TextStyles.buttonBlack),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          // an add button to increase the quantity of the menu to be added to cart by 1
                          child: Container(
                            decoration: BoxDecoration(
                              color: Constants.appBarColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: const Center(
                                child: Text('+', style: TextStyles.button)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

// a function to add the menu to cart
  addToCart() {
    final docReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(DateTime.now().millisecondsSinceEpoch.toString() + user.value.id!);

    final CartItem order = CartItem(
      id: docReference.id,
      menu: widget.menu,
      quantity: quantity,
      user: user.value,
      userId: user.value.id,
    );
    FirebaseFirestore.instance.runTransaction(
        (transaction) async => transaction.set(docReference, order.toJson()));
    Fluttertoast.showToast(msg: 'Menu added to cart successfully');
  }
}
