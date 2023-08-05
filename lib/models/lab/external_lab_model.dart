import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ExternalLabModel {
  ExternalLabModel._();

  ExternalLabModel(
    this.id, {
    required this.title,
  });

  late int id;
  late dynamic mid; // Mongo document id
  late String title;

  static ExternalLabModel fromMap(Map<String, dynamic> data) {
    ExternalLabModel model = ExternalLabModel._();
    model.id = data['id'];
    model.title = data['title'];
    model.mid = data['_id'];

    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
      };

  String toJson() => json.encode(toMap());

  static ExternalLabModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<ExternalLabModel>> getAll() {
    List<ExternalLabModel> catgs = [];
    return SystemMDBService.db
        .collection('externalLabs')
        .find()
        .transform<ExternalLabModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(ExternalLabModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<ExternalLabModel> stream() {
    return SystemMDBService.db.collection('externalLabs').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(ExternalLabModel.fromMap(data));
        },
      ),
    );
  }

  Future<ExternalLabModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('externalLabs')
        .aggregate(pipeline);

    return ExternalLabModel.fromMap(d);
  }

  static Future<ExternalLabModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('externalLabs')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return ExternalLabModel.fromMap(d);
  }

  static Future<ExternalLabModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('externalLabs')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return ExternalLabModel.fromMap(d);
  }

  static Future<ExternalLabModel?> findByTitle(String title) async {
    var d = await SystemMDBService.db
        .collection('externalLabs')
        .findOne(where.eq('title', title));
    if (d == null) {
      return null;
    }
    return ExternalLabModel.fromMap(d);
  }

  Future<ExternalLabModel?> edit() async {
    var r = await SystemMDBService.db.collection('externalLabs').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('externalLabs').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('externalLabs').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('externalLabs').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
