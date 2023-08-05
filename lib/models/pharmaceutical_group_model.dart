import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class PharmaceuticalGroupModel {
  PharmaceuticalGroupModel._();

  PharmaceuticalGroupModel(
    this.id, {
    required this.title,
  });

  late int id;
  late dynamic mid; // Mongo document id
  late String title;

  static PharmaceuticalGroupModel fromMap(Map<String, dynamic> data) {
    PharmaceuticalGroupModel model = PharmaceuticalGroupModel._();
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

  static PharmaceuticalGroupModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<PharmaceuticalGroupModel>> getAll() {
    List<PharmaceuticalGroupModel> catgs = [];
    return SystemMDBService.db
        .collection('pharmaceuticalsGroups')
        .find()
        .transform<PharmaceuticalGroupModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(PharmaceuticalGroupModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<PharmaceuticalGroupModel> stream() {
    return SystemMDBService.db.collection('pharmaceuticalsGroups').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(PharmaceuticalGroupModel.fromMap(data));
        },
      ),
    );
  }

  Future<PharmaceuticalGroupModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('pharmaceuticalsGroups')
        .aggregate(pipeline);

    return PharmaceuticalGroupModel.fromMap(d);
  }

  static Future<PharmaceuticalGroupModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('pharmaceuticalsGroups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return PharmaceuticalGroupModel.fromMap(d);
  }

  static Future<PharmaceuticalGroupModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('pharmaceuticalsGroups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return PharmaceuticalGroupModel.fromMap(d);
  }

  static Future<PharmaceuticalGroupModel?> findByTitle(String title) async {
    var d = await SystemMDBService.db
        .collection('pharmaceuticalsGroups')
        .findOne(where.eq('title', title));
    if (d == null) {
      return null;
    }
    return PharmaceuticalGroupModel.fromMap(d);
  }

  Future<PharmaceuticalGroupModel?> edit() async {
    var r = await SystemMDBService.db.collection('pharmaceuticalsGroups').update(
           where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('pharmaceuticalsGroups').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('pharmaceuticalsGroups').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('pharmaceuticalsGroups').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
