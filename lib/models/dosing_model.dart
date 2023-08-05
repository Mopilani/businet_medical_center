import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DoseModel {
  DoseModel._();

  DoseModel(
    this.id, {
    required this.description,
  });

  late int id;
  late dynamic mid;
  late String description;

  static DoseModel fromMap(Map<String, dynamic> data) {
    DoseModel model = DoseModel._();
    model.id = data['id'];
    model.mid = data['_id']; // Mongo document id
    model.description = data['description'];
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
      };

  String toJson() => json.encode(toMap());

  static DoseModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<DoseModel>> getAll() {
    List<DoseModel> catgs = [];
    return SystemMDBService.db
        .collection('dosing')
        .find()
        .transform<DoseModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(DoseModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<DoseModel> stream() {
    return SystemMDBService.db.collection('dosing').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(DoseModel.fromMap(data));
        },
      ),
    );
  }

  Future<DoseModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db.collection('dosing').aggregate(pipeline);

    return DoseModel.fromMap(d);
  }

  static Future<DoseModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('dosing')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return DoseModel.fromMap(d);
  }

  static Future<DoseModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('dosing')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return DoseModel.fromMap(d);
  }

  Future<DoseModel?> edit() async {
    var r = await SystemMDBService.db.collection('dosing').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('dosing').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('dosing').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('dosing').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
