import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:word_translation_picture/dataProvider/models/Pictures.dart';
import 'package:word_translation_picture/dataProvider/models/Translations.dart';
import 'dart:convert';

import 'package:word_translation_picture/models/Word.dart';

final firstWords = [
  Word(en: 'apple', ru: 'яблоко', image: 'https://cdn1.sph.harvard.edu/wp-content/uploads/sites/30/2018/10/apple-2711629_1920.jpg'),
  Word(en: 'pen', ru: 'ручка', image: 'https://www.parkerpen.com/dw/image/v2/BFGF_PRD/on/demandware.static/-/Sites-parkerpen-Library/default/dwf3906004/Parker/01%20JAN/50-50/201772385-Parker-Browse-by-Collection-Desktop-Tablet-Homepage-50-50_v2.jpeg'),
  Word(en: 'pencil', ru: 'карандаш', image: 'https://img.icons8.com/plasticine/2x/pencil.png')
];

class DataProvider {
  Future<ServerTranslations> getTranslations({text: String}) async {
    final url = 'microsoft-translator-text.p.rapidapi.com';
    var queryParameters = {
      'to': 'ru',
      'api-version': '3.0',
      'from': 'en',
      'profanityAction': 'NoAction',
      'textType': 'plain',
    };
    final Map<String, String> headers = {
      'content-type': 'application/json',
      //TODO: hide
      'x-rapidapi-host': 'microsoft-translator-text.p.rapidapi.com',
      'x-rapidapi-key': env['APPLICATION_TRANSLATION_KEY']!
    };
    final request = jsonEncode([
      {'Text': text}
    ]);
    final response = await http.post(
        Uri.https(url, "/translate", queryParameters),
        headers: headers,
        body: request);

    final List<dynamic> responseJson = jsonDecode(response.body);
    final Map<String, dynamic> responseTranslations = responseJson[0];

    return ServerTranslations.fromJson(responseTranslations);
  }

  Future<GeneratePictures> getPictures({text: String}) async {
    final url = 'pixabay.com';
    var queryParameters = {
      'key': env['PIXABAY'],
      'q': text,
    };
    final response = await http.get(Uri.https(url, "/api/", queryParameters));
    return GeneratePictures.fromJson(jsonDecode(response.body));
  }

  // TODO: for fill the database
  Future<List<Word>> getInitialPreparedWords() async {
    String data = await rootBundle.loadString('dataset/data.json');
    final parsed = jsonDecode(data).cast<Map<String, dynamic>>();
    return firstWords + parsed.map<Word>((json) => Word.fromJson(json)).toList();
  }
}
