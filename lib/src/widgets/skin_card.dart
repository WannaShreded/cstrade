import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:cstrade/src/models/skin.dart';

// Clean, minimal SkinCard implementation. Keeps thumbnail, rarity visuals and floating info bar.
class SkinCard extends StatefulWidget {
  final Skin skin;
  final VoidCallback? onTap;

  const SkinCard({super.key, required this.skin, this.onTap});

  @override
  State<SkinCard> createState() => _SkinCardState();
}

class _SkinCardState extends State<SkinCard> {
  bool _hovered = false;
  bool _showOnTap = false;
  Timer? _hideTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _showFloatingBarTemporarily() {
    _hideTimer?.cancel();
    setState(() => _showOnTap = true);
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showOnTap = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final skin = widget.skin;
    final show = _hovered || _showOnTap;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => _showFloatingBarTemporarily(),
        onTap: widget.onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header image
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: _rarityGradient(skin.rarity),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _rarityColor(skin.rarity).withOpacity(0.22),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: skin.thumbnail.isNotEmpty
                            ? Hero(
                                tag: skin.id,
                                child: SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: Image.asset(
                                    skin.thumbnail,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 64,
                                      height: 64,
                                      color: Colors.grey[300],
                                      child: const Center(child: Icon(Icons.broken_image)),
                                    ),
                                  ),
                                ),
                              )
                            : Container(width: 80, height: 80, color: Colors.grey[300], child: const Center(child: Icon(Icons.image))),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(skin.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 1),
                              Text(skin.weapon, style: Theme.of(context).textTheme.labelSmall),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(skin.price.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 1),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                gradient: _rarityPillGradient(skin.rarity),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(skin.rarity, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            // floating info bar
            Positioned(
              left: 12,
              right: 12,
              top: -46,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: show ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !show,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 260),
                    offset: show ? Offset.zero : const Offset(0, 0.15),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 360),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900.withOpacity(0.62),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _rarityColor(skin.rarity).withOpacity(0.18),
                                  blurRadius: 18,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                              border: Border.all(color: Colors.white.withOpacity(0.04)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 6,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [_rarityColor(skin.rarity), Color.lerp(_rarityColor(skin.rarity), Colors.white, 0.12)!],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(color: _rarityColor(skin.rarity).withOpacity(0.35), blurRadius: 8, spreadRadius: 0.2),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        skin.weapon,
                                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.white, letterSpacing: 0.6),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        skin.exterior,
                                        style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text('\$${skin.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _rarityColor(String rarity) {
    final r = rarity.toLowerCase();
    if (r.contains('consumer')) return const Color(0xFFBDBDBD);
    if (r.contains('industrial')) return const Color(0xFF64B5F6);
    if (r.contains('mil') || r.contains('mil-spec')) return const Color(0xFF2979FF);
    if (r.contains('restricted')) return const Color(0xFF8E24AA);
    if (r.contains('classified')) return const Color(0xFFEC407A);
    if (r.contains('covert')) return const Color(0xFFE53935);
    return Colors.grey;
  }

  LinearGradient _rarityGradient(String rarity) {
    final base = _rarityColor(rarity);
    final light = Color.lerp(base, Colors.white, 0.18) ?? base.withOpacity(0.95);
    final dark = Color.lerp(base, Colors.black, 0.22) ?? base.withOpacity(0.85);
    return LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [light, base, dark]);
  }

  LinearGradient _rarityPillGradient(String rarity) {
    final base = _rarityColor(rarity);
    final dark = Color.lerp(base, Colors.black, 0.15) ?? base.withOpacity(0.9);
    return LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [base, dark]);
  }
 
}