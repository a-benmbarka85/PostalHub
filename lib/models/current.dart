class Current {
  final String? time;
  final int? interval;
  final double? temperature2m;
  final double? windSpeed10m;
  final int? weatherCode;

  Current({
    this.time,
    this.interval,
    this.temperature2m,
    this.windSpeed10m,
    this.weatherCode,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      time: json['time'] as String?,
      interval: json['interval'] == null ? null : (json['interval'] as num).toInt(),
      temperature2m: json['temperature_2m'] == null ? null : (json['temperature_2m'] as num).toDouble(),
      windSpeed10m: json['wind_speed_10m'] == null ? null : (json['wind_speed_10m'] as num).toDouble(),
      weatherCode: json['weather_code'] == null ? null : (json['weather_code'] as num).toInt(),
    );
  }
}