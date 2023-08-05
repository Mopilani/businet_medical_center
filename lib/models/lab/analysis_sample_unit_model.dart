import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AnalysisSampleUnitModel {
  AnalysisSampleUnitModel._();

  AnalysisSampleUnitModel(
    this.id, {
    required this.description,
  });

  late int id;
  late dynamic mid;
  late String description;

  static AnalysisSampleUnitModel fromMap(Map<String, dynamic> data) {
    AnalysisSampleUnitModel model = AnalysisSampleUnitModel._();
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

  static AnalysisSampleUnitModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<AnalysisSampleUnitModel>> getAll() {
    List<AnalysisSampleUnitModel> catgs = [];
    return SystemMDBService.db
        .collection('labAnalysisUnitSamples')
        .find()
        .transform<AnalysisSampleUnitModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(AnalysisSampleUnitModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<AnalysisSampleUnitModel> stream() {
    return SystemMDBService.db.collection('labAnalysisUnitSamples').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(AnalysisSampleUnitModel.fromMap(data));
        },
      ),
    );
  }

  Future<AnalysisSampleUnitModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisUnitSamples')
        .aggregate(pipeline);

    return AnalysisSampleUnitModel.fromMap(d);
  }

  static Future<AnalysisSampleUnitModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisUnitSamples')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisSampleUnitModel.fromMap(d);
  }

  static Future<AnalysisSampleUnitModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisUnitSamples')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisSampleUnitModel.fromMap(d);
  }

  Future<AnalysisSampleUnitModel?> edit() async {
    var r = await SystemMDBService.db.collection('labAnalysisUnitSamples').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('labAnalysisUnitSamples').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('labAnalysisUnitSamples').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('labAnalysisUnitSamples').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
