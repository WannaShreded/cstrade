import 'package:flutter/material.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String query = '';
  final Set<String> rarities = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filters'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _reset)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search skins, weapons, authors…'),
                onChanged: (v) => setState(() => query = v),
              ),
              const SizedBox(height: 16),
              const Text('Rarity', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Common', 'Uncommon', 'Rare', 'Epic', 'Legendary', 'Covert']
                    .map((r) => FilterChip(
                          label: Text(r),
                          selected: rarities.contains(r),
                          onSelected: (v) => setState(() => v ? rarities.add(r) : rarities.remove(r)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              const Text('Float (min - max)', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Slider(value: 0.2, onChanged: (_) {}),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _reset,
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _reset() {
    setState(() {
      query = '';
      rarities.clear();
    });
  }
}
