import '../utils/exports.dart';

class NewMenuController extends GetxController {
  var media = [
    '',
    '',
    '',
    '',
  ].obs;

  // The controller for the description text fields
  var description = TextEditingController().obs;

  // The controller for the menu name text fields
  var name = TextEditingController().obs;

  // The controller for the menu price text fields
  var price = TextEditingController().obs;

  // Whether the user inputs are valid
  var validationError = false.obs;

  // Whether the loader is busy
  var isLoading = false.obs;

  // Whether the user should be prevented from going back when uploading
  var onWillPop = true.obs;

  // The current upload
  var currentUpload = 0.obs;

  // The total number of images to be uploaded
  var totalUpload = 0.obs;

  // The current upload percentage
  var currentUploadPercentage = 0.0.obs;

  // The map to save the new menu
  var menuMap = Menu().obs;

  // Uploads a file to firebase storage and returns the downloadable url
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

  // Uploads a list of files to firebase storage and returns the downloadable urls
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

  // Validates the user inputs and create a new menu
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
        // Upload the files to firebase storage
        final files = getFiles();
        final imageURLs = await uploadFiles(files);

        // Add the menu to the database

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

// Returns a list of files from the media list
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
