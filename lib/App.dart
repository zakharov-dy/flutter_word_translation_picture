import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:word_translation_picture/blocs/checkbox_list/checkbox_list_cubit.dart';
import 'package:word_translation_picture/blocs/word/word_bloc.dart';
import 'package:word_translation_picture/blocs/words/words_bloc.dart';
import 'package:word_translation_picture/blocs/words/words_events.dart';
import 'package:word_translation_picture/dataProvider/Repository.dart';
import 'package:word_translation_picture/models/DB/DBWord.dart';
import 'package:word_translation_picture/presentation/CardsPage.dart';
import 'package:word_translation_picture/presentation/CardsPage.dart';
import 'package:word_translation_picture/presentation/HomePage/HomePage.dart';
import 'package:word_translation_picture/presentation/NewWordPage.dart';
import 'objectbox.g.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key, required this.wordsRepository}) : super(key: key);
  final Repository wordsRepository;

  @override
  _MyApp createState() => _MyApp(wordsRepository: wordsRepository);
}

class _MyApp extends State<MyApp> {
  _MyApp({required this.wordsRepository}) : super();
  final Repository wordsRepository;
  Store? _store;

  @override
  void initState() {
    super.initState();
    //TODO?
    getApplicationDocumentsDirectory().then((Directory dir) {
      _store = Store(getObjectBoxModel(), directory: dir.path + '/objectbox');
    });
  }

  @override
  void dispose() {
    _store?.close(); // don't forget to close the store
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (this._store == null) {
      return Container();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<WordsBloc>(
            create: (BuildContext context) => WordsBloc(
                wordsRepository: wordsRepository, box: _store!.box<DBWord>())
              ..add(WordsLoaded())),
        BlocProvider<CheckboxListCubit>(
          create: (BuildContext context) => CheckboxListCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            brightness: Brightness.light,
            errorColor: Colors.deepOrange,
            fontFamily: 'Georgia',
            accentColor: Colors.indigo,
            primaryColor: Colors.deepPurple,
            primaryColorLight: Color(0xffFBC02D),
            primaryColorDark: Color(0xffFBC02D),
            appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurple),
            buttonColor: Colors.indigo,
            textTheme: TextTheme(
              headline3: TextStyle(
                  fontSize: 64.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              headline4: TextStyle(
                  fontSize: 36.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70),
            )),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(
                title: 'Home',
              ),
          CardsPage.routeName: (context) => CardsPage(),
          NewWordPage.routeName: (context) => BlocProvider<WordBloc>(
                create: (BuildContext context) => WordBloc(
                    wordsRepository: wordsRepository,
                    wordsBloc: BlocProvider.of<WordsBloc>(context)),
                child: NewWordPage(title: 'New word'),
              ),
        },
      ),
    );
  }
}
