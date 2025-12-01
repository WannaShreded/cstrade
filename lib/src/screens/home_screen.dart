import 'package:flutter/material.dart';
import 'package:cstrade/src/screens/gallery_screen.dart';
import 'package:cstrade/src/screens/search_filter_screen.dart';

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
						onPressed: () {},
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

					// Featured banner
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
						child: Card(
							child: SizedBox(
								height: 140,
								child: Center(
									child: Text('Featured Skins', style: Theme.of(context).textTheme.titleLarge),
								),
							),
						),
					),

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
			),
		);
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
		final imagePath = 'assets/images/categories/${label.toLowerCase().replaceAll(' ', '_')}.png';
		// Try primary and a singular fallback (e.g. "pistols" -> "pistol")
		final baseName = label.toLowerCase().replaceAll(' ', '_');
		final primaryPath = 'assets/images/categories/$baseName.png';
		final fallbackBase = baseName.endsWith('s') ? baseName.substring(0, baseName.length - 1) : baseName;
		final fallbackPath = 'assets/images/categories/$fallbackBase.png';

		return GestureDetector(
			onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GalleryScreen(category: label))),
			child: Card(
				child: Padding(
					padding: const EdgeInsets.all(8.0),
					child: Row(
						children: [
							ClipRRect(
								borderRadius: BorderRadius.circular(8),
								child: Image.asset(
									primaryPath,
									width: 56,
									height: 56,
									fit: BoxFit.cover,
									errorBuilder: (ctx, err, stack) => Image.asset(
										fallbackPath,
										width: 56,
										height: 56,
										fit: BoxFit.cover,
										errorBuilder: (ctx2, err2, stack2) => Container(
											width: 56,
											height: 56,
											color: Theme.of(context).colorScheme.surface,
											child: const Icon(Icons.image_not_supported, color: Colors.white54),
										),
									),
								),
							),
							const SizedBox(width: 12),
							Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
						],
					),
				),
			),
		);
	}
}
