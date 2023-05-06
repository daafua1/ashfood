import '../utils/exports.dart';

// The custom popup widget is used to display a popup with a message and two buttons
class CustomPopUp extends StatelessWidget {
  const CustomPopUp({
    super.key,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onTapCancel,
    required this.onTapConfirm,
    this.showCancelButton = true,
    this.showConfirmButton = true,
  });
  // The message to display
  final String message;
  // The text for the confirm button
  final String confirmText;
  // The text for the cancel button
  final String cancelText;
  // The function to call when the confirm button is tapped
  final Function() onTapConfirm;
  // The function to call when the cancel button is tapped
  final Function() onTapCancel;
  // Whether to show the cancel button
  final bool showCancelButton;
  // Whether to show the confirm button
  final bool showConfirmButton;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color.fromARGB(255, 119, 117, 117),
                ),
              ),
            ),
            showConfirmButton
                ? GestureDetector(
                    onTap: onTapConfirm,
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(20),
                          ),
                          color: Constants.appBarColor),
                      child: Text(confirmText.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    ),
                  )
                : const SizedBox.shrink(),
            showCancelButton
                ? GestureDetector(
                    onTap: onTapCancel,
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(20),
                          ),
                          border: Border.all(width: 2, color: Colors.grey)),
                      child: Text(cancelText.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.grey,
                          )),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
