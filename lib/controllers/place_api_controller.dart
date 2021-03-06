import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intechpro/model/address_suggestion.dart';
import 'package:intechpro/model/place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlaceApiProvider {
  final sessionToken;
  PlaceApiProvider(this.sessionToken);

  static final String androidKey = dotenv.env["GOOGLE_API_KEY"]??"";
  static final String iosKey = dotenv.env["GOOGLE_API_KEY"]??"";

  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<AddressSuggestion>> fetchSuggestions(
      String input, String lang) async {
    print("uiy####");
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=$lang&key=$apiKey&sessiontoken=$sessionToken';
    final response = await http.get(Uri.parse(request));
    print("hreRR#");
    print(response.body);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      print("stautdata#00");
      print(result);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        
            print("oksug###");
            print(result['predictions']
            .map<AddressSuggestion>((p) => AddressSuggestion(
                description: p['description'], placeId: p['place_id']))
            .toList());

            return result['predictions']
            .map<AddressSuggestion>((p) => AddressSuggestion(
                description: p['description'], placeId: p['place_id']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
            result['result']['address_components'] as List<dynamic>;
        // build result
        final place = Place();
        components.forEach((c) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
        });
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
