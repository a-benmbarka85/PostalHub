import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/place.dart';
import '../models/weather_response.dart';
import '../styles/app_styles.dart';
import '../widgets/info_card.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Place place;

  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  late final Future<WeatherResponse> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _fetchWeather();
  }

  Future<WeatherResponse> _fetchWeather() async {
    final place = widget.place;
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=${place.latitude}&longitude=${place.longitude}'
      '&current=temperature_2m,weather_code,wind_speed_10m',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Error del servidor (${response.statusCode})');
    }
    return weatherResponseFromJson(response.body);
  }

  IconData _weatherIcon(int? code) {
    if (code == null) return Icons.help_outline;
    if (code == 0) return Icons.wb_sunny;
    if (code >= 1 && code <= 3) return Icons.wb_cloudy;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 51 && code <= 67) return Icons.umbrella;
    if (code >= 71 && code <= 77) return Icons.ac_unit;
    if (code >= 80 && code <= 82) return Icons.grain;
    if (code == 85 || code == 86) return Icons.snowing;
    if (code >= 95 && code <= 99) return Icons.thunderstorm;
    return Icons.help_outline;
  }

  String _weatherDescription(int? code) {
    if (code == null) return 'Desconegut';
    if (code == 0) return 'Cielo despejado';
    if (code >= 1 && code <= 3) return 'Algunas nubes';
    if (code == 45 || code == 48) return 'Niebla';
    if (code >= 51 && code <= 67) return 'Lluvia';
    if (code >= 71 && code <= 77) return 'Nieve';
    if (code >= 80 && code <= 82) return 'Chubascos';
    if (code == 85 || code == 86) return 'Chubascos de nieve';
    if (code >= 95 && code <= 99) return 'Tormenta';
    return 'Desconegut';
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    return Scaffold(
      backgroundColor: AppStyles.background,
      appBar: AppBar(
        title: Text('🐧 ${place.name}'),
        backgroundColor: AppStyles.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppStyles.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoCard(
                children: [
                  _infoRow(Icons.map, 'Provincia', place.admin2),
                  _infoRow(Icons.flag, 'Comunitat', place.admin1),
                  if (place.population != null)
                    _infoRow(Icons.people, 'Habitants', place.population.toString()),
                  _infoRow(Icons.my_location, 'Latitud', place.latitude.toStringAsFixed(5)),
                  _infoRow(Icons.my_location, 'Longitud', place.longitude.toStringAsFixed(5)),
                ],
              ),
              const SizedBox(height: AppStyles.spacingMd),
              Text('Codis postals', style: AppStyles.titleMedium),
              const SizedBox(height: AppStyles.spacingSm),
              Wrap(
                spacing: AppStyles.spacingSm,
                runSpacing: AppStyles.spacingSm,
                children: (place.postcodes ?? [])
                    .map(
                      (c) => Chip(
                        label: Text(c),
                        backgroundColor: AppStyles.primaryLight.withValues(alpha: 0.15),
                        side: const BorderSide(color: AppStyles.primaryLight),
                      ),
                    )
                    .toList(),
              ),
              if ((place.postcodes ?? []).isEmpty)
                Text('Sense codis postals', style: AppStyles.bodySecondary),
              const SizedBox(height: AppStyles.spacingLg),
              Text('Temps ara', style: AppStyles.titleMedium),
              const SizedBox(height: AppStyles.spacingSm),
              FutureBuilder<WeatherResponse>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(
                      'No s\'ha pogut carregar el temps. Torna-ho a provar més tard.',
                      style: AppStyles.bodySecondary,
                    );
                  }
                  final current = snapshot.data?.current;
                  if (current == null) {
                    return Text('Sense dades meteorològiques.', style: AppStyles.bodySecondary);
                  }
                  return InfoCard(
                    children: [
                      Row(
                        children: [
                          Icon(_weatherIcon(current.weatherCode), size: 40, color: AppStyles.weather),
                          const SizedBox(width: AppStyles.spacingMd),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${current.temperature2m?.toStringAsFixed(1) ?? '-'} °C',
                                style: AppStyles.titleLarge,
                              ),
                              Text(
                                _weatherDescription(current.weatherCode),
                                style: AppStyles.bodySecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppStyles.spacingSm),
                      _infoRow(Icons.air, 'Vent', '${current.windSpeed10m?.toStringAsFixed(1) ?? '-'} km/h'),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.spacingXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppStyles.textSecondary),
          const SizedBox(width: AppStyles.spacingSm),
          SizedBox(
            width: 90,
            child: Text(label, style: AppStyles.bodySecondary),
          ),
          Expanded(child: Text(value, style: AppStyles.body)),
        ],
      ),
    );
  }
}
