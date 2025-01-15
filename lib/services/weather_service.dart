import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forecast_data.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';

class WeatherService {
  /// Fetches current weather data for a given city.
  /// Returns a [WeatherData] object if the request is successful,
  /// otherwise throws an exception.
  static Future<WeatherData> fetchWeather(String city, bool isCelsius) async {
    final unit = isCelsius ? 'metric' : 'imperial';

    // Make an HTTP GET request to the OpenWeatherMap API for current weather
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=$unit&appid=$apiKey'));

    // Check if the response was successful
    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      // Throw an exception if the request failed
      throw Exception('Failed to load weather data');
    }
  }

  /// Fetches a 3-day weather forecast for a given city.
  static Future<List<ForecastData>> fetch3DayForecast(String city, bool isCelsius) async {
    final unit = isCelsius ? 'metric' : 'imperial';

    // Make an HTTP GET request to the OpenWeatherMap API for 5-day/3-hour forecast
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=$unit&appid=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Extract the forecast list from the response
      final List forecastList = data['list'];

      return forecastList
          .where((item) => item['dt_txt'].contains('12:00:00'))
          .take(5)
          .map((item) => ForecastData.fromJson(item))
          .toList();
    } else {
      // Throw an exception if the request failed
      throw Exception('Failed to load forecast data');
    }
  }
}
