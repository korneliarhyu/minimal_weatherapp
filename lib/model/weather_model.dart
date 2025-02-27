class Weather {
  final String city;
  final double temperature;
  final String condition;

  Weather({
    required this.city,
    required this.temperature,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['location']['name'] ?? "Unknown",
      temperature: (json['current']?['temp_c'] ?? 0.0).toDouble(),
      condition: json['current']['condition']['text'] ?? 'Unknown',
    );
  }
}
