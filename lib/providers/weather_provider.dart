import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/forecast_data.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  bool isCelsius = true;
  bool isLoading = false;
  String errorMessage = '';
  WeatherData? weatherData;
  TextEditingController cityController = TextEditingController();
  List<ForecastData>? forecastData; // 5-day forecast


  WeatherProvider() {
    loadPreferences();
  }

  /// fetch weather data and 3day forecast data
  Future<void> fetchWeather(String city) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      final data = await WeatherService.fetchWeather(city, isCelsius);
      final forecast = await WeatherService.fetch3DayForecast(city, isCelsius);
      weatherData = data;
      forecastData = forecast;
      log('data is printing $data');
      saveCity(city);
    } catch (error) {
      log('error i am getting $error');
      errorMessage = 'Failed to load weather data';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleUnit() {
    isCelsius = !isCelsius;
    notifyListeners();
  }

  /// save city to hive database
  void saveCity(String city) async {
    final box = await Hive.openBox('weatherAppData');
    box.put('lastCity', city);
  }

  /// load data from local
  void loadPreferences() async {
    final box = await Hive.openBox('weatherAppData');
    final lastCity = box.get('lastCity', defaultValue: '');
    if (lastCity != '') {
      cityController.text = lastCity;
      fetchWeather(lastCity);
    }
  }
}
