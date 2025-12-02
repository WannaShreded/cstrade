import 'package:flutter/foundation.dart';
import 'package:cstrade/src/models/skin.dart';
import 'package:cstrade/src/services/skin_service.dart';

class SkinProvider extends ChangeNotifier {
  final SkinService _service;
  List<Skin> _skins = [];
  bool _loading = false;

  SkinProvider({SkinService? service})
    : _service = service ?? const SkinService();

  List<Skin> get skins => _skins;
  bool get isLoading => _loading;

  Future<void> loadSkins() async {
    _loading = true;
    notifyListeners();
    try {
      _skins = await _service.loadLocalSkins();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
