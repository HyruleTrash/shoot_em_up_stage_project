import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shoot_em_up_stage_project/game/data/models/chuck_data.dart';

class RemoteDataSource {
  Future<ChuckNorrisJoke?> fetchDataFromUrl() async {
    final url = Uri.parse('https://api.chucknorris.io/jokes/random');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final chuckNorrisJoke = ChuckNorrisJoke(
        id: responseData['id'],
        value: responseData['value'],
        iconUrl: responseData['icon_url'],
      );
      return chuckNorrisJoke;
    } else {
      return null;
    }
  }
}
