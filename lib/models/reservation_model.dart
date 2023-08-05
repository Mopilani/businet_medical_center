import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/models/checkups_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'analysis_model.dart';
import 'analysis_result_model.dart';
import 'instruction_model.dart';
import 'medical_service_model.dart';
import 'patient_model.dart';
import 'pharmaceutical_model.dart';
import 'receipt_and_bill_payment_method_entry_model.dart';

class ReservationModel {
  ReservationModel._();

  ReservationModel(
    this.id, {
    required this.patientId,
    required this.patientDialyId,
    required this.patientName,
    required this.patientphone,
    required this.hasBeenChecked,
    required this.total,
    required this.wanted,
    required this.payed,
    required this.realPayed,
    required this.debitWanted,
    required this.age,
    required this.ageUnitType,
    required this.dateTime,
    required this.gender,
    required this.note,
    required this.serviceType,
    this.generalCheckSegmentSettings,
    this.wantedAnalysis,
    this.wantedCheckups,
    this.wantedPharmaceuticals,
    this.instructions,
    this.analysisResults,
    this.documentsFiles,
    this.receiptPaymentMethods,
  });

  late int id;
  late int dialyNumber;
  late int patientId;
  late int patientDialyId;
  late String patientName;
  late String patientphone;
  late String note;
  late Gender gender;
  late double total;
  late double realPayed;
  late double debitWanted;
  late MedicalServiceModel serviceType;
  late AgeUnitType ageUnitType;
  late DateTime dateTime;
  late double payed;
  late double wanted;
  late int age;
  late bool hasBeenChecked;
  List<ReceiptPaymentMethodEntryModel>? receiptPaymentMethods;
  Map<String, dynamic>? generalCheckSegmentSettings = {};
  List<AnalysisModel>? wantedAnalysis;
  List<CheckOrgan>? wantedCheckups;
  List<Treatment>? wantedPharmaceuticals = [];
  List<InstructionModel>? instructions = [];
  List<AnalysisResultModel>? analysisResults = [];
  List<String>? documentsFiles = [];

  copyWith(
    id, {
    patientId,
    patientDialyId,
    patientName,
    patientphone,
    hasBeenChecked,
    total,
    wanted,
    payed,
    realPayed,
    debitWanted,
    age,
    ageUnitType,
    dateTime,
    gender,
    note,
    serviceType,
    generalCheckSegmentSettings,
    wantedAnalysis,
    wantedCheckups,
    wantedPharmaceuticals,
    instructions,
    analysisResults,
    documentsFiles,
    receiptPaymentMethods,
  }) {
    ReservationModel model = ReservationModel._();
    model.id = id ?? this.id;
    model.patientId = patientId ?? this.patientId;
    model.patientDialyId = patientDialyId ?? this.patientDialyId;
    model.patientName = patientName ?? this.patientName;
    model.patientphone = patientphone ?? this.patientphone;
    model.hasBeenChecked = hasBeenChecked ?? this.hasBeenChecked;
    model.total = total ?? this.total;
    model.wanted = wanted ?? this.wanted;
    model.payed = payed ?? this.payed;
    model.realPayed = realPayed ?? this.realPayed;
    model.debitWanted = debitWanted ?? this.debitWanted;
    model.age = age ?? this.age;
    model.ageUnitType = ageUnitType ?? this.ageUnitType;
    model.dateTime = dateTime ?? this.dateTime;
    model.gender = gender ?? this.gender;
    model.note = note ?? this.note;
    model.serviceType = serviceType ?? this.serviceType;
    model.generalCheckSegmentSettings =
        generalCheckSegmentSettings ?? this.generalCheckSegmentSettings;
    model.wantedAnalysis = wantedAnalysis ?? this.wantedAnalysis;
    model.wantedCheckups = wantedCheckups ?? this.wantedCheckups;
    model.wantedPharmaceuticals =
        wantedPharmaceuticals ?? this.wantedPharmaceuticals;
    model.instructions = instructions ?? this.instructions;
    model.analysisResults = analysisResults ?? this.analysisResults;
    model.documentsFiles = documentsFiles ?? this.documentsFiles;
    model.receiptPaymentMethods =
        receiptPaymentMethods ?? this.receiptPaymentMethods;
  }

