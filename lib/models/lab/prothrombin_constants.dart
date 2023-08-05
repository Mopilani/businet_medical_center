import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ProthrombinConstantModel {
  ProthrombinConstantModel._();

  ProthrombinConstantModel(
    this.id, {
    required this.title,
  });

  late int id;
  late dynamic mid; // Mongo document id
  late String title;

  static ProthrombinConstantModel fromMap(Map<String, dynamic> data) {
    ProthrombinConstantModel model = ProthrombinConstantModel._();
    model.id = data['id'];
    model.title = data['title'];
    model.mid = data['_id'];

    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
      };

  static const String collectionName = 'prothrombinConstants';

  String toJson() => json.encode(toMap());

  static ProthrombinConstantModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<ProthrombinConstantModel>> getAll() {
    List<ProthrombinConstantModel> catgs = [];
    return SystemMDBService.db
        .collection(collectionName)
        .find()
        .transform<ProthrombinConstantModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(ProthrombinConstantModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<ProthrombinConstantModel> stream() {
    return SystemMDBService.db.collection(collectionName).find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(ProthrombinConstantModel.fromMap(data));
        },
      ),
    );
  }

  Future<ProthrombinConstantModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection(collectionName)
        .aggregate(pipeline);

    return ProthrombinConstantModel.fromMap(d);
  }

  static Future<ProthrombinConstantModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection(collectionName)
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return ProthrombinConstantModel.fromMap(d);
  }

  static Future<ProthrombinConstantModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection(collectionName)
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return ProthrombinConstantModel.fromMap(d);
  }

  static Future<ProthrombinConstantModel?> findByTitle(String title) async {
    var d = await SystemMDBService.db
        .collection(collectionName)
        .findOne(where.eq('title', title));
    if (d == null) {
      return null;
    }
    return ProthrombinConstantModel.fromMap(d);
  }

  Future<ProthrombinConstantModel?> edit() async {
    var r = await SystemMDBService.db.collection(collectionName).update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection(collectionName).remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection(collectionName).remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection(collectionName).insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
