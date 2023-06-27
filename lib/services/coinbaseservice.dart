import 'dart:convert';

import 'package:enhanced_http/enhanced_http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class CoinbaseService {
  String apiKey;
  String apiSecret;

  CoinbaseService({this.apiKey = '', this.apiSecret = ''});

  Future<void> initialize() async {
    apiKey = dotenv.env['API_KEY'] ?? apiKey;
    apiSecret = dotenv.env['API_SECRET'] ?? apiSecret;
  }

  Future<List<dynamic>> getCurrencies() async {
    dynamic headers = {
      'Content-Type': 'application/json',
    };

    var request = http.Request(
      'GET',
      Uri.parse('https://api.exchange.coinbase.com/currencies'),
    );

    request.headers.addAll(headers);

    http.Response response =
        await http.get(request.url, headers: request.headers);

    if (response.statusCode == 200) {
      var json = response.body;
      var data = jsonDecode(json);
      List<dynamic> currencies = data;
      return currencies;
    } else {
      print(response);
      return [];
    }
  }

  // Future<dynamic> getConversionRate(
  //     String fromCurrency, String toCurrency) async {
  //   String pair = '$fromCurrency-$toCurrency';

  //   int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  //   String requestPath =
  //       'https://api.coinbase.com/api/v3/brokerage/products/$pair/ticker';

  //   String reducedRequestPath =
  //       '/api.coinbase.com/api/v3/brokerage/products/$pair/ticker';
  //   String message = "$timestamp${'GET'.toUpperCase()}$reducedRequestPath ''";
  //   List<int> messageBytes = utf8.encode(message);
  //   List<int> secretBytes = utf8.encode(apiSecret);
  //   Hmac hmacSha256 = Hmac(sha256, secretBytes);
  //   Digest digest = hmacSha256.convert(
  //     messageBytes,
  //   );

  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'CB-ACCESS-KEY': apiKey,
  //     'CB-ACCESS-TIMESTAMP': timestamp.toString(),
  //     'CB-ACCESS-SIGN': digest.toString(),
  //   };

  //   var request = http.Request(
  //     'GET',
  //     Uri.parse(requestPath),
  //   );

  //   request.headers.addAll(headers);

  //   http.Response response =
  //       await http.get(request.url, headers: request.headers);

  //   if (response.statusCode == 200) {
  //     var responseBody = jsonDecode(response.body);
  //     print(responseBody);
  //     return responseBody;
  //   } else {
  //     print(response.statusCode);
  //     return null; // Handle error case, e.g., return null or throw an exception
  //   }
  // }

  Future<dynamic> getConversionRate(
      String fromCurrency, String toCurrency) async {
    String pair = '$fromCurrency-$toCurrency';
    int timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000);
    String requestPath = '/api/v3/brokerage/products/$pair/';

    String str = '$timestamp${'GET'.toUpperCase()}$requestPath';
    Digest digest =
        Hmac(sha256, utf8.encode(apiSecret)).convert(utf8.encode(str));
    String signature = digest.toString();

    var headers = {
      'Content-Type': 'application/json',
      'CB-ACCESS-KEY': apiKey,
      'CB-ACCESS-TIMESTAMP': timestamp.toString(),
      'CB-ACCESS-SIGN': signature,
    };

    Uri requestUrl = Uri.https('api.coinbase.com', requestPath);
    Response response = await http.get(requestUrl, headers: headers);

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      return responseBody;
    } else {
      print(response.statusCode);
      return null; // Handle error case, e.g., return null or throw an exception
    }
  }
}
