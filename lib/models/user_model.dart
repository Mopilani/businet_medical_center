import 'dart:async';
import 'dart:convert';


import 'package:businet_medical_center/models/action_model.dart';
import 'package:businet_medical_center/utils/system_cache.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'access_level_model.dart';

class UserModel {
  UserModel(
    this.id, {
    // required this.levelNumber,
    required this.username,
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    required this.accessLevelModel,
  });

  int id;
  // late int levelNumber;
  late String username;
  late String password;
  late String firstname;
  late String lastname;
  late String phoneNumber;
  AccessLevelModel? accessLevelModel;

  static UserModel? get stored => SystemCache.get('user');

  void setUser(UserModel user) => SystemCache.set('user', user);
  static void _setUser(UserModel? user) => SystemCache.set('user', user);

  static void _deleteUser() => SystemCache.remove('user');

  static UserModel fromMap(Map<String, dynamic> data) {
    UserModel user = UserModel(
      data['id'],
      // levelNumber: data['levelNumber'],
      username: data['username'],
      password: data['password'],
      firstname: data['firstname'],
      lastname: data['lastname'],
      phoneNumber: data['phoneNumber'],
      accessLevelModel: data['accessLevelModel'] != null
          ? AccessLevelModel.fromMap(data['accessLevelModel'])
          : null,
    );
    return user;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'password': password,
        'firstname': firstname,
        'lastname': lastname,
        'phoneNumber': phoneNumber,
        // 'levelNumber': levelNumber,
        'accessLevelModel': accessLevelModel?.toMap(),
      };

  String toJson() => json.encode(toMap());

  static UserModel fromJson(String jsn) {
    return fromMap(json.decode(jsn));
  }

  static Future<void> signout() async {
    // UserModel? user = UserModel.stored;
    await ActionModel.signout();
    _deleteUser();
  }

  static Future<UserModel?> signin(String username, String password) async {
    var r = await findByUsername(username);

    if (r?.password == password) {
      _setUser(r!);
      await ActionModel.signin();
      return r;
    }
    return null;
  }

  static Future<bool> checkPasswordForUser(
      String username, String password) async {
    var r = await findByUsername(username);

    if (r?.password == password) {
      return true;
    }
    return false;
  }

  // Future<UserModel?> signup() async {
  //   var r = await findByUsername(username);
  //   if (r?.username == username) {
  //     print('Username Was Exists');
  //   } else {
  //     var newUser = await add(); // Must be add for later
  //     // _setUser(newUser);
  //     return newUser;
  //   }
  //   return null;
  // }

  static Stream<UserModel> stream() {
    return SystemMDBService.db.collection('users').find().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(UserModel.fromMap(data));
        },
      ),
    );
  }

  Future<UserModel?> aggregate(List<dynamic> pipeline) async {
    var d = await SystemMDBService.db.collection('users').aggregate(pipeline);

    return UserModel.fromMap(d);
  }

  static Future<UserModel?> get(int id) async {
    var d = await SystemMDBService.db
        .collection('users')
        .findOne(where.eq('id', id));
    if (d == null) {
      return null;
    }
    return UserModel.fromMap(d);
  }

  static Future<UserModel?> findByUsername(String username) async {
    var r = await SystemMDBService.db
        .collection('users')
        .findOne(where.eq('username', username));
    // var s = SystemMDBService.db.collection('users').find();
    // print(await s.first);
    // print(r);
    if (r == null) {
      return null;
    }
    return UserModel.fromMap(r);
  }

  Future<UserModel?> edit() async {
    var r = await SystemMDBService.db.collection('users').update(
          where.eq('id', id),
          toMap(),
        );
    // print('User Update: $r');
    return this;
  }

  Future<int> delete(int id) async {
    var r = await SystemMDBService.db.collection('users').remove(
          where.eq('id', id),
        );
    print(r);
    return 1;
  }

  Future<UserModel> add() async {
    var r = await SystemMDBService.db.collection('users').insert(
          toMap(),
        );
    print(r);
    // toast(r['ok'].toString()jyhf);
    return this;
    //   toast(r['ok']);
    // if (r['ok'] == '1.0') {
    // } else {
    // }
  }
}
