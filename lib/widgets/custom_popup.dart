import '../utils/exports.dart';

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
  final String message;
  final String confirmText;
  final String cancelText;
  final Function() onTapConfirm;
  final Function() onTapCancel;
  final bool showCancelButton;
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
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
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
