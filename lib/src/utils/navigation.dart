import 'package:flutter/material.dart';
import 'package:cstrade/src/models/skin.dart';
import 'package:cstrade/src/screens/detail_screen.dart';
import 'package:cstrade/src/storage/recently_viewed_storage.dart';

/// Pushes the `SkinDetailScreen` with a polished transition.
Future<T?> pushSkinDetail<T>(BuildContext context, Skin skin) {
  // record recently viewed
  RecentlyViewedStorage.instance.addViewed(skin.id);

  return Navigator.of(context).push<T>(PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 700),
    reverseTransitionDuration: const Duration(milliseconds: 520),
    pageBuilder: (ctx, anim, secAnim) => SkinDetailScreen(skin: skin),
    transitionsBuilder: (ctx, anim, secAnim, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      // Background spotlight gradient that fades in
      return Stack(
        fit: StackFit.passthrough,
        children: [
          FadeTransition(
            opacity: curved,
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.4),
                  radius: 1.0,
                  colors: [Color(0xFF071029), Color(0xFF0B1220), Colors.black],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
          FadeTransition(opacity: curved, child: child),
        ],
      );
    },
  ));
}
