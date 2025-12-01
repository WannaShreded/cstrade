import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorage {
  static const String _kFavoritesKey = 'cstrade_favorites';

  FavoritesStorage._(this._prefsFuture);

  final Future<SharedPreferences> _prefsFuture;
  static FavoritesStorage? _instance;

  /// Singleton instance
  static FavoritesStorage get instance => _instance ??= FavoritesStorage._(SharedPreferences.getInstance());

  Set<String>? _cache;

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;
    final prefs = await _prefsFuture;
    final list = prefs.getStringList(_kFavoritesKey);
    _cache = (list ?? <String>[]).toSet();
  }

  /// Adds a favorite id. No-op if already present.
  Future<void> addFavorite(String id) async {
    await _ensureLoaded();
    final changed = _cache!.add(id);
    if (changed) {
      final prefs = await _prefsFuture;
      await prefs.setStringList(_kFavoritesKey, _cache!.toList());
    }
  }

  /// Removes a favorite id. No-op if not present.
  Future<void> removeFavorite(String id) async {
    await _ensureLoaded();
    final changed = _cache!.remove(id);
    if (changed) {
      final prefs = await _prefsFuture;
      await prefs.setStringList(_kFavoritesKey, _cache!.toList());
    }
  }

  /// Returns true if id is favorited.
  Future<bool> isFavorite(String id) async {
    await _ensureLoaded();
    return _cache!.contains(id);
  }

  /// Returns the list of favorite ids (snapshot copy).
  Future<List<String>> getFavorites() async {
    await _ensureLoaded();
    return List<String>.from(_cache!);
  }

  /// Optional: clear all favorites (for testing/dev).
  Future<void> clearAll() async {
    _cache = <String>{};
    final prefs = await _prefsFuture;
    await prefs.remove(_kFavoritesKey);
  }
}
