class CurrentUnits {
  final String? time;
  final String? interval;
  final String? temperature2m;
  final String? windSpeed10m;
  final String? weatherCode;

  CurrentUnits({
    this.time,
    this.interval,
    this.temperature2m,
    this.windSpeed10m,
    this.weatherCode,
  });

  factory CurrentUnits.fromJson(Map<String, dynamic> json) {
    return CurrentUnits(
      time: json['time'] as String?,
      interval: json['interval'] as String?,
      temperature2m: json['temperature_2m'] as String?,
      windSpeed10m: json['wind_speed_10m'] as String?,
      weatherCode: json['weather_code'] as String?,
    );
  }
}