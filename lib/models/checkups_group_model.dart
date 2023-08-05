import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class CheckupsGroupModel {
  CheckupsGroupModel._();

  CheckupsGroupModel(
    this.id, {
    required this.title,
  });

  late int id;
  late dynamic mid; // Mongo document id
  late String title;

  static CheckupsGroupModel fromMap(Map<String, dynamic> data) {
    CheckupsGroupModel model = CheckupsGroupModel._();
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

  static CheckupsGroupModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<CheckupsGroupModel>> getAll() {
    List<CheckupsGroupModel> catgs = [];
    return SystemMDBService.db
        .collection('checkupsGroups')
        .find()
        .transform<CheckupsGroupModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(CheckupsGroupModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<CheckupsGroupModel> stream() {
    return SystemMDBService.db.collection('checkupsGroups').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(CheckupsGroupModel.fromMap(data));
        },
      ),
    );
  }

  Future<CheckupsGroupModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('checkupsGroups')
        .aggregate(pipeline);

    return CheckupsGroupModel.fromMap(d);
  }

  static Future<CheckupsGroupModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('checkupsGroups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return CheckupsGroupModel.fromMap(d);
  }

  static Future<CheckupsGroupModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('checkupsGroups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return CheckupsGroupModel.fromMap(d);
  }

  static Future<CheckupsGroupModel?> findByTitle(String title) async {
    var d = await SystemMDBService.db
        .collection('checkupsGroups')
        .findOne(where.eq('title', title));
    if (d == null) {
      return null;
    }
    return CheckupsGroupModel.fromMap(d);
  }

  Future<CheckupsGroupModel?> edit() async {
    var r = await SystemMDBService.db.collection('checkupsGroups').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('checkupsGroups').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('checkupsGroups').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('checkupsGroups').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
