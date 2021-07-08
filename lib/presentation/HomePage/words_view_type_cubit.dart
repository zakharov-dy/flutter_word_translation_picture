import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';

part 'words_view_type_state.dart';

class WordsViewTypeCubit extends Cubit<WordsViewType> {
  WordsViewTypeCubit() : super(WordsViewType.grid) {
    _initialize();
  }

  void _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(WordsViewType.values[prefs.getInt('wordsViewType') ?? 0]);
  }

  void change() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final res =
        state == WordsViewType.list ? WordsViewType.grid : WordsViewType.list;
    await prefs.setInt('wordsViewType', res.index);
    emit(res);
  }
}
