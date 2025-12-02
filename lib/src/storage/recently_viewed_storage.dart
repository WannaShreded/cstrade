import 'package:shared_preferences/shared_preferences.dart';

class RecentlyViewedStorage {
  static const String _kKey = 'cstrade_recently_viewed';

  RecentlyViewedStorage._(this._prefsFuture);
  final Future<SharedPreferences> _prefsFuture;
  static RecentlyViewedStorage? _instance;

  /// Singleton instance
  static RecentlyViewedStorage get instance =>
      _instance ??= RecentlyViewedStorage._(SharedPreferences.getInstance());

  List<String>? _cache;
  final int _capacity = 12;

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;
    final prefs = await _prefsFuture;
    final list = prefs.getStringList(_kKey) ?? <String>[];
    _cache = List<String>.from(list);
  }

  /// Add an id to the front of the recently viewed list. Maintains capacity and uniqueness.
  Future<void> addViewed(String id) async {
    await _ensureLoaded();
    _cache!.remove(id);
    _cache!.insert(0, id);
    if (_cache!.length > _capacity) _cache = _cache!.sublist(0, _capacity);
    final prefs = await _prefsFuture;
    await prefs.setStringList(_kKey, _cache!);
  }

  /// Returns the list of ids most-recent-first.
  Future<List<String>> getViewed() async {
    await _ensureLoaded();
    return List<String>.from(_cache!);
  }

  /// Clear all (dev/testing)
  Future<void> clear() async {
    _cache = <String>[];
    final prefs = await _prefsFuture;
    await prefs.remove(_kKey);
  }
}
