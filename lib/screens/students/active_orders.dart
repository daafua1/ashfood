import 'package:ashfood/utils/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/order.dart';
import '../../utils/services.dart';
import '../../widgets/containers.dart';

class ActivieOrdersStudents extends StatefulWidget {
  const ActivieOrdersStudents({super.key});

  @override
  State<ActivieOrdersStudents> createState() => _ActivieOrdersStudentsState();
}

class _ActivieOrdersStudentsState extends State<ActivieOrdersStudents> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> orders = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Constants.appBar(
          'Active Orders',
          true,
        ),
        body: _buildOrderList());
  }

  Widget _buildOrderList() {
    return StreamBuilder(
      stream: Services().getOrders(user.value.id!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Future.delayed(Duration.zero, () {
            setState(() {
              orders = snapshot.data!.docs;
            });
          });

          if (orders.isNotEmpty) {
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final item = UserOrder.fromJson(orders[index].data());
                return OrderContainer(
                  forRiders: false,
                  order: item,
                );
              },
            );
          } else {
            return const Center(
              child: Text('No Items Found'),
            );
          }
        } else {
          return const Center(
            child: Text('No Items Found'),
          );
        }
      },
    );
  }
}
