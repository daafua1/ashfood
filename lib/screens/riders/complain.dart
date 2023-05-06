import '../../utils/exports.dart';

// A page to file a complaint
class Complain extends StatefulWidget {
  final UserOrder order;
  const Complain({
    required this.order,
    super.key,
  });

  @override
  State<Complain> createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  var textNotifier = ValueNotifier<String>('');
  final textController = TextEditingController();

  var textLength = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The appbar
      appBar: Constants.appBar('File a Complaint', false),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: Constants.size.height * 0.0591,
                ),
                child: Text(
                  "Let us know what went wrong!".tr,
                  style: TextStyles.buttonBlack,
                ),
              ),
              const SizedBox(height: 10),
              // The id of the order to be complained about
              Text('OrderID: ${widget.order.id}', style: TextStyles.bodyBlack),
              const SizedBox(height: 20),
              // The textfield to type the complaint
              Padding(
                padding: EdgeInsets.only(
                  top: Constants.size.height * 0.05,
                ),
                child: Container(
                    //padding:const  EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Constants.appBarColor)),
                    height: 150,
                    child: TextField(
                      cursorColor: Colors.black87,
                      controller: textController,
                      onChanged: (value) {
                        textNotifier.value = value;
                        textLength.value = value.length;
                      },
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Please type here ...",
                        hintStyle: TextStyle(color: Colors.black38),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 10),

              const Text(
                'minimum of 50 characters',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.black45),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // The submit button
          Obx(() => GestureDetector(
                onTap: () {
                  // Validate the text length and submit the complaint
                  if (textNotifier.value.length > 50) {
                    FirebaseFirestore.instance.collection('complaints').add({
                      'order': widget.order.id,
                      'description': textNotifier.value
                    });
                    Fluttertoast.showToast(msg: 'Complaint submitted');
                    Get.back();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: textLength.value < 50
                          ? Constants.appBarColor.withOpacity(0.5)
                          : Constants.appBarColor),
                  child: const Center(
                      child: Text(
                    'Submit',
                    style: TextStyles.button,
                  )),
                ),
              )),
        ],
      ),
    );
  }
}
