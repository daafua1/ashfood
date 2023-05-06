import '../utils/exports.dart';

@JsonSerializable(explicitToJson: true)

// The order model
class UserOrder {
  final Menu? menu;
  int? quantity;
  final String? id;
  final String? userId;
  final AppUser? user;
  final String? riderId;
  final String? status;
  final String? createdAt;
  final String? vendorId;
  final AppUser? rider;
  final int? riderStatus;
  bool? isServed;
  num? userRating;
  String? userComment;

  UserOrder({
    this.menu,
    this.quantity,
    this.id,
    this.user,
    this.userId,
    this.rider,
    this.riderId,
    this.status,
    this.createdAt,
    this.vendorId,
    this.riderStatus,
    this.userRating,
    this.userComment,
    this.isServed,
  });

// Converts the order model to a json object
  factory UserOrder.fromJson(Map<String, dynamic> json) => UserOrder(
        menu: Menu.fromJson(json['menu']),
        quantity: json['quantity'],
        id: json['id'],
        userId: json['userId'],
        user: AppUser.fromJson(json['user']),
        rider: json['rider'] == null ? null : AppUser.fromJson(json['rider']),
        riderId: json['riderId'],
        status: json['status'],
        createdAt: json['createdAt'],
        vendorId: json['vendorId'],
        riderStatus: json['riderStatus'],
        userRating: json['userRating'],
        userComment: json['userComment'],
        isServed: json['isServed'],
      );
  // Converts the json object to a order model
  Map<String, dynamic> toJson() => {
        'menu': menu!.toJson(),
        'quantity': quantity,
        'id': id,
        'userId': userId,
        'user': user!.toJson(),
        'rider': rider == null ? null : rider!.toJson(),
        'riderId': riderId,
        'status': status,
        'createdAt': createdAt,
        'vendorId': vendorId,
        'riderStatus': riderStatus,
        'userRating': userRating,
        'userComment': userComment,
        'isServed': isServed,
      };
}