  static ReservationModel fromMap(Map<String, dynamic> data) {
    ReservationModel model = ReservationModel._();
    model.id = data['id'];
    model.patientId = data['patientId'];
    model.patientDialyId = data['patientDialyId'];
    model.patientName = data['patientName'];
    model.patientphone = data['patientphone'];
    model.serviceType = MedicalServiceModel.fromMap(data['serviceType']);
    model.ageUnitType = ageUnitTypeFromString(data['ageUnitType']);
    model.dateTime = data['dateTime'];
    model.hasBeenChecked = data['hasBeenChecked'];
    model.total = data['total'];
    model.payed = data['payed'];
    model.wanted = data['wanted'];
    model.realPayed = data['realPayed'];
    model.debitWanted = data['debitWanted'];
    model.age = data['age'];
    model.note = data['note'];
    model.gender = genderTypeFromString(data['gender']);
    model.generalCheckSegmentSettings = (data['generalCheckSegmentSettings']);
    model.receiptPaymentMethods = data['receiptPaymentMethods'] == null
        ? null
        : (data['receiptPaymentMethods'])
            .map<ReceiptPaymentMethodEntryModel>(
              (element) => ReceiptPaymentMethodEntryModel.fromMap(element),
            )
            .toList();
    model.wantedAnalysis = data['wantedAnalysis'] == null
        ? null
        : <AnalysisModel>[
            ...(data['wantedAnalysis'])
                .map(
                  (e) => AnalysisModel.fromMap(e),
                )
                .toList()
          ];
    model.wantedCheckups = data['wantedCheckups'] == null
        ? null
        : <CheckOrgan>[
            ...(data['wantedCheckups'])
                .map(
                  (e) => CheckOrgan.fromMap(e),
                )
                .toList()
          ];
    // (data['wantedCheckups']);
    model.wantedPharmaceuticals = data['wantedPharmaceuticals'] == null
        ? null
        : <Treatment>[
            ...(data['wantedPharmaceuticals'])
                .map(
                  (e) => Treatment.fromMap(e),
                )
                .toList()
          ];
    // (data['wantedPharmaceuticals']);
    model.instructions = data['instructions'] == null
        ? null
        : <InstructionModel>[
            ...(data['instructions'])
                .map(
                  (e) => InstructionModel.fromMap(e),
                )
                .toList()
          ];
    // (data['instructions']);
    model.analysisResults = data['analysisResults'] == null
        ? null
        : <AnalysisResultModel>[
            ...(data['analysisResults'])
                .map(
                  (e) => AnalysisResultModel.fromMap(e),
                )
                .toList()
          ];
    // (data['analysisResults']);
    model.documentsFiles = data['documentsFiles'] == null
        ? null
        : <String>[...(data['documentsFiles'])];
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'patientId': patientId,
        'patientDialyId': patientDialyId,
        'patientphone': patientphone,
        'patientName': patientName,
        'age': age,
        'note': note,
        'total': total,
        'payed': payed,
        'wanted': wanted,
        'realPayed': realPayed,
        'debitWanted': debitWanted,
        'gender': gender.toString(),
        'dateTime': dateTime,
        'serviceType': serviceType.toMap(),
        'ageUnitType': ageUnitType.toString(),
        'hasBeenChecked': hasBeenChecked,
        'generalCheckSegmentSettings': generalCheckSegmentSettings,
        'receiptPaymentMethods': receiptPaymentMethods
            ?.map<Map<String, dynamic>>((e) => e.toMap())
            .toList(),
        'wantedAnalysis': wantedAnalysis?.map((e) => e.toMap()).toList(),
        'wantedCheckups': wantedCheckups?.map((e) => e.toMap()).toList(),
        'wantedPharmaceuticals':
            wantedPharmaceuticals?.map((e) => e.toMap()).toList(),
        'instructions': instructions?.map((e) => e.toMap()).toList(),
        'analysisResults': analysisResults?.map((e) => e.toMap()).toList(),
        'documentsFiles': documentsFiles,
      };

  String toJson() => json.encode(toMap());

  static ReservationModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<ReservationModel>> getAll() {
    List<ReservationModel> catgs = [];
    return SystemMDBService.db
        .collection('reservations')
        .find()
        .transform<ReservationModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(ReservationModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<ReservationModel> stream() {
    return SystemMDBService.db.collection('reservations').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(ReservationModel.fromMap(data));
        },
      ),
    );
  }

  static Stream<ReservationModel> collectOfTime(
    DateTime from,
    DateTime to, [
    bool withTime = false,
  ]) {
    var modelsStream = stream();
    var musfaStream = modelsStream.transform<ReservationModel>(
        StreamTransformer.fromHandlers(handleData: (model, sink) {
      int r1;
      int r2;
      if (withTime) {
        r1 = model.dateTime.compareTo(from);
        r2 = model.dateTime.compareTo(to);
      } else {
        DateTime createDate = DateTime(
          model.dateTime.year,
          model.dateTime.month,
          model.dateTime.day,
        );
        r1 = createDate.compareTo(DateTime(
          from.year,
          from.month,
          from.day,
        ));
        r2 = createDate.compareTo(DateTime(
          to.year,
          to.month,
          to.day,
        ));
      }
      // print('${model.createDate} ${r1 == 1} && ${r2 == 1}');
      if ((r1 == 1 && r2 == -1) || (r1 == 0 && r2 == 0)) {
        return;
      }
      sink.add(model);
    }));
    return musfaStream;
  }

  Future<ReservationModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('reservations')
        .aggregate(pipeline);

    return ReservationModel.fromMap(d);
  }

  static Future<ReservationModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('reservations')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return ReservationModel.fromMap(d);
  }

  static Future<ReservationModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('reservations')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return ReservationModel.fromMap(d);
  }

  Future<ReservationModel?> edit() async {
    var r = await SystemMDBService.db.collection('reservations').update(
          where.eq('id', id),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('reservations').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('reservations').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}
