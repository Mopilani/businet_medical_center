
import 'package:businet_medical_center/utils/check_funcs.dart';
import 'package:businet_medical_center/utils/get_x.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:mongo_dart/mongo_dart.dart';

SystemConfig? _runtimeStoredInstance;

class InterfaceType {
  static const String administration = 'administration';
  static const String reception = 'reception';
  static const String pharmacy = 'pharmacy';
  static const String lab = 'lab';
}

class SystemConfig {
  factory SystemConfig() {
    if (_runtimeStoredInstance == null) {
      _runtimeStoredInstance = SystemConfig.init();
      return _runtimeStoredInstance!;
    }
    return _runtimeStoredInstance!;
  }

  SystemConfig.init([SystemConfig? $with]) {
    if ($with != null) {
      id = $with.id;
      printer = $with.printer;
      theme = $with.theme;
      invoicesSaveDirectoryPath = $with.invoicesSaveDirectoryPath;
      pageRoute = $with.pageRoute;
      animations = $with.animations;
      salesType = $with.salesType;
      firstStart = $with.firstStart;
    }
  }

  static Map<String, dynamic> systemConfig = <String, dynamic>{};

  static SystemConfig? stored = _runtimeStoredInstance;

  int id = 0;
  String get invoicesSaveDirectoryPath => _invoicesSaveDirectoryPath!;
  String get pageRoute => _pageRoute ?? 'CupertinoPageRoute';
  String get printer => _printer!;
  String get theme => _theme!;
  String get salesType => _salesType!;
  bool get animations => _animations;
  bool get firstStart => _firstStart;

  set invoicesSaveDirectoryPath(String? v) {
    _invoicesSaveDirectoryPath = v;
    edit().asStream();
  }

  set pageRoute(String? v) {
    _pageRoute = v;
    edit().asStream();
  }

  set printer(String? v) {
    _printer = v;
    edit().asStream();
  }

  set theme(String? v) {
    _theme = v;
    edit().asStream();
  }

  set salesType(String? v) {
    _salesType = v;
    edit().asStream();
  }

  set animations(bool v) {
    _animations = v;
    edit().asStream();
  }

  set firstStart(bool v) {
    _firstStart = v;
    edit().asStream();
  }

  String? _invoicesSaveDirectoryPath;
  String? _pageRoute;
  String? _printer;
  String? _theme = 'light';
  String? _salesType = 'administration';
  bool _animations = true;
  bool _firstStart = false;

  static Future<SystemConfig?> get() async {
    var r = await SystemMDBService.db
        .collection('sysconfig')
        .findOne(where.eq('id', 0));
    if (r == null) {
      return null;
    }
    var model = SystemConfig.fromMap(r);
    return model;
  }

  Future<void> edit() async {
    await SystemMDBService.db.collection('sysconfig').update(
          where.eq('id', 0),
          asMap(),
        );
    // print(r);
  }

  Future<void> add() async {
    await SystemMDBService.db.collection('sysconfig').insert(
          asMap(),
        );
  }

  asMap() => {
        'id': id,
        'invoicesSaveDirectoryPath': invoicesSaveDirectoryPath,
        'printer': printer,
        'salesType': salesType,
        'theme': theme,
        'animations': animations,
      };

  static SystemConfig fromMap(Map<String, dynamic> sysconfigData) {
    var model = SystemConfig();

    model.invoicesSaveDirectoryPath =
        sysconfigData['invoicesSaveDirectoryPath'];
    model.printer = sysconfigData['printer'];
    model.theme = sysconfigData['theme'];
    model.salesType = sysconfigData['salesType'];
    model.animations = sysconfigData['animations'] ?? true;
    return model;
  }

  Future<String?> getUserDirPath() async {
    String currentUserName = await getCurrentUserName();
    var currentUserDirPath = 'C:/Users/$currentUserName';
    // currentUserName == null ? currentUserDirPath = currentUserName : null;
    if (await chkdir(currentUserDirPath)) {
      return currentUserDirPath;
    }
    return null;
  }

  Future<String?> getUserDocumentsPath() async {
    String currentUserName = await getCurrentUserName();
    var currentUserDirPath = 'C:/Users/$currentUserName/Documents';
    // currentUserName == null ? currentUserDirPath = currentUserName : null;
    if (await chkdir(currentUserDirPath)) {
      return currentUserDirPath;
    }
    return null;
  }

  Future<String?> getUserPicturesPath() async {
    String currentUserName = await getCurrentUserName();
    var currentUserDirPath = 'C:/Users/$currentUserName/Pictures';
    // currentUserName == null ? currentUserDirPath = currentUserName : null;
    if (await chkdir(currentUserDirPath)) {
      return currentUserDirPath;
    }
    return null;
  }

  Future<String?> getUserAppDataDirPath() async {
    String currentUserName = await getCurrentUserName();
    var currentUserDirPath = 'C:/Users/$currentUserName/AppData';
    // currentUserName == null ? currentUserDirPath = currentUserName : null;
    if (await chkdir(currentUserDirPath)) {
      return currentUserDirPath;
    }
    return null;
  }
}
