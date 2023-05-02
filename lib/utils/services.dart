import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_utils/src/platform/platform_io.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../main.dart';
import '../models/app_user.dart';
import 'constants.dart';

// This class is used to handle operations on the database
class Services {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // This function is used to get the current user from the database
  static Future<void> getUser(String userID) async {
    final userReference =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    if (userReference.exists && userReference.data() != null) {
      // Replace the user object with the new user object
      user.value = AppUser.fromJson(userReference.data()!);
      final userString = jsonEncode(userReference.data()!);
      prefs!.setString('user', userString);
    }
  }

// This function is used to get any user from the database
  static Future<AppUser?> getAnyUser(String userID) async {
    var aUser = AppUser();
    final userReference =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    if (userReference.exists && userReference.data() != null) {
      aUser = AppUser.fromJson(userReference.data()!);

      return aUser;
    } else {
      return null;
    }
  }

// This function is used to upload a file to firebase storage.
// It returns a download url for the file
  Future<String> uploadFile(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(image);

    uploadTask.snapshotEvents
        .listen((TaskSnapshot snapshot) {}, onError: (e) {}, onDone: () {});

    await uploadTask.whenComplete(() => null);

    return await storageReference.getDownloadURL();
  }

// This function is used to get stream snapshots of all the posts in the database
  Stream<QuerySnapshot<Map<String, dynamic>>> getMenus(String vendorId) {
    return FirebaseFirestore.instance
        .collection('menus')
        .where('vendorId', isEqualTo: vendorId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getVendors() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'vendor')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCart() {
    return FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: user.value.id)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders(String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersVendros(
      String vendorId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .where('vendorId', isEqualTo: vendorId)
        .orderBy(
          'isServed',
        )
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPastOrdersRiders(
      String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'completed')
        .where('riderId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPastOrdersVendors(
      String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'completed')
        .where('vendorId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPastOrdersStudents(
      String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'completed')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRiderOrders(String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .where('riderId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRiderVendor(
      String userId, String vendorId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .where('riderId', isEqualTo: userId)
        .where('vendorId', isEqualTo: vendorId)
        .snapshots();
  }

  void registerNotification() async {
    // firebaseMessaging.requestPermission();
    // final doc = prefs!.getString('docs');

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   if (message.notification != null) {
    //     showNotification(message.notification!);
    //   }
    //   return;
    // });
    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState.userId!;
    print('playerId: $playerId');
    FirebaseFirestore.instance.collection('users').doc(user.value.id).update({
      'fcmToken': playerId,
    });
    user.value.fcmToken = playerId;

    // firebaseMessaging.getToken().then((token) {
    //   if (token != null && token != user.value.fcmToken) {
    //     FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(user.value.id)
    //         .update({
    //       'fcmToken': token,
    //     });
    //   }
    // }).catchError((err) {
    //   // Fluttertoast.showToast(msg: err.message.toString());
    //});
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      GeneralPlatform.isAndroid ? 'com.example.ashfood' : 'com.example.ashfood',
      appName,
      '',
      playSound: true,
      enableVibration: true,
      importance: Importance.defaultImportance,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        const IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: remoteNotification.android?.clickAction,
    );
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getRiders() async {
    final query = FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'rider')
        .where('numOfOrders', isLessThan: 10)
        .limit(1);
    final docs = await query.get();
    return docs.docs;
  }

  // void sendNotification(
  //     {required String title,
  //     required String message,
  //     required String token}) async {
  //   const endPoint =
  //       'https://us-central1-dtme-ffef7.cloudfunctions.net/sendMessageAshFood';

  //   final body = {
  //     "data": {
  //       "title": title,
  //       "message": message,
  //       "token": token,
  //     }
  //   };

  //   final request =
  //       await http.post(Uri.parse(endPoint), body: jsonEncode(body), headers: {
  //     'Content-Type': 'application/json',
  //   });

  //   print(request.body.toString());
  //   print(request.reasonPhrase);
  // }

  void sendNotification(
      {required String token,
      required String content,
      required String heading}) async {
    var notification = OSCreateNotification(
      playerIds: [token],
      content: content,
      heading: heading,
      // iosAttachments: {"id1": imgUrlString},
      bigPicture: 'assets/images/logo.png',
      // buttons: [
      //   OSActionButton(text: "test1", id: "id1"),
      //   OSActionButton(text: "test2", id: "id2")
      // ]
    );

    var response = await OneSignal.shared.postNotification(notification);
  }
}
