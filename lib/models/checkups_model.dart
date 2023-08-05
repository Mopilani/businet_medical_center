import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'checkups_group_model.dart';
import 'organ_model.dart';

class CheckupsModel {
  CheckupsModel._();

  CheckupsModel(
    this.id, {
    required this.analysisGroup,
    required this.description,
    this.price = 0,
  });

  late int id;
  int price = 0;
  late dynamic mid;
  late CheckupsGroupModel analysisGroup;
  late String description;

  static CheckupsModel fromMap(Map<String, dynamic> data) {
    CheckupsModel model = CheckupsModel._();
    model.id = data['id'];
    model.mid = data['_id']; // Mongo document id
    model.price = data['price'] ?? 0;
    model.analysisGroup = CheckupsGroupModel.fromMap(data['analysisGroup']);
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

  static CheckupsModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<CheckupsModel>> getAll() {
    List<CheckupsModel> catgs = [];
    return SystemMDBService.db
        .collection('checkups')
        .find()
        .transform<CheckupsModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(CheckupsModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<CheckupsModel> stream() {
    return SystemMDBService.db.collection('checkups').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(CheckupsModel.fromMap(data));
        },
      ),
    );
  }

  Future<CheckupsModel?> aggregate(List<dynamic> pipeline) async {
    var d =
        await SystemMDBService.db.collection('checkups').aggregate(pipeline);

    return CheckupsModel.fromMap(d);
  }

  static Future<CheckupsModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('checkups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return CheckupsModel.fromMap(d);
  }

  static Future<CheckupsModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('checkups')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return CheckupsModel.fromMap(d);
  }

  Future<CheckupsModel?> edit() async {
    var r = await SystemMDBService.db.collection('checkups').update(
          where.eq('_id', mid),
          toMap(),
        );
    print(r);
    return this;
  }

  static Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('checkups').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> deleteWithMID() async {
    print(mid);
    var r = await SystemMDBService.db.collection('checkups').remove(
          where.eq('_id', mid),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('checkups').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}

class CheckOrgan {
  CheckOrgan(this.organ, this.checkup);
  OrganModel organ;
  CheckupsModel checkup;

 static  CheckOrgan fromMap(Map<String, dynamic> data) {
    return CheckOrgan(OrganModel.fromMap(data['organ']), CheckupsModel.fromMap(data['checkup']));
  }

Map<String, dynamic>  toMap() => {
        'organ': organ.toMap(),
        'checkup': checkup.toMap(),
      };
}
