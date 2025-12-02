import 'package:flutter/material.dart';
import 'package:cstrade/src/models/skin.dart';
import 'package:cstrade/src/services/skin_service.dart';
import 'package:cstrade/src/storage/recently_viewed_storage.dart';
import 'package:cstrade/src/utils/navigation.dart';

class RecentlyViewed extends StatefulWidget {
  const RecentlyViewed({super.key});

  @override
  State<RecentlyViewed> createState() => _RecentlyViewedState();
}

class _RecentlyViewedState extends State<RecentlyViewed> {
  final ScrollController _controller = ScrollController();
  List<Skin> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final all = await const SkinService().loadLocalSkins();
      final ids = await RecentlyViewedStorage.instance.getViewed();
      final map = {for (var s in all) s.id: s};
      final items = <Skin>[];
      for (final id in ids) {
        final s = map[id];
        if (s != null) items.add(s);
      }
      setState(() => _items = items);
    } catch (_) {
      setState(() => _items = []);
    } finally {
      setState(() => _loading = false);
    }
  }

  Color _rarityColor(String rarity) {
    final r = rarity.toLowerCase();
    if (r.contains('industrial')) return const Color(0xFF64B5F6);
    if (r.contains('mil')) return const Color(0xFF2979FF);
    if (r.contains('restricted')) return const Color(0xFF8E24AA);
    if (r.contains('classified')) return const Color(0xFFEC407A);
    if (r.contains('covert')) return const Color(0xFFE53935);
    return const Color(0xFFBDBDBD);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox(height: 140, child: Center(child: CircularProgressIndicator()));
    if (_items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Text('Recently Viewed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final skin = _items[index];
              final color = _rarityColor(skin.rarity);
              // simple parallax: offset fraction based on scroll position and index
              final scroll = _controller.hasClients ? _controller.offset : 0.0;
              final par = ((index * 12) - scroll) * 0.002; // small transform

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      await pushSkinDetail(context, skin);
                      await _load();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOut,
                      transform: Matrix4.identity()..translate(0.0, par),
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900.withOpacity(0.24),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.04)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 8, offset: const Offset(0, 6)),
                          BoxShadow(color: color.withOpacity(0.14), blurRadius: 18, spreadRadius: 0.2),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // image
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: Container(
                                color: color.withOpacity(0.08),
                                child: Center(
                                  child: Image.asset(
                                    skin.thumbnail,
                                    fit: BoxFit.contain,
                                    width: 68,
                                    height: 68,
                                    errorBuilder: (ctx, err, st) => const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(skin.weapon, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                                const SizedBox(height: 4),
                                Container(
                                  width: 36,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [color, color.withOpacity(0.6)]),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [BoxShadow(color: color.withOpacity(0.22), blurRadius: 12, spreadRadius: 0.2)],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

