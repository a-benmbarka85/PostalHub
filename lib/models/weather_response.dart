import 'dart:convert';

import 'current.dart';
import 'current_units.dart';

WeatherResponse weatherResponseFromJson(String str) =>
    WeatherResponse.fromJson(json.decode(str) as Map<String, dynamic>);

class WeatherResponse {
  final double? latitude;
  final double? longitude;
  final double? generationtimeMs;
  final int? utcOffsetSeconds;
  final String? timezone;
  final String? timezoneAbbreviation;
  final double? elevation;
  final CurrentUnits? currentUnits;
  final Current? current;

  WeatherResponse({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.currentUnits,
    this.current,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      latitude: json['latitude'] == null ? null : (json['latitude'] as num).toDouble(),
      longitude: json['longitude'] == null ? null : (json['longitude'] as num).toDouble(),
      generationtimeMs: json['generationtime_ms'] == null
          ? null
          : (json['generationtime_ms'] as num).toDouble(),
      utcOffsetSeconds: json['utc_offset_seconds'] == null
          ? null
          : (json['utc_offset_seconds'] as num).toInt(),
      timezone: json['timezone'] as String?,
      timezoneAbbreviation: json['timezone_abbreviation'] as String?,
      elevation: json['elevation'] == null ? null : (json['elevation'] as num).toDouble(),
      currentUnits: json['current_units'] == null
          ? null
          : CurrentUnits.fromJson(json['current_units'] as Map<String, dynamic>),
      current: json['current'] == null ? null : Current.fromJson(json['current'] as Map<String, dynamic>),
    );
  }
}