import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/image_resource.dart';
import '../widgets/weather_card.dart';
import '../providers/weather_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ConnectivityResult? _connectivityStatus;

  @override
  void initState() {
    super.initState();
    // Initialize connectivity listener
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectivityStatus = result;
      });
      if (result == ConnectivityResult.none) {
        showNoInternetSnackBar(context);
      }
    });
  }


  String getRelativeDateString(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final dayAfterTomorrow = now.add(const Duration(days: 2));

    if (date.isSameDate(now)) {
      return "Today";
    } else if (date.isSameDate(tomorrow)) {
      return "Tomorrow";
    } else if (date.isSameDate(dayAfterTomorrow)) {
      return "Day after tomorrow";
    } else {
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
  }

  void showNoInternetSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('No internet connection'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,

      ),
      body:StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
            final connectivityResult = snapshot.data;
            if (connectivityResult == ConnectivityResult.none) {
              Future.microtask(() => showNoInternetSnackBar(context));
            }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 470,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Resource.homeTopBg),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                    )
                  ),
                  child: Column(
                    children: [
                      _SearchBar(weatherProvider: weatherProvider),
                      weatherProvider.isLoading
                          ?  const Center(child: CircularProgressIndicator(color: Colors.white,))
                          : weatherProvider.errorMessage.isNotEmpty
                          ? Center(
                        child: Text(
                          weatherProvider.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                          : weatherProvider.weatherData == null
                          ? Container(
                            child: const Center(
                                            child: Text('No data available'),
                                          ),
                          )
                          : Column(
                        children: [
                          WeatherCard(weatherData: weatherProvider.weatherData! , isCelsius: weatherProvider.isCelsius, ),
                          const SizedBox(height: 16),

                        ],
                      ),
                    ],
                  ),
                ),
                weatherProvider.weatherData == null ?
                    const SizedBox():
                _ForecastSection(
                  forecastData: weatherProvider.forecastData,
                  getRelativeDateString: getRelativeDateString, isCelsius: weatherProvider.isCelsius,
                ),

              ],
            ),
          );
        }
      ),
    );
  }
}

/// search bar on home screen
class _SearchBar extends StatelessWidget {
  final WeatherProvider weatherProvider;

  const _SearchBar({Key? key, required this.weatherProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: weatherProvider.cityController,
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
                      decoration: const InputDecoration(
                        hintText: 'Search for a city',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onSubmitted: weatherProvider.fetchWeather,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.buttonSearchColor, // Background color for the container
                        borderRadius: BorderRadius.circular(18), // Adjust the radius as needed
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26, // Shadow color
                            blurRadius: 4, // Blur effect
                            offset: Offset(2, 2), // Position of the shadow
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          String city = weatherProvider.cityController.text;
                          if (city.isNotEmpty) {
                            weatherProvider.fetchWeather(city);
                          }
                        },
                        icon: const Icon(Icons.search_rounded, size: 23, color: Colors.white),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0), // Optional padding for better alignment
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  weatherProvider.isCelsius ? Icons.thermostat : Icons.ac_unit,
                  color: Colors.black,
                ),
                const SizedBox(width: 8), // Space between icon and switch
                Switch(
                  value: weatherProvider.isCelsius,
                  activeColor: Colors.blue, // Color of the switch when it's active
                  inactiveThumbColor: Colors.grey, // Color of the thumb when inactive
                  inactiveTrackColor: Colors.grey.shade300, // Color of the track when inactive
                  onChanged: (value) {
                    weatherProvider.toggleUnit();
                    weatherProvider.fetchWeather(weatherProvider.cityController.text.toString());
                  },
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

/// 5 days forecast section
class _ForecastSection extends StatelessWidget {
  final List? forecastData;
  final String Function(DateTime) getRelativeDateString;
  final bool isCelsius;

  const _ForecastSection({
    Key? key,
    required this.forecastData,
    required this.getRelativeDateString,
    required this.isCelsius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (forecastData == null) {
      return const Center(child: Text('No forecast data available'));
    }
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "5-Day Forecast",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: forecastData!.length,
            itemBuilder: (context, index) {
              final forecast = forecastData![index];
              return Card(
                color: const Color(0xff1e2f50),

                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Image.network('http://openweathermap.org/img/wn/${forecast.icon}@2x.png', color: Colors.white),
                  title: Text(
                      isCelsius?  "${forecast.temperature.toInt()}C° | ${forecast.description}" : "${forecast.temperature.toInt()}F° | ${forecast.description}",
                    style:  GoogleFonts.poppins(color: Colors.white),
                  ),
                  subtitle: Text(
                    getRelativeDateString(DateTime.parse(forecast.date)),
                    style:  GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
