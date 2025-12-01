import 'package:flutter/material.dart';
import 'package:cstrade/src/models/skin.dart';

class SkinDetailScreen extends StatefulWidget {
	final Skin skin;
	const SkinDetailScreen({super.key, required this.skin});

	@override
	State<SkinDetailScreen> createState() => _SkinDetailScreenState();
}

class _SkinDetailScreenState extends State<SkinDetailScreen> {
	bool _isFavorite = false;

	Color _rarityColor(String rarity) {
		switch (rarity.toLowerCase()) {
			case 'covert':
			case 'legendary':
				return Colors.amber.shade700;
			case 'epic':
				return Colors.purple.shade400;
			case 'rare':
				return Colors.blue.shade400;
			case 'uncommon':
				return Colors.green.shade400;
			case 'common':
			default:
				return Colors.grey.shade600;
		}
	}

	@override
	Widget build(BuildContext context) {
		final skin = widget.skin;
		final fullImage = skin.image.startsWith('assets/') ? skin.image : 'assets/images/full/${skin.image}';

		return Scaffold(
			body: CustomScrollView(
				slivers: [
					SliverAppBar(
						expandedHeight: 360,
						pinned: true,
						leading: BackButton(onPressed: () => Navigator.maybePop(context)),
						actions: [
							IconButton(
								icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
								onPressed: _toggleFavorite,
							),
						],
						flexibleSpace: FlexibleSpaceBar(
							title: Text(skin.name, style: const TextStyle(fontSize: 16)),
							background: Stack(
								fit: StackFit.expand,
								children: [
									Image.asset(
										fullImage,
										fit: BoxFit.cover,
										errorBuilder: (context, error, stack) => Container(
											color: Colors.grey[300],
											child: const Center(child: Icon(Icons.broken_image, size: 56)),
										),
									),
									Container(
										decoration: BoxDecoration(
											gradient: LinearGradient(
												begin: Alignment.topCenter,
												end: Alignment.bottomCenter,
												colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
											),
										),
									),
								],
							),
						),
					),
					SliverToBoxAdapter(
						child: Padding(
							padding: const EdgeInsets.all(16.0),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Expanded(
												child: Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														Text(skin.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
														const SizedBox(height: 6),
														Text(skin.weapon, style: const TextStyle(color: Colors.grey, fontSize: 14)),
													],
												),
											),
											Container(
												padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
												decoration: BoxDecoration(
													color: _rarityColor(skin.rarity),
													borderRadius: BorderRadius.circular(20),
												),
												child: Text(skin.rarity, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
											),
										],
									),
									const SizedBox(height: 12),
									Row(
										children: [
											Chip(label: Text(skin.exterior)),
											const SizedBox(width: 12),
											Text('Float: ${skin.floatValue.toStringAsFixed(4)}', style: const TextStyle(color: Colors.black87)),
											const Spacer(),
											Text('\$${skin.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
										],
									),
									const SizedBox(height: 16),
									ElevatedButton.icon(
										onPressed: _toggleFavorite,
										icon: Icon(_isFavorite ? Icons.check : Icons.favorite_border),
										label: Text(_isFavorite ? 'Added to Favorites' : 'Add to Favorites'),
										style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
									),
									const SizedBox(height: 20),
									const Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
									const SizedBox(height: 8),
									const Text('This is a prototype preview. Description and additional metadata would appear here.'),
								],
							),
						),
					),
				],
			),
		);
	}

	void _toggleFavorite() {
		setState(() {
			_isFavorite = !_isFavorite;
		});
		ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites')));
	}
}
