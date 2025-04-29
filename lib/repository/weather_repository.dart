import 'package:dio/dio.dart';
import 'package:nolatech/models/court_model.dart';

class WeatherRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<String> getDailyPrecipitationMax(CourtModel court) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'latitude': court.latitude,
          'longitude': court.longitude,
          'daily': 'precipitation_probability_max',
          'hourly': 'precipitation_probability',
          'current': 'precipitation',
          'timezone': 'auto',
          'forecast_days': 1,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final daily = data['daily'];
        final List<dynamic> precipitationMaxList =
            daily['precipitation_probability_max'];
        if (precipitationMaxList.isNotEmpty) {
          return "%${precipitationMaxList.first.toString()}";
        } else {
          return 'No data';
        }
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Exception: $e';
    }
  }
}
