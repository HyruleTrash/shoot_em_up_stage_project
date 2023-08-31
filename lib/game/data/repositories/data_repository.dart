import 'dart:async';
import 'dart:convert';
import 'dart:html';

class RemoteDataSource {
  Future<String?> fetchDataFromUrl() async {
    final completer = Completer<String?>();

    final request = HttpRequest();
    request.open('GET', 'https://api.chucknorris.io/jokes/random');

    request.onLoad.listen((event) {
      if (request.status == 200) {
        final response = json.decode(request.responseText ?? '')['value'];
        completer.complete(response);
      } else {
        completer.complete(null);
      }
    });

    request.send();

    return completer.future;
  }
}
