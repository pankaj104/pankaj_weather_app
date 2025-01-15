import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../utils/app_colors.dart';

extension StringCasingExtension on String {
  String get toCapitalized => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized).join(' ');
}

class WeatherCard extends StatelessWidget {
  final WeatherData weatherData;
  final bool isCelsius;
  const WeatherCard({Key? key, required this.weatherData, required this.isCelsius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getCountryName(String countryCode) {
      final locale = Locale('', countryCode); // Empty language code for country only
      return Intl.message('', name: '', locale: locale.toString());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            decoration: const BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage(Resource.homeTopBg),
              //   fit: BoxFit.cover,
              // ),
            ),
            child: Column(
              children: [
                Text("${weatherData.cityName.toCapitalized}, ${weatherData.country.toCapitalized}",
                    style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.w500, color: Colors.white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                     Text( isCelsius? "${weatherData.temperature.toInt()}° C" : "${weatherData.temperature.toInt()}° F",
                        style: GoogleFonts.arapey(fontSize: 80, fontWeight: FontWeight.w400, color: Colors.white)),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Image.network('http://openweathermap.org/img/wn/${weatherData.icon}@2x.png',
                            height: 90, color: Colors.white),
                        Text(weatherData.description.toCapitalized,
                            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 45),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Humidity: ${weatherData.humidity}%',
                            style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white)),

                        Text("H:${weatherData.tempMax.toInt()}°  L:${weatherData.tempMin.toInt()}°",
                            style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WeatherFeatureWidget(
                featureName: 'Wind speed',
                value:  isCelsius ? "${weatherData.windSpeed} meter/s" : "${weatherData.windSpeed} miles/h",
                icon: Icons.air_rounded,
                isCelsius: isCelsius,
              ),
              _WeatherFeatureWidget(
                featureName: 'Pressure',
                value: "${weatherData.pressure} hpa",
                icon: Icons.waves, isCelsius: isCelsius,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _WeatherFeatureWidget extends StatelessWidget {
  final String featureName;
  final String value;
  final IconData icon;
  final bool isCelsius;

  const _WeatherFeatureWidget({
    Key? key,
    required this.featureName,
    required this.value,
    required this.icon,
    required this.isCelsius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      width: 180,
      height: 65,
      decoration: BoxDecoration(
        color: AppColors.weatherFeatureColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(featureName, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
              const SizedBox(height: 6),
              Text(value, style: GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
