import 'package:flutter/material.dart';
import 'package:cstrade/src/models/skin.dart';
import 'package:cstrade/src/services/skin_service.dart';
import 'package:cstrade/src/utils/navigation.dart';
import 'package:cstrade/src/widgets/skin_card.dart';

class GalleryScreen extends StatelessWidget {
  final String category;
  const GalleryScreen({super.key, this.category = 'All'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Skin>>(
          future: const SkinService().loadLocalSkins(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final all = snapshot.data ?? <Skin>[];
            final filtered = _filterByCategory(all, category);
            if (filtered.isEmpty)
              return const Center(child: Text('No skins found'));
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final skin = filtered[index];
                return SkinCard(
                  skin: skin,
                  onTap: () => pushSkinDetail(context, skin),
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Skin> _filterByCategory(List<Skin> skins, String category) {
    if (category == 'All') {
      return skins;
    }
    return skins.where((skin) => skin.category == category).toList();
  }
}

extension SkinCategoryExtension on Skin {
  /// Fallback `category` getter so the gallery compiles when the model
  /// doesn't define `category`. Remove this extension when a real
  /// `category` field/getter exists on the Skin model.
  String get category => '';
}
