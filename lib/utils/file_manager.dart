import 'exports.dart';

// This class is used to handle the picking of images from the gallery and camera
class FileManager {
  final ImagePicker _picker = ImagePicker();
  dynamic imageFile;
  bool hasFile = false;
  String imgPath = '';
  showModelSheetForImage(
      {int maxFileSize = 10 * 1024,
      List<String> allowedExtensions = const [],
      void Function(String?)? getImages}) async {
    if (kIsWeb) {
      await chooseFromGallery();
      if (getImages != null) {
        getImages(imgPath);
      }
    } else {
      await Get.bottomSheet(
          SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () async {
                      await chooseFromGallery();
                      if (getImages != null) {
                        getImages(imgPath);
                      }

                      Get.back();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    await takePhotoWithCamera();
                    if (getImages != null) {
                      getImages(imgPath);
                    }
                    Get.back();
                  },
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white);
    }
  }

// This function is used to pick an image from the gallery
  Future<void> chooseFromGallery() async {
    final pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (pickedImage != null) {
      imageFile = File(pickedImage.path);
      imgPath = pickedImage.path;
      hasFile = true;
    }
  }

// This function is used to take a photo with the camera. It is only used on mobile devices
  Future<void> takePhotoWithCamera() async {
    final pickedImage =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 25);

    if (pickedImage != null) {
      imageFile = File(pickedImage.path);
      imgPath = pickedImage.path;
      hasFile = true;
    }
  }

  ///method returns bool and can be used for checking either
  ///particular permission is granted or not
  static Future<bool> isPermissionGranted(Permission permission) async {
    return !(await permission.status.isDenied ||
        await permission.status.isRestricted);
  }

  ///A common method used for asking permissions
  static Future<void> askForPermission(Permission permission) async {
    if (!await isPermissionGranted(permission)) {
      await permission.request();
    }
  }
}
