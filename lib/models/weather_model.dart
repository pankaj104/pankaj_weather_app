class WeatherData {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final String description;
  final String mainWeather;
  final String icon;
  final double lon;
  final double lat;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final int cloudiness;
  final int sunrise;
  final int sunset;
  final String country;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.description,
    required this.mainWeather,
    required this.icon,
    required this.lon,
    required this.lat,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.cloudiness,
    required this.sunrise,
    required this.sunset,
    required this.country,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'] ?? 'Unknown',
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      description: json['weather'][0]['description'],
      mainWeather: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
      lon: json['coord']['lon'],
      lat: json['coord']['lat'],
      visibility: json['visibility'],
      windSpeed: json['wind']['speed'].toDouble(),
      windDeg: json['wind']['deg'],
      cloudiness: json['clouds']['all'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      country: json['sys']['country'],
    );
  }
}
