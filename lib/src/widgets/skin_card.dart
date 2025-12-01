import 'package:flutter/material.dart';
import 'package:cstrade/src/models/skin.dart';

class SkinCard extends StatelessWidget {
  final Skin skin;
  final VoidCallback? onTap;

  const SkinCard({super.key, required this.skin, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                child: skin.thumbnail.isNotEmpty
                    ? Image.asset(
                        skin.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.broken_image)),
                        ),
                      )
                    : Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(skin.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(skin.price.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
