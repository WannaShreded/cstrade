import 'package:flutter/material.dart';
import 'package:cstrade/src/models/skin.dart';
import 'package:cstrade/src/services/skin_service.dart';
import 'package:cstrade/src/utils/navigation.dart';
import 'package:cstrade/src/storage/favorites_storage.dart';
import 'package:cstrade/src/widgets/skin_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _loading = true;
  List<Skin> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _loading = true;
    });
    try {
      final all = await const SkinService().loadLocalSkins();
      final ids = await FavoritesStorage.instance.getFavorites();
      final favs = all.where((s) => ids.contains(s.id)).toList();
      setState(() {
        _favorites = favs;
      });
    } catch (_) {
      setState(() {
        _favorites = [];
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavorites,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _favorites.isEmpty
              ? const Center(child: Text('No favorites yet'))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.15,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final skin = _favorites[index];
                    return SkinCard(
                      skin: skin,
                      onTap: () async {
                        await pushSkinDetail(context, skin);
                        // reload in case user added/removed favorite from detail
                        await _loadFavorites();
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
