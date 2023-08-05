import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/models/analysis_group_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AnalysisModel {
  AnalysisModel._();

  AnalysisModel(
    this.id, {
    required this.analysisGroup,
    required this.description,
    this.price = 0,
  });

  late int id;
  int price = 0;
  late dynamic mid;
  late AnalysisGroupModel analysisGroup;
  late String description;

  static AnalysisModel fromMap(Map<String, dynamic> data) {
    AnalysisModel model = AnalysisModel._();
    model.id = data['id'];
    model.mid = data['_id']; // Mongo document id
    model.price = data['price'] ?? 0;
    model.analysisGroup = AnalysisGroupModel.fromMap(data['analysisGroup']);
    model.description = data['description'];
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'analysisGroup': analysisGroup.toMap(),
        'description': description,
        'price': price,
      };

  String toJson() => json.encode(toMap());

  static AnalysisModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<AnalysisModel>> getAll() {
    List<AnalysisModel> catgs = [];
    return SystemMDBService.db
        .collection('analysises')
        .find()
        .transform<AnalysisModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(AnalysisModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<AnalysisModel> stream() {
    return SystemMDBService.db.collection('analysises').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(AnalysisModel.fromMap(data));
        },
      ),
    );
  }

  Future<AnalysisModel?> aggregate(List<dynamic> pipeline) async {
    var d =
        await SystemMDBService.db.collection('analysises').aggregate(pipeline);

    return AnalysisModel.fromMap(d);
  }

  static Future<AnalysisModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('analysises')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisModel.fromMap(d);
  }

  static Future<AnalysisModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('analysises')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisModel.fromMap(d);
  }

  Future<AnalysisModel?> edit() async {
    var r = await SystemMDBService.db.collection('analysises').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('analysises').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('analysises').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('analysises').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
