import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';


class PaymentMethodModel {
  PaymentMethodModel._();
  PaymentMethodModel(
    this.id, {
    required this.methodName,
    required this.currency,
    required this.postPayMethod,
    this.tax,
  });
  late int id;
  late String methodName;
  late String currency;
  late bool postPayMethod;
  double? tax;

  static PaymentMethodModel fromMap(Map<String, dynamic> data) {
    PaymentMethodModel model = PaymentMethodModel._();
    model.id = data['id'];
    model.methodName = data['methodName'];
    model.currency = data['currency'] ?? 'ج.س';
    model.postPayMethod = data['postPayMethod'] ?? false;
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'methodName': methodName,
        'currency': currency,
        'postPayMethod': postPayMethod,
      };

  String toJson() => json.encode(toMap());

  static PaymentMethodModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<PaymentMethodModel>> getAll() {
    List<PaymentMethodModel> catgs = [];
    return SystemMDBService.db
        .collection('PayMethods')
        .find()
        .transform<PaymentMethodModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(PaymentMethodModel.fromMap(data));
            },
          ),
        )
        .listen((subCatg) {
          catgs.add(subCatg);
        })
        .asFuture()
        .then((value) => catgs);
  }

  static Stream<PaymentMethodModel>? stream() {
    return SystemMDBService.db.collection('PayMethods').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(PaymentMethodModel.fromMap(data));
        },
      ),
    );
  }

  Future<PaymentMethodModel?> aggregate(List<dynamic> pipeline) async {
    var d =
        await SystemMDBService.db.collection('PayMethods').aggregate(pipeline);

    return PaymentMethodModel.fromMap(d);
  }

  static Future<PaymentMethodModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('PayMethods')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return PaymentMethodModel.fromMap(d);
  }

  Future<PaymentMethodModel?> findByName(String name, String id) async {
    var d = await SystemMDBService.db
        .collection('PayMethods')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return PaymentMethodModel.fromMap(d);
  }

  Future<PaymentMethodModel?> edit() async {
    var r = await SystemMDBService.db.collection('PayMethods').update(
          where.eq('id', id),
          toMap(),
        );
    print(r);
    return this;
  }

  Future<int> delete(String id) async {
    var r = await SystemMDBService.db.collection('PayMethods').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<int> add() async {
    var r = await SystemMDBService.db.collection('PayMethods').insert(
          toMap(),
        );
    print(r);
    return 1;
  }
}

class Currency {
  static const String sudanesePound = 'ج.س';
  static const String usDollar = 'USD';
}
