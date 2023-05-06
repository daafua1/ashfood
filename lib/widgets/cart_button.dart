import '../utils/exports.dart';

// The cart button widget
class CartButton extends StatefulWidget {
  const CartButton({super.key});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Services().getCart(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final cart = snapshot.data!.docs;
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Get.to(() => const CheckoutPage());
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Color(0xffffffff),
                    size: 24,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      cart.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
