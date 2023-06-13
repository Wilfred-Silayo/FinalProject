import 'package:http/http.dart' as http;

class SimsApi {
  final String appKey = 'base64:esd6rxNI6hJc9/lCZpq0jEf266iLPx5KLp9p/JLKk2M=';
  final String baseUrl;

  const SimsApi({required this.baseUrl});
  Future<http.Response> generateToken(String registrationNumber) async {
    final url = Uri.parse("$baseUrl/generate/token");
    final response = await http.post(
      url,
      body: {
        "user": registrationNumber,
        "app_key": appKey,
      },
    );
    return response;
  }

  Future<http.Response> verifyToken(
      String registrationNumber, String token) async {
    final url = Uri.parse("$baseUrl/verify/token");
    final response = await http.post(
      url,
      body: {
        "user": registrationNumber,
        "app_key": appKey,
        "token": token,
      },
    );
    return response;
  }
}
