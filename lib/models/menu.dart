import 'package:ashfood/models/app_user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Menu{
  final String? name;
  final String? description;
  final List<dynamic>? media;
  final AppUser? vendor;
  final num? price;
  final String?id;
  final String? vendorId;

  Menu({this.name, this.description, this.media, this.vendor, this.price, this.id, this.vendorId});

  factory Menu.fromJson(Map<String, dynamic> json)=>
  Menu(
    name: json['name'],
    description: json['description'],
    media: json['media'],
    vendor: AppUser.fromJson(json['vendor']),
    vendorId: json['vendorId'],
    price: json['price'],
    id: json['id']
  );

  Map<String, dynamic> toJson()=>{
    'name':name,
    'description':description,
    'media':media,
    'vendor':vendor!.toJson(),
    'vendorId':vendorId,
    'price':price,
    'id':id
  };
}