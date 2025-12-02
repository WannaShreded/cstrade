import 'package:flutter/material.dart';

typedef SearchCallback = void Function(String query);
typedef FilterCallback = void Function(String? value);

class SkinFilterBar extends StatefulWidget {
  final String? initialQuery;
  final String? initialRarity;
  final String? initialExterior;
  final SearchCallback onSearchChanged;
  final FilterCallback onRarityChanged;
  final FilterCallback onExteriorChanged;

  const SkinFilterBar({
    super.key,
    this.initialQuery,
    this.initialRarity,
    this.initialExterior,
    required this.onSearchChanged,
    required this.onRarityChanged,
    required this.onExteriorChanged,
  });

  @override
  State<SkinFilterBar> createState() => _SkinFilterBarState();
}

class _SkinFilterBarState extends State<SkinFilterBar> {
  late TextEditingController _controller;
  String? _rarity;
  String? _exterior;

  static const List<String> rarities = [
    'Any',
    'Consumer Grade',
    'Industrial Grade',
    'Mil-Spec',
    'Restricted',
    'Classified',
    'Covert',
  ];

  static const List<String> exteriors = [
    'Any',
    'Factory New',
    'Minimal Wear',
    'Field-Tested',
    'Well-Worn',
    'Battle-Scarred',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    _rarity = widget.initialRarity ?? 'Any';
    _exterior = widget.initialExterior ?? 'Any';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) {
    widget.onSearchChanged(v);
  }

  void _onRarityChanged(String? v) {
    setState(() => _rarity = v ?? 'Any');
    widget.onRarityChanged(v == 'Any' ? null : v);
  }

  void _onExteriorChanged(String? v) {
    setState(() => _exterior = v ?? 'Any');
    widget.onExteriorChanged(v == 'Any' ? null : v);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search skins, weapons, authors…',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: _onSearchChanged,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _rarity,
                    items: rarities.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: _onRarityChanged,
                    isExpanded: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _exterior,
                    items: exteriors.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: _onExteriorChanged,
                    isExpanded: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
