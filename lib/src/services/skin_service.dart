import 'package:flutter/services.dart' show rootBundle;
import 'package:cstrade/src/models/skin.dart';

class SkinService {
  const SkinService();

  Future<List<Skin>> loadLocalSkins() async {
    final jsonStr = await rootBundle.loadString('assets/data/skin.json');
    return Skin.listFromJson(jsonStr);
  }
}
