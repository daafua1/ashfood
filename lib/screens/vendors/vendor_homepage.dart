import '../../utils/exports.dart';

// A page to show the available menus for a vendor
class VendorHomepage extends StatefulWidget {
  const VendorHomepage({super.key});

  @override
  State<VendorHomepage> createState() => _VendorHomepageState();
}

class _VendorHomepageState extends State<VendorHomepage> {
  List<QueryDocumentSnapshot> menus = [];

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      Services().registerNotification();
      Services().configLocalNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      // The app bar
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        backgroundColor: Constants.appBarColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          user.value.name!,
          style: TextStyles.title,
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      // A stream builder to show the list of menus
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Available Menus',
              style: TextStyles.titleBlack,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: Services().getMenus(user.value.id!),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      menus = snapshot.data!.docs;
                    }
                    if (menus.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          final menu =
                              Menu.fromJson(snapshot.data!.docs[index].data());
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: MenuContainer(
                              menu: menu,
                              forVendor: true,
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No Menus yet"));
                    }
                  }),
            ),
          ],
        ),
      ),
      // The drawer at the homepage
      drawer: AppDrawer(
        userType: user.value.userType!,
      ),
    );
  }
}
