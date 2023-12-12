import 'package:frontend/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

Future<Map> loginRequest(email, password) async {
  final response = await http.post(
    Uri.http(baseUrl, 'api/auth/login'),
    body: json.encode({'email': email, 'password': password}),
  );

  return jsonDecode(response.body);
}

Future<Map> registerRequest(name, cpf, phoneNumber, email, password) async {
  final response = await http.post(
    Uri.http(baseUrl, 'api/auth/register'),
    body: json.encode({'name': name, 'cpf': cpf, 'phone_number': phoneNumber, 'email': email, 'password': password}),
  );

  return jsonDecode(response.body);
}

Future<Map> getProductRequest(productId) async {
  String? basicToken = await SecureStorage().readSecureData('authToken');
  final response = await http.get(
    Uri.http(baseUrl, 'api/products/$productId'),
    headers: {'Authorization': 'Basic $basicToken'}
  );

  return jsonDecode(response.body);
}


Future<Map> buyProductRequest(products) async {
  String? basicToken = await SecureStorage().readSecureData('authToken');
  final response = await http.post(
    Uri.http(baseUrl, '/api/shopping/buy'),
    body: jsonEncode(products),
    headers: {'Authorization': 'Basic $basicToken'}
  );

  return jsonDecode(response.body);
}
