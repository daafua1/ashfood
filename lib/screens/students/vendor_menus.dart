import 'package:ashfood/utils/exports.dart';

// A page to display the available menus for a vendor
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
      // The list of menus
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
                  child: MenuContainer(menu: menu,forVendor: false,),
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
