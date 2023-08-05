import 'dart:async';
import 'dart:convert';

import 'package:businet_medical_center/models/user_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'money_account.dart';

enum MoneyActivityType {
  financingActivity,
  operationalActivity,
  investmentActivity,
}

MoneyActivityType moneyActivityTypeFromString(String typeStr) {
  switch (typeStr) {
    case 'TransactionType.financingActivity':
      return MoneyActivityType.financingActivity;
    case 'TransactionType.operationalActivity':
      return MoneyActivityType.operationalActivity;
    case 'TransactionType.investmentActivity':
      return MoneyActivityType.investmentActivity;
    default:
      throw 'Main Axis Alignment, Error Happend مقصودة';
  }
}

enum TransactionType {
  outcome,
  income,
}

TransactionType transTypeFromString(String typeStr) {
  switch (typeStr) {
    case 'TransactionType.income':
      return TransactionType.income;
    case 'TransactionType.outcome':
      return TransactionType.outcome;
    default:
      throw 'Main Axis Alignment, Error Happend مقصودة';
  }
}

Map<dynamic, String> transactionsTranslations = {
  TransactionType.income: 'دخل',
  'TransactionType.income': 'دخل',
  TransactionType.outcome: 'منصرف',
  'TransactionType.outcome': 'منصرف',
};

class TransactionModel {
  TransactionModel(
    this.id, {
    required this.value,
    required this.statement,
    required this.account,
    required this.type,
    required this.user,
    required this.time,
  });

  TransactionModel._();

  late int id;
  late double value;
  late String statement;
  late MoneyAccount account;
  late TransactionType type;
  late MoneyActivityType moneyActivity;
  late DateTime time;
  late UserModel user;

  static TransactionModel fromMap(Map<String, dynamic> data) {
    TransactionModel model = TransactionModel._();
    model.id = data['id'];
    model.value = data['value'];
    model.statement = data['statement'];
    model.account = MoneyAccount.fromMap(data['account']);
    model.user = UserModel.fromMap(data['user']);
    model.time = data['time'];
    model.type = transTypeFromString(data['type']);
    model.moneyActivity = moneyActivityTypeFromString(data['moneyActivity']);
    return model;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'value': value,
        'statement': statement,
        'time': time,
        'user': user,
        'account': account.toMap(),
        'type': type.toString(),
        'moneyActivity': moneyActivity.toString(),
      };

  String toJson() => json.encode(toMap());

  static TransactionModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<List<TransactionModel>> getAll() {
    List<TransactionModel> models = [];
    return SystemMDBService.db
        .collection('transactions')
        .find()
        .transform<TransactionModel>(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(TransactionModel.fromMap(data));
            },
          ),
        )
        .listen((model) {
          models.add(model);
        })
        .asFuture()
        .then((value) => models);
  }

  static Stream<TransactionModel>? stream() {
    return SystemMDBService.db.collection('transactions').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(TransactionModel.fromMap(data));
        },
      ),
    );
  }

  Future<TransactionModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db
        .collection('transactions')
        .aggregate(pipeline);

    return TransactionModel.fromMap(d);
  }

  Future<TransactionModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('transactions')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return TransactionModel.fromMap(d);
  }

  static Future<TransactionModel?> findById(int id) async {
    var d = await SystemMDBService.db
        .collection('transactions')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return TransactionModel.fromMap(d);
  }

  Future<TransactionModel?> edit() async {
    await SystemMDBService.db.collection('transactions').update(
          where.eq('id', id),
          toMap(),
        );

    return this;
  }

  Future<int> delete() async {
    await SystemMDBService.db.collection('transactions').remove(
          where.eq('id', id),
        );

    return 1;
  }

  Future<int> add() async {
    await SystemMDBService.db.collection('transactions').insert(
          toMap(),
        );

    return 1;
  }
}
