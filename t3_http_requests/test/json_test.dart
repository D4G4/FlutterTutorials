//import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:t3_http_requests/src/starship.dart';

void main() {
  test("Testing JSON serialization", () async {
    String url = "https://swapi.co/api/starships/";
    
    final response = await http.get(url);
    
    if(response.statusCode == 200) {
      //print(response.body);
      expect(parseStarship(response.body).results[0].name, 'Executor');
    }

      // http.get(url,
      //     headers: {"Content-Type": "application/json"}).then((response) {
      //   if (response != null && response.statusCode == 200) {
      //     print("response->\n${response.body}");
      //     expect(parseStarship(response.body), isNull);
      //   }
      // }).catchError((error) {
      //   print(error.toString());
      // });
  });
}
