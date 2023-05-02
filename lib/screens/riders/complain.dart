import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/order.dart';
import '../../utils/exports.dart';

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
  var aboutMeNotifier = ValueNotifier<String>('');
  final textController = TextEditingController();

  var aboutMeLength = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    top: Constants.size.height * 0.0591,),
                child: Text(
                  "Let us know what went wrong!".tr,
                  style: TextStyles.buttonBlack,
                ),
              ),
               SizedBox(height:10),
              Text('OrderID: ${widget.order.id}',style:TextStyles.bodyBlack),
              SizedBox(height:20),
              Padding(
                padding: EdgeInsets.only(
                    top: Constants.size.height * 0.05,),
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
                        aboutMeNotifier.value = value;
                        aboutMeLength.value = value.length;
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
              SizedBox(height: 10),
              Text(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(() => GestureDetector(
               onTap: () {
                
                  if (aboutMeNotifier.value.length > 50) {
                   
                    FirebaseFirestore.instance
                        .collection('complaints').add({
                          'order':widget.order.id,
                          'description':aboutMeNotifier.value
                        });
                        Fluttertoast.showToast(msg: 'Complaint submitted');
                        Get.back();
                        
                  }},
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: aboutMeLength.value < 50 ?
                         Constants.appBarColor.withOpacity(0.5):Constants.appBarColor
                      ),
                      child: Center(child: Text('Submit', style: TextStyles.button,)),
                    ),
                  )
              //  CustomButton(
              //   width: double.infinity,
              //   variant: aboutMeLength.value < 50
              //       ? ButtonVariant.InActiveGrey
              //       : ButtonVariant.FillRed400,
              //   text: "Finish".tr,
              //   alignment: Alignment.center,
             
              //     Get.close(2);
              //     Get.to(() => EditProfile());
              //   },
              // ),
             ),
        ],
      ),
    );
  }
}
