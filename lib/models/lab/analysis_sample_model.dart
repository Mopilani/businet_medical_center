import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AnalysisSampleModel {
  AnalysisSampleModel._();

  AnalysisSampleModel(
    this.id, {
    required this.description,
  });

  late int id;
  late dynamic mid;
  late String description;

  static AnalysisSampleModel fromMap(Map<String, dynamic> data) {
    AnalysisSampleModel model = AnalysisSampleModel._();
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

  static AnalysisSampleModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<AnalysisSampleModel>> getAll() {
    List<AnalysisSampleModel> catgs = [];
    return SystemMDBService.db
        .collection('labAnalysisSamples')
        .find()
        .transform<AnalysisSampleModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(AnalysisSampleModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<AnalysisSampleModel> stream() {
    return SystemMDBService.db.collection('labAnalysisSamples').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(AnalysisSampleModel.fromMap(data));
        },
      ),
    );
  }

  Future<AnalysisSampleModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisSamples')
        .aggregate(pipeline);

    return AnalysisSampleModel.fromMap(d);
  }

  static Future<AnalysisSampleModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisSamples')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisSampleModel.fromMap(d);
  }

  static Future<AnalysisSampleModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('labAnalysisSamples')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisSampleModel.fromMap(d);
  }

  Future<AnalysisSampleModel?> edit() async {
    var r = await SystemMDBService.db.collection('labAnalysisSamples').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('labAnalysisSamples').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('labAnalysisSamples').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('labAnalysisSamples').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
