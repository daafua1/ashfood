import '../utils/exports.dart';

// A get started page to select the user type
class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.appBarColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
              radius: 60,
            ),
            const SizedBox(height: 10),
            const Text(
              'ASHFOOD',
              style: TextStyles.title,
            ),
            const SizedBox(height: 50),
            const Text('Get Started as a', style: TextStyles.title),
            const SizedBox(height: 30),
            // A container to select for the vendor type
            getStartedContainer(
                text: 'Restaurant',
                icon: Icons.restaurant,
                onTap: () => Get.to(() => const SignUp(
                      userType: UserType.vendor,
                    ))),
            const SizedBox(height: 20),
            // A container to select for the rider type
            getStartedContainer(
                text: 'Rider',
                icon: Icons.motorcycle,
                onTap: () => Get.to(() => const SignUp(
                      userType: UserType.rider,
                    ))),
            const SizedBox(height: 20),
            // A container to select for the customer type
            getStartedContainer(
                text: 'Customer',
                icon: Icons.person,
                onTap: () => Get.to(() => const SignUp(
                      userType: UserType.customer,
                    ))),
          ],
        ),
      ),
    );
  }

// A container to select the user type
  getStartedContainer(
      {required String text,
      required IconData icon,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Constants.size.width * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: TextStyles.button),
            const SizedBox(width: 30),
            Icon(
              icon,
              size: 26,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
