import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AnalysisGroupModel {
  AnalysisGroupModel._();

  AnalysisGroupModel(
    this.id, {
    required this.title,
  });

  late int id;
  late dynamic mid; // Mongo document id
  late String title;

  static AnalysisGroupModel fromMap(Map<String, dynamic> data) {
    AnalysisGroupModel model = AnalysisGroupModel._();
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

  static AnalysisGroupModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<AnalysisGroupModel>> getAll() {
    List<AnalysisGroupModel> catgs = [];
    return SystemMDBService.db
        .collection('analysisGroups')
        .find()
        .transform<AnalysisGroupModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(AnalysisGroupModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<AnalysisGroupModel> stream() {
    return SystemMDBService.db.collection('analysisGroups').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(AnalysisGroupModel.fromMap(data));
        },
      ),
    );
  }

  Future<AnalysisGroupModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('analysisGroups')
        .aggregate(pipeline);

    return AnalysisGroupModel.fromMap(d);
  }

  static Future<AnalysisGroupModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('analysisGroups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisGroupModel.fromMap(d);
  }

  static Future<AnalysisGroupModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('analysisGroups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisGroupModel.fromMap(d);
  }

  static Future<AnalysisGroupModel?> findByTitle(String title) async {
    var d = await SystemMDBService.db
        .collection('analysisGroups')
        .findOne(where.eq('title', title));
    if (d == null) {
      return null;
    }
    return AnalysisGroupModel.fromMap(d);
  }

  Future<AnalysisGroupModel?> edit() async {
    var r = await SystemMDBService.db.collection('analysisGroups').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('analysisGroups').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('analysisGroups').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('analysisGroups').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
