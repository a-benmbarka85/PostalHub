import 'dart:convert';

import 'place.dart';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  final List<Place> results;
  final double? generationtimeMs;

  SearchResponse({
    required this.results,
    this.generationtimeMs,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      results: json['results'] == null
          ? []
          : List<Place>.from(
              (json['results'] as List).map((x) => Place.fromJson(x as Map<String, dynamic>)),
            ),
      generationtimeMs: json['generationtime_ms'] == null
          ? null
          : (json['generationtime_ms'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'results': results.map((x) => x.toJson()).toList(),
        'generationtime_ms': generationtimeMs,
      };
}