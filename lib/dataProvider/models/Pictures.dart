import 'package:word_translation_picture/models/Picture.dart';

class GeneratePictures {
  int? total;
  int? totalHits;
  List<Picture>? hits;

  GeneratePictures({this.total, this.totalHits, this.hits});

  GeneratePictures.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    totalHits = json['totalHits'];
    if (json['hits'] != null) {
      hits = <Picture>[];
      json['hits'].forEach((v) {
        hits!.add(new Picture.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['totalHits'] = this.totalHits;
    if (this.hits != null) {
      data['hits'] = this.hits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


