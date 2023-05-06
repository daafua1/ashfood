import '../utils/exports.dart';

@JsonSerializable(explicitToJson: true)

// The cart item model
class CartItem {
  final Menu? menu;
  int? quantity;
  final String? id;
  final String? userId;
  final AppUser? user;

  CartItem({this.menu, this.quantity, this.id, this.user, this.userId});

  // Converts the cart item model to a json object
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
      menu: Menu.fromJson(json['menu']),
      quantity: json['quantity'],
      id: json['id'],
      userId: json['userId'],
      user: AppUser.fromJson(json['user']));

  // Converts the json object to a cart item model
  Map<String, dynamic> toJson() => {
        'menu': menu!.toJson(),
        'quantity': quantity,
        'id': id,
        'userId': userId,
        'user': user!.toJson()
      };
}
