import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/models/reservation_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';


enum AgeUnitType {
  year,
  month,
  day,
}

AgeUnitType ageUnitTypeFromString(String value) {
  switch (value) {
    case 'AgeUnitType.day':
      return AgeUnitType.day;

    case 'AgeUnitType.year':
      return AgeUnitType.year;

    case 'AgeUnitType.month':
      return AgeUnitType.month;

    default:
      throw 'Unkown value $value';
  }
}

enum Gender {
  male,
  female,
}

Gender genderTypeFromString(String value) {
  switch (value) {
    case 'Gender.male':
      return Gender.male;

    case 'Gender.female':
      return Gender.female;

    default:
      throw 'Unkown value $value';
  }
}

class PatientModel {
  PatientModel._();

  PatientModel(
    this.id, {
    required this.name,
    required this.phone,
  });

  late int id;
  late String name;
  late String phone;
  List<ReservationModel> reservations = [];

  static PatientModel fromMap(Map<String, dynamic> data) {
    PatientModel model = PatientModel._();
    model.id = data['id'];
    model.name = data['name'];
    model.phone = data['phone'];
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
      };

  String toJson() => json.encode(toMap());

  static PatientModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<PatientModel>> getAll() {
    List<PatientModel> catgs = [];
    return SystemMDBService.db
        .collection('patients')
        .find()
        .transform<PatientModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(PatientModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<PatientModel> stream() {
    return SystemMDBService.db.collection('patients').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(PatientModel.fromMap(data));
        },
      ),
    );
  }

  Future<PatientModel?> aggregate(List<dynamic> pipeline) async {
    var d =
        await SystemMDBService.db.collection('patients').aggregate(pipeline);

    return PatientModel.fromMap(d);
  }

  static Future<PatientModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('patients')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return PatientModel.fromMap(d);
  }

  static Future<PatientModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('patients')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return PatientModel.fromMap(d);
  }

  static Stream<PatientModel> findByName(String name) {
    return SystemMDBService.db
        .collection('patients')
        .find(
          where.match('name', name),
        )
        .transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(PatientModel.fromMap(data));
        },
      ),
    );
  }

  Future<PatientModel?> edit() async {
    var r = await SystemMDBService.db.collection('patients').update(
          where.eq('id', id),
          toMap(),
        );
    print(r);
    return this;
  }

  Future<int> delete() async {
    var r = await SystemMDBService.db.collection('patients').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('patients').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
