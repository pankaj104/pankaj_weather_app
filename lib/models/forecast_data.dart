class ForecastData {
  final double temperature;
  final String description;
  final String date;
  final String icon;

  ForecastData({
    required this.temperature,
    required this.description,
    required this.date,
    required this.icon,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      date: json['dt_txt'],
      icon: json['weather'][0]['icon'],
    );
  }
}
