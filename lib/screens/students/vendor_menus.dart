import 'package:ashfood/models/app_user.dart';
import 'package:ashfood/utils/exports.dart';
import 'package:ashfood/utils/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/menu.dart';
import '../../widgets/containers.dart';

class VendorMenus extends StatefulWidget {
  final AppUser vendor;
  const VendorMenus({super.key, required this.vendor});

  @override
  State<VendorMenus> createState() => _VendorMenusState();
}

class _VendorMenusState extends State<VendorMenus> {
  List<QueryDocumentSnapshot> menus = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.appBar(widget.vendor.name!,true),
      body: StreamBuilder(
        stream: Services().getMenus(widget.vendor.id!),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            menus = snapshot.data!.docs;
          }
          if (menus.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                final menu = Menu.fromJson(snapshot.data!.docs[index].data());
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: MenuContainer(menu: menu),
                );
              },
            );
          } else {
            return const Center(child: Text("No Menus yet"));
          }
        },
      ),
    );
  }
}
