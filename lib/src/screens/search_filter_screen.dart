import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cstrade/src/models/skin.dart';
import 'package:cstrade/src/services/skin_service.dart';
import 'package:cstrade/src/utils/navigation.dart';
import 'package:cstrade/src/widgets/skin_card.dart';
class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String query = '';
  Timer? _debounce;
  final Set<String> rarities = {};
  List<Skin> _all = [];
  List<Skin> _results = [];
  bool _loading = true;

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
                onChanged: (v) => _onQueryChanged(v),
              ),
              const SizedBox(height: 16),
              const Text('Rarity', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Consumer Grade', 'Industrial Grade', 'Mil-Spec', 'Restricted', 'Classified', 'Covert']
                    .map((r) => FilterChip(
                          label: Text(r),
                          selected: rarities.contains(r),
                          onSelected: (v) {
                            setState(() => v ? rarities.add(r) : rarities.remove(r));
                            _applyFilters();
                          },
                        ))
                    .toList(),
              ),
              
              // Results
              if (_loading) const Expanded(child: Center(child: CircularProgressIndicator())),
              if (!_loading && _results.isNotEmpty)
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.15,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final skin = _results[index];
                      return SkinCard(
                        skin: skin,
                        onTap: () => pushSkinDetail(context, skin),
                      );
                    },
                  ),
                ),
              if (!_loading && _results.isEmpty) const Expanded(child: Center(child: Text('No results'))),

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
                      onPressed: () {
                        _applyFilters();
                        // keep screen open so user can browse results here
                      },
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

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
    });
    try {
      final all = await const SkinService().loadLocalSkins();
      _all = all;
      _applyFilters();
    } catch (_) {
      _all = [];
      _results = [];
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _applyFilters() {
    final q = query.trim().toLowerCase();
    List<Skin> list = _all;
    if (q.isNotEmpty) {
      list = list.where((s) {
        final name = s.name.toLowerCase();
        final weapon = s.weapon.toLowerCase();
        final cat = s.category.toLowerCase();
        return name.contains(q) || weapon.contains(q) || cat.contains(q);
      }).toList();
    }
    if (rarities.isNotEmpty) {
      list = list.where((s) => rarities.any((r) => s.rarity.toLowerCase().contains(r.toLowerCase().split(' ').first))).toList();
    }
    setState(() {
      _results = list;
    });
  }

  void _reset() {
    _debounce?.cancel();
    setState(() {
      query = '';
      rarities.clear();
    });
    _applyFilters();
  }

  void _onQueryChanged(String v) {
    setState(() => query = v);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) _applyFilters();
    });
  }
}

