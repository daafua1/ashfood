import 'package:ashfood/models/app_user.dart';
import 'package:json_annotation/json_annotation.dart';

import 'menu.dart';

@JsonSerializable(explicitToJson: true)
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
  });

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
      );

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
      };
}
