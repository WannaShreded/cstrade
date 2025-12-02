import 'package:flutter/material.dart';
import 'package:cstrade/src/models/skin.dart';
import 'package:cstrade/src/storage/favorites_storage.dart';
import 'package:cstrade/src/widgets/float_progress.dart';

class SkinDetailScreen extends StatefulWidget {
  final Skin skin;
  const SkinDetailScreen({super.key, required this.skin});

  @override
  State<SkinDetailScreen> createState() => _SkinDetailScreenState();
}

class _SkinDetailScreenState extends State<SkinDetailScreen> {
  bool _isFavorite = false;

  Color _rarityColor(String rarity) {
    final r = rarity.toLowerCase();
    if (r.contains('consumer')) return const Color(0xFFBDBDBD); // Silver
    if (r.contains('industrial')) return const Color(0xFF64B5F6); // Baby Blue
    if (r.contains('mil') || r.contains('mil-spec'))
      return const Color(0xFF2979FF); // Blue
    if (r.contains('restricted')) return const Color(0xFF8E24AA); // Purple
    if (r.contains('classified')) return const Color(0xFFEC407A); // Pink
    if (r.contains('covert')) return const Color(0xFFE53935); // Red
    return Colors.grey.shade600;
  }

  // Gradient for rarity pill used in detail header
  LinearGradient _rarityPillGradient(String rarity) {
    final base = _rarityColor(rarity);
    final dark = Color.lerp(base, Colors.black, 0.12) ?? base.withOpacity(0.9);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [base, dark],
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = widget.skin;
    final fullImage =
        (skin.image.startsWith('assets/') || skin.image.startsWith('images/'))
        ? skin.image
        : 'assets/images/full/${skin.image}';
    final thumbImage = skin.thumbnail.startsWith('assets/')
        ? skin.thumbnail
        : 'assets/images/thumbs/${skin.thumbnail}';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            leading: BackButton(onPressed: () => Navigator.maybePop(context)),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(skin.name, style: const TextStyle(fontSize: 16)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Shared hero image: animate from card -> detail.
                  Hero(
                    tag: skin.id,
                    flightShuttleBuilder:
                        (
                          flightContext,
                          animation,
                          flightDirection,
                          fromHeroContext,
                          toHeroContext,
                        ) {
                          final curved = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          );
                          return AnimatedBuilder(
                            animation: curved,
                            builder: (context, child) {
                              final t = curved.value;
                              // scale from 0.88 -> 1.0, rotate slightly -0.12rad -> 0
                              final scale = 0.88 + (1.0 - 0.88) * t;
                              final rot = -0.12 + (0.0 - -0.12) * t; // radians
                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..scale(scale, scale)
                                  ..rotateZ(rot),
                                child: child,
                              );
                            },
                            child: Image.asset(
                              fullImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  Image.asset(
                                    thumbImage,
                                    fit: BoxFit.contain,
                                    errorBuilder: (ctx2, err2, stack2) =>
                                        Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 56,
                                            ),
                                          ),
                                        ),
                                  ),
                            ),
                          );
                        },
                    child: Image.asset(
                      fullImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Image.asset(
                        thumbImage,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx2, err2, stack2) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 56),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          // lighter subtle rarity tint -> slightly stronger -> dark overlay
                          _rarityColor(skin.rarity).withOpacity(0.08),
                          _rarityColor(skin.rarity).withOpacity(0.14),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
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
                            Text(
                              skin.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              skin.weapon,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: _rarityPillGradient(skin.rarity),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          skin.rarity,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Chip(label: Text(skin.exterior)),
                          const Spacer(),
                          Text(
                            '\$${skin.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Float progress bar (visualizes wear 0.00 -> 1.00)
                      FloatProgress(value: skin.floatValue, height: 10.0),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      _isFavorite ? Icons.check : Icons.favorite_border,
                    ),
                    label: Text(
                      _isFavorite ? 'Added to Favorites' : 'Add to Favorites',
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'This is a prototype preview. Description and additional metadata would appear here.',
                  ),
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
    // persist change
    if (_isFavorite) {
      FavoritesStorage.instance.addFavorite(widget.skin.id);
    } else {
      FavoritesStorage.instance.removeFavorite(widget.skin.id);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to favorites' : 'Removed from favorites',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // initialize persisted favorite state
    FavoritesStorage.instance.isFavorite(widget.skin.id).then((v) {
      if (mounted) setState(() => _isFavorite = v);
    });
  }
}
