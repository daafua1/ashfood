import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)

// The user model
class AppUser {
  String? name;
  String? email;
  String? phoneNumber;
  String? location;
  String? id;
  double? long;
  double? lat;
  String? profileImage;
  String? userType;
  String? fcmToken;
  bool? isAvailable;
  int? numOfOrders;
  num? averageRating;
  int? totalRating;
  AppUser({
    this.name,
    this.email,
    this.phoneNumber,
    this.location,
    this.id,
    this.long,
    this.lat,
    this.profileImage,
    this.userType,
    this.fcmToken,
    this.isAvailable,
    this.numOfOrders,
    this.averageRating,
    this.totalRating,
  });

// Converts the user model to a json object
  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
      name: json["name"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      location: json["location"],
      id: json["id"],
      long: json["long"],
      lat: json["lat"],
      profileImage: json["profileImage"],
      userType: json["userType"],
      fcmToken: json["fcmToken"],
      isAvailable: json["isAvailable"],
      numOfOrders: json["numOfOrders"],
      averageRating: json["averageRating"],
      totalRating: json["totalRating"]);

// Converts the json object to a user model
  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "location": location,
        "id": id,
        "long": long,
        "lat": lat,
        "profileImage": profileImage,
        "userType": userType,
        "fcmToken": fcmToken,
        "isAvailable": isAvailable,
        "numOfOrders": numOfOrders,
        "averageRating": averageRating,
        "totalRating": totalRating
      };
}
