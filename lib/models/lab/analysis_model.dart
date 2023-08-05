import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/models/instruction_model.dart';
import 'package:businet_medical_center/models/lab/analysis_group_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'analysis_sample_model.dart';
import 'analysis_sample_unit_model.dart';
import 'analysis_sub_group_model.dart';
import 'analysis_work_group_model.dart';
import 'external_lab_model.dart';

class AnalysisModel {
  AnalysisModel._();

  AnalysisModel(
    this.id, {
    required this.description,
  });

  late int id;
  late dynamic mid;
  late AnalysisGroupModel analysisGroup;
  late AnalysisSubGroupModel analysisSubGroup;
  late AnalysisWorkGroupModel analysisWorkGroup;
  late AnalysisSampleModel analysisSample;
  late String description;
  late double price;
  late double labToLabPrice;
  late double externalLabPrice;
  late int receiptDate;
  late String? barcode;
  late String refForMale;
  late String refForFemale;
  late bool sentToOtherLab;
  late ExternalLabModel? externalLab;
  late InstructionModel? instruction;
  late AnalysisSampleUnitModel analysisSampleUnit;
  late double femaleRefLowLimit;
  late double femaleRefHighLimit;
  late double maleRefLowLimit;
  late double maleRefHighLimit;

  static AnalysisModel fromMap(Map<String, dynamic> data) {
    AnalysisModel model = AnalysisModel._();
    model.id = data['id'];
    model.mid = data['_id']; // Mongo document id
    model.description = data['description'];
    model.price = data['price'];
    model.labToLabPrice = data['labToLabPrice'];
    model.externalLabPrice = data['externalLabPrice'];
    model.barcode = data['barcode'];
    model.receiptDate = data['receiptDate'];
    model.refForMale = data['refForMale'];
    model.refForFemale = data['refForFemale'];
    model.sentToOtherLab = data['sentToOtherLab'];
    model.instruction = data['instruction'] == null
        ? null
        : InstructionModel.fromMap(data['instruction']);
    model.femaleRefLowLimit = data['femaleRefLowLimit'];
    model.femaleRefHighLimit = data['femaleRefHighLimit'];
    model.maleRefLowLimit = data['maleRefLowLimit'];
    model.maleRefHighLimit = data['maleRefHighLimit'];
    model.analysisGroup = AnalysisGroupModel.fromMap(data['analysisGroup']);
    model.analysisSubGroup =
        AnalysisSubGroupModel.fromMap(data['analysisSubGroup']);
    model.analysisWorkGroup =
        AnalysisWorkGroupModel.fromMap(data['analysisWorkGroup']);
    model.analysisSample = AnalysisSampleModel.fromMap(data['analysisSample']);
    model.externalLab = data['externalLab'] == null
        ? null
        : ExternalLabModel.fromMap(data['externalLab']);
    model.analysisSampleUnit =
        AnalysisSampleUnitModel.fromMap(data['analysisSampleUnit']);
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'analysisGroup': analysisGroup.toMap(),
        'analysisSubGroup': analysisSubGroup.toMap(),
        'analysisWorkGroup': analysisWorkGroup.toMap(),
        'analysisSample': analysisSample.toMap(),
        'externalLab': externalLab?.toMap(),
        'instruction': instruction?.toMap(),
        'analysisSampleUnit': analysisSampleUnit.toMap(),
        'labToLabPrice': labToLabPrice,
        'externalLabPrice': externalLabPrice,
        'description': description,
        'receiptDate': receiptDate,
        'price': price,
        'barcode': barcode,
        'refForMale': refForMale,
        'refForFemale': refForFemale,
        'sentToOtherLab': sentToOtherLab,
        'femaleRefLowLimit': femaleRefLowLimit,
        'femaleRefHighLimit': femaleRefHighLimit,
        'maleRefHighLimit': maleRefHighLimit,
        'maleRefLowLimit': maleRefLowLimit,
      };

  String toJson() => json.encode(toMap());

  static AnalysisModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<AnalysisModel>> getAll() {
    List<AnalysisModel> catgs = [];
    return SystemMDBService.db
        .collection('labAnalysises')
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
    return SystemMDBService.db.collection('labAnalysises').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(AnalysisModel.fromMap(data));
        },
      ),
    );
  }

  Future<AnalysisModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('labAnalysises')
        .aggregate(pipeline);

    return AnalysisModel.fromMap(d);
  }

  static Future<AnalysisModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('labAnalysises')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisModel.fromMap(d);
  }

  static Future<AnalysisModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('labAnalysises')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return AnalysisModel.fromMap(d);
  }

  Future<AnalysisModel?> edit() async {
    var r = await SystemMDBService.db.collection('labAnalysises').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('labAnalysises').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('labAnalysises').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('labAnalysises').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
