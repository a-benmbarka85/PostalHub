import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/place.dart';
import '../models/search_response.dart';
import '../styles/app_styles.dart';
import '../widgets/place_card.dart';
import '../widgets/recent_searches.dart';
import 'place_detail_screen.dart';

enum _SearchState { initial, loading, results, notFound, error }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  _SearchState _state = _SearchState.initial;
  List<Place> _results = [];
  String _lastQuery = '';
  String? _errorMessage;
  final List<String> _recent = [];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _search(String term) async {
    term = term.trim();
    if (term.isEmpty) return;

    setState(() {
      _state = _SearchState.loading;
      _lastQuery = term;
      _errorMessage = null;
    });

    try {
      final uri = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search'
        '?name=${Uri.encodeComponent(term)}&language=ca&countryCode=ES',
      );
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Error del servidor (${response.statusCode})');
      }
      final data = searchResponseFromJson(response.body);
      final list = data.results;
      if (list.isEmpty) {
        setState(() {
          _state = _SearchState.notFound;
        });
      } else {
        setState(() {
          _results = list;
          _state = _SearchState.results;
          _addToRecent(term);
        });
      }
    } catch (e) {
      setState(() {
        _state = _SearchState.error;
        _errorMessage = e.toString();
      });
    }
  }

  void _addToRecent(String term) {
    _recent.remove(term);
    _recent.insert(0, term);
    if (_recent.length > 5) {
      _recent.removeRange(5, _recent.length);
    }
  }

  void _retry() {
    if (_lastQuery.isNotEmpty) {
      _search(_lastQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.background,
      appBar: AppBar(
        title: const Text('PostalHub'),
        backgroundColor: AppStyles.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppStyles.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                textInputAction: TextInputAction.search,
                onSubmitted: _search,
                decoration: AppStyles.searchInputDecoration.copyWith(
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            setState(() {});
                          },
                        ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppStyles.spacingSm),
              if (_recent.isNotEmpty)
                RecentSearches(
                  terms: _recent,
                  onTap: (term) {
                    _controller.text = term;
                    _search(term);
                  },
                ),
              const SizedBox(height: AppStyles.spacingSm),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _SearchState.initial:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppStyles.spacingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 64, color: AppStyles.primaryLight),
                const SizedBox(height: AppStyles.spacingMd),
                Text(
                  'Escriu un codi postal o el nom d\'una població i prem buscar.',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodySecondary,
                ),
                const SizedBox(height: AppStyles.spacingSm),
                Text(
                  'Exemples: 17820, Banyoles, Barcelona',
                  textAlign: TextAlign.center,
                  style: AppStyles.caption,
                ),
              ],
            ),
          ),
        );
      case _SearchState.loading:
        return const Center(child: CircularProgressIndicator());
      case _SearchState.notFound:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppStyles.spacingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search_off, size: 56, color: AppStyles.textSecondary),
                const SizedBox(height: AppStyles.spacingMd),
                Text(
                  'No hem trobat cap població per «$_lastQuery»',
                  textAlign: TextAlign.center,
                  style: AppStyles.titleMedium,
                ),
                const SizedBox(height: AppStyles.spacingSm),
                Text(
                  'Prova amb un altre codi postal o nom.',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodySecondary,
                ),
              ],
            ),
          ),
        );
      case _SearchState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppStyles.spacingLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 48, color: AppStyles.error),
                const SizedBox(height: AppStyles.spacingMd),
                Text(
                  _errorMessage != null
                      ? 'Hi ha hagut un error en la connexió. Torna-ho a provar.'
                      : 'Hi ha hagut un error en la connexió. Torna-ho a provar.',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodySecondary,
                ),
                const SizedBox(height: AppStyles.spacingMd),
                ElevatedButton.icon(
                  onPressed: _retry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tornar a provar'),
                ),
              ],
            ),
          ),
        );
      case _SearchState.results:
        return ListView.separated(
          itemCount: _results.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppStyles.spacingSm),
          itemBuilder: (context, index) {
            final place = _results[index];
            return PlaceCard(
              place: place,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PlaceDetailScreen(place: place),
                  ),
                );
              },
            );
          },
        );
    }
  }
}