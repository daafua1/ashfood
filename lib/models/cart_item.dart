import 'package:ashfood/models/app_user.dart';
import 'package:json_annotation/json_annotation.dart';

import 'menu.dart';

@JsonSerializable(explicitToJson: true)
class CartItem{
  final Menu? menu;
   int? quantity;
  final String? id;
  final String? userId;
  final AppUser? user;

  CartItem({this.menu, this.quantity, this.id, this.user, this.userId});

  factory CartItem.fromJson(Map<String, dynamic> json)=>CartItem(
    menu: Menu.fromJson(json['menu']),
    quantity: json['quantity'],
    id: json['id'],
    userId: json['userId'],
    user: AppUser.fromJson( json['user'])
  );

  Map<String, dynamic> toJson()=>{
    'menu':menu!.toJson(),
    'quantity':quantity,
    'id':id,
    'userId':userId,
    'user':user!.toJson()
  };
}

