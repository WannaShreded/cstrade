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

  /// Simple heuristic category getter used by the prototype UI for filtering.
  /// Maps weapon names to one of: `Rifles`, `Pistols`, `Knives`, `Gloves`, `SMGs`, `Sniper`.
  String get category {
    final w = weapon.toLowerCase();
    if (w.contains('knife') || w.contains('karambit') || w.contains('butterfly')) return 'Knives';
    if (w.contains('glove')) return 'Gloves';
    if (w.contains('p90') || w.contains('mp9') || w.contains('mac-10') || w.contains('ump') || w.contains('mp5') || w.contains('p90')) return 'SMGs';
    if (w.contains('awp') || w.contains('ssg') || w.contains('sg') || w.contains('scar') || w.contains('sniper')) return 'Sniper';
    if (w.contains('glock') || w.contains('deagle') || w.contains('usp') || w.contains('p250') || w.contains('cz75') || w.contains('hand cannon')) return 'Pistols';
    // Default to Rifles for anything else (AK-47, M4A4, M4A1-S, SG553, FAMAS, etc.)
    return 'Rifles';
  }

  static List<Skin> listFromJson(String jsonStr) {
    final data = json.decode(jsonStr) as List<dynamic>;
    return data.map((e) => Skin.fromJson(e as Map<String, dynamic>)).toList();
  }
}
