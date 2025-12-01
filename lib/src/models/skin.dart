import 'dart:convert';

class Skin {
  final String id;
  final String name;
  final String weapon;
  final String rarity;
  final String exterior;
  final double floatValue;
  final double price;
  final String image;
  final String thumbnail;

  Skin({
    required this.id,
    required this.name,
    required this.weapon,
    required this.rarity,
    required this.exterior,
    required this.floatValue,
    required this.price,
    required this.image,
    required this.thumbnail,
  });

  factory Skin.fromJson(Map<String, dynamic> json) => Skin(
        id: json['id'] as String,
        name: json['name'] as String,
        weapon: json['weapon'] as String,
        rarity: json['rarity'] as String,
        exterior: json['exterior'] as String,
        floatValue: (json['float'] as num).toDouble(),
        price: (json['price'] as num).toDouble(),
        image: json['image'] as String,
        thumbnail: json['thumbnail'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'weapon': weapon,
        'rarity': rarity,
        'exterior': exterior,
        'float': floatValue,
        'price': price,
        'image': image,
        'thumbnail': thumbnail,
      };

  static List<Skin> listFromJson(String jsonStr) {
    final data = json.decode(jsonStr) as List<dynamic>;
    return data.map((e) => Skin.fromJson(e as Map<String, dynamic>)).toList();
  }
}
