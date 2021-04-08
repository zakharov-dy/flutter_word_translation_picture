import 'package:word_translation_picture/models/Translations.dart';
import 'package:word_translation_picture/models/Picture.dart';
import 'package:word_translation_picture/models/Word.dart';

import 'DataProvider.dart';

String Function(Picture p) picturesToURLsMapper = (Picture p) => p.largeImageURL;

class Repository {
  final DataProvider dataProvider = DataProvider();

  Future<List<Translations>?> getTranslations({text: String}) async {
    var translations = await dataProvider.getTranslations(text: text);
    return translations.translations;
  }

  Future<List<String>?> getPictures({text: String}) async {
    var pictures = await dataProvider.getPictures(text: text);
    if (pictures.hits == null) {
      return [];
    }

    return pictures.hits!.map(picturesToURLsMapper).toList();
  }

  Future<List<Word>?> getInitialPreparedWords() async {
    return await dataProvider.getInitialPreparedWords();
  }

  // TODO: upd later
  List<Word> loadWords({text: String}) {
    return [
      Word(en: 'apple', ru: 'яблоко', image: 'https://cdn1.sph.harvard.edu/wp-content/uploads/sites/30/2018/10/apple-2711629_1920.jpg'),
      Word(en: 'pen', ru: 'ручка', image: 'https://www.parkerpen.com/dw/image/v2/BFGF_PRD/on/demandware.static/-/Sites-parkerpen-Library/default/dwf3906004/Parker/01%20JAN/50-50/201772385-Parker-Browse-by-Collection-Desktop-Tablet-Homepage-50-50_v2.jpeg'),
      Word(en: 'pencil', ru: 'карандаш', image: 'https://img.icons8.com/plasticine/2x/pencil.png')
    ];
  }
}
