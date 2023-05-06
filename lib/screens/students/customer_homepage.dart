import '../../utils/exports.dart';

// A page to display the available vendors for students
class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  List vendors = <QueryDocumentSnapshot>[];

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
        title: const Text(
          "Available Vendors",
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
        actions: const [CartButton()],
      ),
      // A stream builder to show the list of vendors
      body: StreamBuilder(
          stream: Services().getVendors(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              vendors = snapshot.data!.docs;
            }
            if (vendors.isNotEmpty) {
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  final vendor =
                      AppUser.fromJson(snapshot.data!.docs[index].data());
                  return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: VendorContainer(
                        vendor: vendor,
                        forRiders: false,
                      ));
                },
              );
            } else {
              return const Center(child: Text("No vendors available"));
            }
          }),
      // The drawer at the homepage
      drawer: AppDrawer(
        userType: user.value.userType!,
      ),
    );
  }
}
