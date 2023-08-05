import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AnalysisSubGroupModel {
  AnalysisSubGroupModel._();

  AnalysisSubGroupModel(
    this.id, {
    required this.title,
  });

  late int id;
  late dynamic mid; // Mongo document id
  late String title;

  static AnalysisSubGroupModel fromMap(Map<String, dynamic> data) {
    AnalysisSubGroupModel model = AnalysisSubGroupModel._();
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

  static AnalysisSubGroupModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<AnalysisSubGroupModel>> getAll() {
    List<AnalysisSubGroupModel> catgs = [];
    return SystemMDBService.db
        .collection('labAnalysisSubGroups')
        .find()
        .transform<AnalysisSubGroupModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(AnalysisSubGroupModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<AnalysisSubGroupModel> stream() {
    return SystemMDBService.db.collection('labAnalysisSubGroups').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(AnalysisSubGroupModel.fromMap(data));
        },
      ),
    );
  }

  Future<AnalysisSubGroupModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisSubGroups')
        .aggregate(pipeline);

    return AnalysisSubGroupModel.fromMap(d);
  }

  static Future<AnalysisSubGroupModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisSubGroups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisSubGroupModel.fromMap(d);
  }

  static Future<AnalysisSubGroupModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisSubGroups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisSubGroupModel.fromMap(d);
  }

  static Future<AnalysisSubGroupModel?> findByTitle(String title) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisSubGroups')
        .findOne(where.eq('title', title));
    if (d == null) {
      return null;
    }
    return AnalysisSubGroupModel.fromMap(d);
  }

  Future<AnalysisSubGroupModel?> edit() async {
    var r = await SystemMDBService.db.collection('labAnalysisSubGroups').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('labAnalysisSubGroups').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('labAnalysisSubGroups').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('labAnalysisSubGroups').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
