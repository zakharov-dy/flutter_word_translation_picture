import 'package:objectbox/objectbox.dart';

@Entity()
class DBWord {
  int id = 0;
  String? ru;
  String? en;
  String? image;
}
