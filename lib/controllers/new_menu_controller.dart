import 'dart:io';

import 'package:ashfood/utils/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/menu.dart';

class NewMenuController extends GetxController {
  var media = [
    '',
    '',
    '',
    '',
  ].obs;

  // The controllers for the post text fields
  var description = TextEditingController().obs;

  // The controllers for the email text fields
  var name = TextEditingController().obs;

  // The controllers for the email text fields
  var price = TextEditingController().obs;

  // Whether the user inputs are valid
  var validationError = false.obs;

  // Whether the loader is busy
  var isLoading = false.obs;

  var onWillPop = true.obs;

  var currentUpload = 0.obs;

  var totalUpload = 0.obs;

  var currentUploadPercentage = 0.0.obs;

  // The map to save the post
  var menuMap = Menu().obs;

  Future<String> uploadFile(File image) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('media/${image.path}');
    UploadTask uploadTask = storageReference.putFile(image);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      currentUploadPercentage.value =
          ((snapshot.bytesTransferred / snapshot.totalBytes) * 100);
    }, onError: (e) {
      onWillPop.value = false;
      isLoading.value = false;
      Fluttertoast.showToast(msg: "Something Went Wrong Please try again");
    }, onDone: () {});

    await uploadTask.whenComplete(() => null);

    return await storageReference.getDownloadURL();
  }

  Future<List<String>> uploadFiles(List<File> images) async {
    totalUpload.value = images.length;
    onWillPop.value = false;

    List<String> imageUrls = [];
    for (var image in images) {
      currentUpload.value = images.indexOf(image) + 1;
      final imageURL = await uploadFile(image);
      imageUrls.add(imageURL);
    }
    return imageUrls;
  }

  void validateForms() async {
    // Validate the input fields
    if (description.value.text.isNotEmpty &&
        name.value.text.isNotEmpty &&
        price.value.text.isNotEmpty &&
        price.value.text.isNumericOnly &&
        getFiles().length > 1 &&
        description.value.text.length > 10) {
      validationError.value = false;
      isLoading.value = true;

      try {
        final files = getFiles();
        final imageURLs = await uploadFiles(files);

        // Add the post to the database if no image is picked

        final docReference = FirebaseFirestore.instance.collection('menus').doc(
            DateTime.now().millisecondsSinceEpoch.toString() + user.value.id!);
        menuMap.value = Menu(
          description: description.value.text,
          name: name.value.text,
          vendor: user.value,
          media: imageURLs,
          vendorId: user.value.id,
          price: double.parse(price.value.text),
          id: docReference.id,
        );
        FirebaseFirestore.instance
            .runTransaction((transaction) async =>
                transaction.set(docReference, menuMap.toJson()))
            .then((value) {
          isLoading.value = false;
          Get.back();
        });
      } catch (e) {
        isLoading.value = false;

        // Show the error message if any
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.white,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 14,
        );
      }
    } else {
      validationError.value = true;
    }
  }

  List<File> getFiles() {
    final List<File> files = [];
    for (var element in media) {
      if (element.isNotEmpty) {
        files.add(File(element));
      }
    }
    return files;
  }
}
