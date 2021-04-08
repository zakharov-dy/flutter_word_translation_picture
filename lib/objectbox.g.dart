// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

import 'models/DB/DBWord.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 8095835032894403113),
      name: 'DBWord',
      lastPropertyId: const IdUid(4, 593758447837558902),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1326595139270731103),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 1365154883778230889),
            name: 'ru',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2435695020508364913),
            name: 'en',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 593758447837558902),
            name: 'image',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(1, 8095835032894403113),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    DBWord: EntityDefinition<DBWord>(
        model: _entities[0],
        toOneRelations: (DBWord object) => [],
        toManyRelations: (DBWord object) => {},
        getId: (DBWord object) => object.id,
        setId: (DBWord object, int id) {
          object.id = id;
        },
        objectToFB: (DBWord object, fb.Builder fbb) {
          final ruOffset =
              object.ru == null ? null : fbb.writeString(object.ru!);
          final enOffset =
              object.en == null ? null : fbb.writeString(object.en!);
          final imageOffset =
              object.image == null ? null : fbb.writeString(object.image!);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, ruOffset);
          fbb.addOffset(2, enOffset);
          fbb.addOffset(3, imageOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = DBWord()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..ru =
                const fb.StringReader().vTableGetNullable(buffer, rootOffset, 6)
            ..en =
                const fb.StringReader().vTableGetNullable(buffer, rootOffset, 8)
            ..image = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 10);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [DBWord] entity fields to define ObjectBox queries.
class DBWord_ {
  /// see [DBWord.id]
  static final id = QueryIntegerProperty<DBWord>(_entities[0].properties[0]);

  /// see [DBWord.ru]
  static final ru = QueryStringProperty<DBWord>(_entities[0].properties[1]);

  /// see [DBWord.en]
  static final en = QueryStringProperty<DBWord>(_entities[0].properties[2]);

  /// see [DBWord.image]
  static final image = QueryStringProperty<DBWord>(_entities[0].properties[3]);
}
