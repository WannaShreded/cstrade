import 'package:flutter/material.dart';
import 'package:cstrade/src/screens/gallery_screen.dart';
import 'package:cstrade/src/screens/search_filter_screen.dart';
import 'package:cstrade/src/screens/favorites_screen.dart';
import 'package:cstrade/src/widgets/featured_carousel.dart';
import 'package:cstrade/src/widgets/recently_viewed.dart';

class HomeScreen extends StatelessWidget {
	const HomeScreen({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('CS2 Skin Gallery'),
				actions: [
					IconButton(
						icon: const Icon(Icons.search),
						onPressed: () => Navigator.push(
							context,
							MaterialPageRoute(builder: (_) => const SearchFilterScreen()),
						),
					),
					IconButton(
						icon: const Icon(Icons.favorite_border),
						onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
					),
				],
			),
			body: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					SizedBox(
						height: 72,
						child: ListView(
							scrollDirection: Axis.horizontal,
							padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
							children: [
								_categoryChip(context, 'All'),
								_categoryChip(context, 'Pistols'),
								_categoryChip(context, 'Rifles'),
								_categoryChip(context, 'Knives'),
								_categoryChip(context, 'Gloves'),
							],
						),
					),

					// Featured carousel
					Padding(
					  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
					  child: const FeaturedCarousel(),
					),

					// Recently viewed
					const RecentlyViewed(),

					// Grid preview
					const Padding(
						padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
						child: Text('Popular', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
					),
					// Simple placeholder grid of categories or featured items.
					Expanded(
						child: Padding(
							padding: const EdgeInsets.symmetric(horizontal: 8),
							child: GridView.count(
								crossAxisCount: 2,
								childAspectRatio: 3,
								crossAxisSpacing: 8,
								mainAxisSpacing: 8,
								children: [
									_categoryTile(context, 'Rifles'),
									_categoryTile(context, 'SMGs'),
									_categoryTile(context, 'Pistols'),
									_categoryTile(context, 'Knives'),
									_categoryTile(context, 'Gloves'),
									_categoryTile(context, 'Sniper'),
								],
							),
						),
					),
                ],
            ),
			bottomNavigationBar: BottomNavigationBar(
				items: const [
					BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
					BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
					BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
				],
				onTap: (i) {
					if (i == 2) {
						Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
					}
				},
			),
		);
	}

}

	Widget _categoryChip(BuildContext context, String label) {
		return Padding(
			padding: const EdgeInsets.only(right: 8.0),
			child: ActionChip(
				label: Text(label),
				onPressed: () => Navigator.push(
					context,
					MaterialPageRoute(builder: (_) => GalleryScreen(category: label)),
				),
			),
		);
	}

	Widget _categoryTile(BuildContext context, String label) {
		// Try primary and a singular fallback (e.g. "pistols" -> "pistol")
		final baseName = label.toLowerCase().replaceAll(' ', '_');
		final primaryPath = 'assets/images/categories/$baseName.png';
		final fallbackBase = baseName.endsWith('s') ? baseName.substring(0, baseName.length - 1) : baseName;
		final fallbackPath = 'assets/images/categories/$fallbackBase.png';

		return GestureDetector(
			onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GalleryScreen(category: label))),
			child: SizedBox(
				height: 96,
				child: Card(
					clipBehavior: Clip.antiAlias,
					shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
					child: Stack(
						fit: StackFit.expand,
						children: [
							// Centered category image
							Center(
								child: SizedBox(
									height: 600,
									width: 900,
									child: Image.asset(
										primaryPath,
										fit: BoxFit.contain,
										errorBuilder: (ctx, err, stack) => Image.asset(
											fallbackPath,
											fit: BoxFit.contain,
											errorBuilder: (ctx2, err2, stack2) => const Icon(Icons.image),
										),
									),
								),
							),
							// Gradient background with rarity-based color opacity
							Container(
								decoration: BoxDecoration(
									gradient: _categoryGradient(label),
								),
							),
							// Label text overlay
							Align(
								alignment: Alignment.bottomCenter,
								child: Padding(
									padding: const EdgeInsets.only(bottom: 8.0),
									child: Text(
										label,
										style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
									),
								),
							),
						],
					),
				),
			),
		);
	}

	// Map category label to a rarity-based color and return a gradient with opacity transition
	LinearGradient _categoryGradient(String label) {
		Color rarityColor = _categoryRarityColor(label);
		return LinearGradient(
			begin: Alignment.topCenter,
			end: Alignment.bottomCenter,
			colors: [
				rarityColor.withOpacity(0.05),
				rarityColor.withOpacity(0.22),
			],
		);
	}

	// Map category names to rarity colors
	Color _categoryRarityColor(String label) {
		final l = label.toLowerCase();
		// Examples: Rifles -> Blue (Mil-Spec), Pistols -> Purple (Restricted), etc.
		if (l.contains('rifle') || l.contains('ak') || l.contains('m4')) return const Color(0xFF2979FF); // Blue
		if (l.contains('pistol') || l.contains('glock') || l.contains('usp')) return const Color(0xFF8E24AA); // Purple
		if (l.contains('smg') || l.contains('mac') || l.contains('ump')) return const Color(0xFF64B5F6); // Baby Blue
		if (l.contains('sniper') || l.contains('awp') || l.contains('scout')) return const Color(0xFFEC407A); // Pink
		if (l.contains('knife') || l.contains('melee')) return const Color(0xFFE53935); // Red
		if (l.contains('glove')) return const Color(0xFFBDBDBD); // Silver
		return Colors.grey; // default fallback
	}

