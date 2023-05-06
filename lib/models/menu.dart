import '../utils/exports.dart';

@JsonSerializable(explicitToJson: true)

// The menu model
class Menu {
  final String? name;
  final String? description;
  final List<dynamic>? media;
  final AppUser? vendor;
  final num? price;
  final String? id;
  final String? vendorId;

  Menu(
      {this.name,
      this.description,
      this.media,
      this.vendor,
      this.price,
      this.id,
      this.vendorId});

  // Converts the json object to a menu model
  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
      name: json['name'],
      description: json['description'],
      media: json['media'],
      vendor: AppUser.fromJson(json['vendor']),
      vendorId: json['vendorId'],
      price: json['price'],
      id: json['id']);

  // Converts the menu model to a json object
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'media': media,
        'vendor': vendor!.toJson(),
        'vendorId': vendorId,
        'price': price,
        'id': id
      };
}
