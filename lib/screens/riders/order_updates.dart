import 'package:ashfood/utils/exports.dart';


class OrderUpdates extends StatefulWidget {
  final String orderId;
  const OrderUpdates({super.key, required this.orderId});

  @override
  State<OrderUpdates> createState() => _OrderUpdatesState();
}

class _OrderUpdatesState extends State<OrderUpdates> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.appBar('Order Update', false),
    );
  }
}