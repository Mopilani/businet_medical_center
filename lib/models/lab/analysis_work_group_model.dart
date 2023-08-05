import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AnalysisWorkGroupModel {
  AnalysisWorkGroupModel._();

  AnalysisWorkGroupModel(
    this.id, {
    required this.title,
  });

  late int id;
  late dynamic mid; // Mongo document id
  late String title;

  static AnalysisWorkGroupModel fromMap(Map<String, dynamic> data) {
    AnalysisWorkGroupModel model = AnalysisWorkGroupModel._();
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

  static AnalysisWorkGroupModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<AnalysisWorkGroupModel>> getAll() {
    List<AnalysisWorkGroupModel> catgs = [];
    return SystemMDBService.db
        .collection('labAnalysisWorkGroups')
        .find()
        .transform<AnalysisWorkGroupModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(AnalysisWorkGroupModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<AnalysisWorkGroupModel> stream() {
    return SystemMDBService.db.collection('labAnalysisWorkGroups').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(AnalysisWorkGroupModel.fromMap(data));
        },
      ),
    );
  }

  Future<AnalysisWorkGroupModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisWorkGroups')
        .aggregate(pipeline);

    return AnalysisWorkGroupModel.fromMap(d);
  }

  static Future<AnalysisWorkGroupModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisWorkGroups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisWorkGroupModel.fromMap(d);
  }

  static Future<AnalysisWorkGroupModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisWorkGroups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisWorkGroupModel.fromMap(d);
  }

  static Future<AnalysisWorkGroupModel?> findByTitle(String title) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisWorkGroups')
        .findOne(where.eq('title', title));
    if (d == null) {
      return null;
    }
    return AnalysisWorkGroupModel.fromMap(d);
  }

  Future<AnalysisWorkGroupModel?> edit() async {
    var r = await SystemMDBService.db.collection('labAnalysisWorkGroups').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('labAnalysisWorkGroups').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('labAnalysisWorkGroups').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('labAnalysisWorkGroups').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
