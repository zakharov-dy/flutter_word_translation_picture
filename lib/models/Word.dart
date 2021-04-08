import 'package:equatable/equatable.dart';

class Word extends Equatable {
  // this id help DB operation
  int? id;
  String ru;
  String en;
  String? image;

  Word({required this.ru, required this.en, this.image, this.id});

  @override
  List<Object?> get props => [ru, en, image];

  Word copyWith({String? ru, String? en, String? image, int? id}) {
    return Word(
      ru: ru ?? this.ru,
      en: en ?? this.en,
      image: image ?? this.image,
      id: id ?? this.id,
    );
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      ru: json['ru'] as String,
      en: json['en'] as String,
    );
  }
}
