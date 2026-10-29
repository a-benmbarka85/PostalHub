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
                  _infoRow('Provincia', place.admin2),
                  _infoRow('Comunitat', place.admin1),
                  if (place.population != null)
                    _infoRow('Habitants', place.population.toString()),
                  _infoRow('Latitud', place.latitude.toString()),
                  _infoRow('Longitud', place.longitude.toString()),
                ],
              ),
              const SizedBox(height: AppStyles.spacingMd),
              Text('Codis postals', style: AppStyles.titleMedium),
              const SizedBox(height: AppStyles.spacingSm),
              Wrap(
                spacing: AppStyles.spacingSm,
                runSpacing: AppStyles.spacingSm,
                children: (place.postcodes ?? [])
                    .map((c) => Chip(label: Text(c)))
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
                      _infoRow('Temperatura', '${current.temperature2m?.toStringAsFixed(1) ?? '-'} °C'),
                      _infoRow('Vent', '${current.windSpeed10m?.toStringAsFixed(1) ?? '-'} km/h'),
                      _infoRow('Cel', _weatherDescription(current.weatherCode)),
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.spacingXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: AppStyles.bodySecondary),
          ),
          Expanded(child: Text(value, style: AppStyles.body)),
        ],
      ),
    );
  }
}