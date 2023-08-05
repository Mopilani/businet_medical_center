import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ExaminationPageSettingsModel {
  ExaminationPageSettingsModel._();

  ExaminationPageSettingsModel(
    this.id, {
    required this.description,
    required this.generalCheckSegmentSettings,
  });

  static ExaminationPageSettingsModel? _cache;

  static ExaminationPageSettingsModel? stored = _cache;

  late int id;
  late dynamic mid;
  late String description;
  Map<String, dynamic> generalCheckSegmentSettings = {};

  static Map<String, dynamic> defaultGeneralCheckSegmentSettings = {
    'keys': {
      'property1': 'Pulse',
      'property2': 'Temp',
      'property3': 'RR',
      'property4': 'B\\P',
      'property5': 'Sug',
      'property6': 'Weig',
      'property7': 'Heig',
      'property8': 'BMI',
      'property10': 'Complaint',
      'property11': 'History',
      'property12': 'Examination',
      'property13': 'Diagonsis',
      'property14': 'Comment',
    },
    'values': {
      'property1': '',
      'property2': '',
      'property3': '',
      'property4': '',
      'property5': '',
      'property6': '',
      'property7': '',
      'property8': '',
      'property10': '',
      'property11': '',
      'property12': '',
      'property13': '',
      'property14': '',
    }
  };

  static ExaminationPageSettingsModel fromMap(Map<String, dynamic> data) {
    ExaminationPageSettingsModel model = ExaminationPageSettingsModel._();
    model.id = data['id'];
    model.mid = data['_id']; // Mongo document id
    model.description = data['description'];
    model.generalCheckSegmentSettings = data['generalCheckSegmentSettings'];
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
        'generalCheckSegmentSettings': generalCheckSegmentSettings,
      };

  String toJson() => json.encode(toMap());

  static ExaminationPageSettingsModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<ExaminationPageSettingsModel>> getAll() {
    List<ExaminationPageSettingsModel> catgs = [];
    return SystemMDBService.db
        .collection('usersExaminationPageSettings')
        .find()
        .transform<ExaminationPageSettingsModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(ExaminationPageSettingsModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<ExaminationPageSettingsModel> stream() {
    return SystemMDBService.db
        .collection('usersExaminationPageSettings')
        .find()
        .transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(ExaminationPageSettingsModel.fromMap(data));
        },
      ),
    );
  }

  Future<ExaminationPageSettingsModel?> aggregate(
      List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('usersExaminationPageSettings')
        .aggregate(pipeline);

    return ExaminationPageSettingsModel.fromMap(d);
  }

  static Future<ExaminationPageSettingsModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('usersExaminationPageSettings')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    _cache = ExaminationPageSettingsModel.fromMap(d);
    return _cache;
  }

  static Future<ExaminationPageSettingsModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('usersExaminationPageSettings')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return ExaminationPageSettingsModel.fromMap(d);
  }

  Future<ExaminationPageSettingsModel?> edit() async {
    var r = await SystemMDBService.db
        .collection('usersExaminationPageSettings')
        .update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db
        .collection('usersExaminationPageSettings')
        .remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db
        .collection('usersExaminationPageSettings')
        .remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db
        .collection('usersExaminationPageSettings')
        .insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
