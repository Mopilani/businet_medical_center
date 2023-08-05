import 'package:businet_medical_center/models/access_level_model.dart';
import 'package:businet_medical_center/models/navigator_model.dart';
import 'package:businet_medical_center/models/processes_model.dart';
import 'package:businet_medical_center/models/system_config.dart';
import 'package:businet_medical_center/models/user_model.dart';
import 'package:businet_medical_center/views/users_views/users_control.dart';
import 'package:businet_medical_center/views/users_views/users_view.dart';

import 'models/point_of_sale_model.dart';

Future<void> initialData() async {
  // await SystemMDBService.db.collection('users').drop();
  // await SystemMDBService.db.collection('accessLevels').drop();
  PointOfSaleModel(
    0,
    area: 'امدرمان',
    placeName: 'مركز المستقبل الطبي',
    country: 'السودان',
    managerPhoneNumber: '0113615012',
    number: 0113615012,
    state: 'الخرطوم',
    town: 'الخرطوم',
    deviceName: 'عند بككا دسكتوب',
  );
  // await UserModel(
  //   0,
  //   username: '12',
  //   password: '12',
  //   firstname: 'الدعم',
  //   lastname: 'الفني',
  //   phoneNumber: '0113615012',
  //   accessLevelModel: null,
  // ).add();

  // await UserModel(
  //   0,
  //   username: '66',
  //   password: '3',
  //   firstname: 'الادارة',
  //   lastname: '',
  //   phoneNumber: '0113615012',
  //   accessLevelModel: null,
  // ).add();
  await PointOfSaleModel.init();
  if (SystemConfig().firstStart) {
    ProcessesModel(
      0,
      businessDay: DateTime.now(),
      currentDaty: DateTime.now(),
    ).add();
  }
  await ProcessesModel.get(0); // Initialization for the stored model

  if (false || SystemConfig().firstStart) {
    print('First Start');

    /// Access Levels
    await AccessLevelModel(
      0,
      accessToken: 'Support',
      levelDescription: 'For Support Team',
      levelNumber: 0,
      nodeId: 1,
      allowedLevels: {},
    ).add();

    await AccessLevelModel(
      4,
      accessToken: 'MNGMNGMNG',
      levelDescription: 'Manager',
      levelNumber: 1,
      nodeId: 1,
      allowedLevels: {},
    ).edit();

    await AccessLevelModel(
      2,
      accessToken: 'CASHTHATILOVE',
      levelDescription: 'Cashier',
      levelNumber: 2,
      nodeId: 1,
      allowedLevels: {},
    ).add();

    await AccessLevelModel(
      3,
      accessToken: 'ASSISSTANT',
      levelDescription: 'Assistant',
      levelNumber: 3,
      nodeId: 1,
      allowedLevels: {},
    ).add();

    /// Users
    await UserModel(
      0,
      username: '12',
      password: '12',
      firstname: 'الدعم الفني',
      lastname: 'Support',
      phoneNumber: '+249113615012',
      accessLevelModel: await AccessLevelModel.get(0),
    ).add();

    await UserModel(
      1,
      username: '66',
      password: '3',
      firstname: 'الادارة',
      lastname: '',
      phoneNumber: '',
      accessLevelModel: await AccessLevelModel.get(1),
    ).add();

    await UserModel.signin('12', '12');

    var registeredUser = SysNav.registerRoutesForUser(UserModel.stored!, [
      UsersView,
      UsersControle,
    ]);
    await registeredUser.edit();
  } else {
    await UserModel.signin('12', '12');
  }
}
