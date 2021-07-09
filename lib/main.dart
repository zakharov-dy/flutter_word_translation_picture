import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:word_translation_picture/App.dart';
import 'package:word_translation_picture/dataProvider/Repository.dart';

import 'package:flutter/scheduler.dart' show timeDilation;

void main() async {
  // TODO: инициализировать сервис констант
  await DotEnv.load(fileName: "secret.env");
  await Firebase.initializeApp();
  // timeDilation = 5.0;
  runApp(MyApp(
    wordsRepository: Repository(),
  ));
}
