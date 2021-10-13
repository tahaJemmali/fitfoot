import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:workspace/Models/address.dart';

class BackendService {
  static Future<List<Address>> getSuggestions(String query) async {
    try {
      final response =
          await http.get(Uri.https("restcountries.eu", "/rest/v2/all"));
      if (response.statusCode == 200) {
        final List countries = json.decode(response.body);
        return countries
            .map((model) => Address.fromJson(model))
            .where((element) {
          final nameLower = element.name.toLowerCase();
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower);
        }).toList();
      }
    } on HttpException catch (err) {
      print("Network exception error: $err");
      return null;
    } finally {}
  }
}
