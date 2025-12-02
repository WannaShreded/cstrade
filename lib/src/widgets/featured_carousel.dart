import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cstrade/src/models/skin.dart';
import 'package:cstrade/src/services/skin_service.dart';
import 'package:cstrade/src/utils/navigation.dart';

class FeaturedCarousel extends StatefulWidget {
  const FeaturedCarousel({super.key});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  Timer? _timer;
  List<Skin> _featured = [];

  @override
  void initState() {
    super.initState();
    _loadFeatured();
    _timer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (_pageController.hasClients && _featured.isNotEmpty) {
        final next = (_pageController.page?.round() ?? 0) + 1;
        _pageController.animateToPage(
          next % _featured.length,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadFeatured() async {
    try {
      final all = await const SkinService().loadLocalSkins();
      if (!mounted) return;
      // sort by price descending and take the top 5 most expensive skins
      all.sort((a, b) => b.price.compareTo(a.price));
      setState(() {
        _featured = all.take(5).toList();
      });
    } catch (e) {
      // ignore errors for the prototype
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_featured.isEmpty) {
      return SizedBox(
        height: 140,
        child: Card(
          child: Center(
            child: Text(
              'Featured Skins',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _featured.length,
              itemBuilder: (context, index) {
                final skin = _featured[index];
                final thumb = skin.thumbnail.isNotEmpty
                    ? skin.thumbnail
                    : skin.image;
                final image = thumb.startsWith('assets/')
                    ? thumb
                    : 'assets/images/thumbs/$thumb';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  child: GestureDetector(
                    onTap: () => pushSkinDetail(context, skin),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // keep a full-card background for color, but make the image itself smaller
                          Container(color: Theme.of(context).cardColor),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(0.01),
                              child: Image.asset(
                                image,
                                fit: BoxFit.contain,
                                errorBuilder: (c, e, s) => Container(
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ),
                          ),
                          // subtle bottom overlay for text legibility
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color.fromARGB(0, 247, 2, 2),
                                    Colors.black.withOpacity(0.45),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            bottom: 12,
                            right: 12,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    skin.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$ ${skin.price.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          _buildIndicators(),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return SizedBox(
      height: 12,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_featured.length, (i) {
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double selected = 0;
                if (_pageController.hasClients &&
                    _pageController.page != null) {
                  selected = (_pageController.page! - i).abs();
                }
                final t = (1.0 - (selected.clamp(0.0, 1.0))); // 0..1
                final width = 8.0 + (8.0 * t);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: width,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9 * t),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
