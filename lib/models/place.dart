class Place {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int? population;
  final List<String>? postcodes;
  final String country;
  final String admin1;
  final String admin2;
  final String admin3;

  Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.population,
    this.postcodes,
    required this.country,
    required this.admin1,
    required this.admin2,
    required this.admin3,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      population: json['population'] == null ? null : (json['population'] as num).toInt(),
      postcodes: json['postcodes'] == null
          ? null
          : List<String>.from(json['postcodes'] as List),
      country: json['country'] as String? ?? '',
      admin1: json['admin1'] as String? ?? '',
      admin2: json['admin2'] as String? ?? '',
      admin3: json['admin3'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'population': population,
        'postcodes': postcodes,
        'country': country,
        'admin1': admin1,
        'admin2': admin2,
        'admin3': admin3,
      };
}