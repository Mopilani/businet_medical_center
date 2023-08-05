import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'analysis_model.dart';

class AnalysisResultModel {
  AnalysisResultModel._();

  AnalysisResultModel(
    this.id, {
    required this.analysis,
    required this.analysisDate,
    required this.defaultRange,
    required this.result,
  });

  late int id;
  late dynamic mid;
  late String defaultRange;
  late DateTime analysisDate;
  late AnalysisModel analysis;
  late String result;

  static AnalysisResultModel fromMap(Map<String, dynamic> data) {
    AnalysisResultModel model = AnalysisResultModel._();
    model.id = data['id'];
    model.mid = data['_id']; // Mongo document id
    model.analysis = AnalysisModel.fromMap(data['analysis']);
    model.defaultRange = data['defaultRange'];
    model.analysisDate = data['analysisDate'];
    model.result = data['result'];
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'analysis': analysis.toMap(),
        'defaultRange': defaultRange,
        'analysisDate': analysisDate,
        'result': result,
      };

  String toJson() => json.encode(toMap());

  static AnalysisResultModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<AnalysisResultModel>> getAll() {
    List<AnalysisResultModel> catgs = [];
    return SystemMDBService.db
        .collection('analysisResults')
        .find()
        .transform<AnalysisResultModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(AnalysisResultModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<AnalysisResultModel> stream() {
    return SystemMDBService.db.collection('analysisResults').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(AnalysisResultModel.fromMap(data));
        },
      ),
    );
  }

  Future<AnalysisResultModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('analysisResults')
        .aggregate(pipeline);

    return AnalysisResultModel.fromMap(d);
  }

  static Future<AnalysisResultModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('analysisResults')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisResultModel.fromMap(d);
  }

  static Future<AnalysisResultModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('analysisResults')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisResultModel.fromMap(d);
  }

  Future<AnalysisResultModel?> edit() async {
    var r = await SystemMDBService.db.collection('analysisResults').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('analysisResults').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('analysisResults').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('analysisResults').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
