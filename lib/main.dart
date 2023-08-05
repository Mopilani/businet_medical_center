import 'dart:io';

import 'package:businet_medical_center/initial_data.dart';
import 'package:businet_medical_center/models/esc_pos_utils/src/capability_profile.dart';
import 'package:businet_medical_center/models/esc_utils/print_model.dart';
import 'package:businet_medical_center/models/examination_page_settings_model.dart';
import 'package:businet_medical_center/models/system_config.dart';
import 'package:businet_medical_center/models/user_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:businet_medical_center/views/welcome_screen.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:updater/updater.dart' as updater;
import 'package:overlay_support/overlay_support.dart';

List errors = [];
List stacksTracess = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await EasyLocalization.ensureInitialized();

  try {
    // GlobalState.set('firebaseApp', app);
    await SystemMDBService().init();
    // MongoDBService().init();
  } catch (e, s) {
    errors.add(e);
    stacksTracess.add(s);
    throw s;
  }

  // var ins = SystemConfig.init();
  // ins.printer = 'Microsoft Print to PDF';
  // ins.invoicesSaveDirectoryPath = await ins.getUserDocumentsPath();
  // ins.theme = 'light';
  // await ins.add();
  if (Platform.isWindows) {
    try {
      SystemConfig().invoicesSaveDirectoryPath =
          await SystemConfig().getUserDocumentsPath();

      var config = await File('C:/Program Files/Besmar/cfg').readAsString();
      config;
      var sysCFG = await SystemConfig.get();
      // print(sysCFG);
      SystemConfig.init(sysCFG);
      // SystemConfig().printer = 'Microsoft Print to PDF';
      // SystemConfig().printer = json.decode(config)['printerName'];
      // var app = await Firebase.initializeApp(options: options);
    } catch (e, s) {
      errors.add(e);
      stacksTracess.add(s);
      throw s;
    }

    try {
      await PrintServiceModel.init(SystemConfig().printer);
    } catch (e, s) {
      errors.add(e);
      stacksTracess.add(s);
      throw s;
    }

    try {
      await CapabilityProfile.load();
    } catch (e, s) {
      errors.add(e);
      stacksTracess.add(s);
      throw s;
    }
  }

  try {
    // GlobalState.set('firebaseApp', app);
    await initialData();
  } catch (e, s) {
    errors.add(e);
    stacksTracess.add(s);
    throw s;
  }

  try {
    await ExaminationPageSettingsModel.get(UserModel.stored!.id);
  } catch (e, s) {
    errors.add(e);
    stacksTracess.add(s);
    throw s;
  }

  runApp(
    const MaterialApp(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'SD'),
      ],
      // path: 'assets/translations',
      // useFallbackTranslations: true,
      // startLocale: const Locale('ar', 'SD'),
      // fallbackLocale: const Locale('ar', 'SD'),
      // assetLoader: const CodegenLoader(),
      home: WelcomeScreen(
        title: 'Businet Medical Center Management',
      ),
    ),
  );
}

// class App extends StatefulWidget {
//   const App({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> {
//   // late FirebaseApp app;

//   @override
//   void initState() {
//     super.initState();
//     // firedart.FirebaseDartFlutter();
//     // app = GlobalState.get('firebaseApp');
//     // FirebaseAuth.initialize('', );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       // future: FirebaseDatabase(
//       //   app: app,
//       //   databaseURL: 'https://phone-shop-ebd1d-default-rtdb.firebaseio.com/',
//       // ).reference().child(CollectionsNames.products).get(),
//       builder: (context, snapshot) {
//         SystemConfig.systemConfig.addAll(
//           {
//             'err': snapshot.error.toString(),
//           },
//         );
//         return OverlaySupport.global(
//           child: updater.UpdaterBloc<ThemeData>(
//             updater: ThemeUpdater(
//               init: SystemConfig().theme == 'light'
//                   ? buildTheme(Brightness.light)
//                   : buildTheme(Brightness.dark),
//               updateForCurrentEvent: true,
//             ),
//             update: (context, state) {
//               contextLocale = context.locale;
//               return MaterialApp(
//                 localizationsDelegates: context.localizationDelegates,
//                 supportedLocales: context.supportedLocales,
//                 locale: context.locale,
//                 color: Colors.greenAccent,
//                 title: 'Businet Sales Managment Demo',
//                 debugShowCheckedModeBanner: false,
//                 theme: state.data ?? buildTheme(Brightness.light),
//                 // ThemeData( scaffoldBackgroundColor: Colors.grey[100],
//                 //   primarySwatch: Colors.blue, ),
//                 home: const WelcomeScreen(
//                   title: 'Businet Medical Center Management',
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

late Locale contextLocale;

class ThemeUpdater extends updater.Updater {
  ThemeUpdater({
    init,
    bool updateForCurrentEvent = false,
  }) : super(init, updateForCurrentEvent: updateForCurrentEvent);
}

ThemeData buildTheme(Brightness brightness) {
  String fontFam = 'cairo';
  var baseTheme = ThemeData(
    brightness: brightness,
    textTheme: TextTheme(
      displaySmall: TextStyle(fontFamily: fontFam),
      displayMedium: TextStyle(fontFamily: fontFam),
      labelLarge: TextStyle(fontFamily: fontFam),
      bodyLarge: TextStyle(fontFamily: fontFam),
      bodyMedium: TextStyle(fontFamily: fontFam),
      bodySmall: TextStyle(fontFamily: fontFam),
      labelMedium: TextStyle(fontFamily: fontFam),
      labelSmall: TextStyle(fontFamily: fontFam),
      titleLarge: TextStyle(fontFamily: fontFam),
      titleMedium: TextStyle(fontFamily: fontFam),
      titleSmall: TextStyle(fontFamily: fontFam),
      displayLarge: TextStyle(fontFamily: fontFam),
    ),
    primaryTextTheme: TextTheme(
      displaySmall: TextStyle(fontFamily: fontFam),
      displayMedium: TextStyle(fontFamily: fontFam),
      labelLarge: TextStyle(fontFamily: fontFam),
      bodyLarge: TextStyle(fontFamily: fontFam),
      bodyMedium: TextStyle(fontFamily: fontFam),
      bodySmall: TextStyle(fontFamily: fontFam),
      labelMedium: TextStyle(fontFamily: fontFam),
      labelSmall: TextStyle(fontFamily: fontFam),
      titleLarge: TextStyle(fontFamily: fontFam),
      titleMedium: TextStyle(fontFamily: fontFam),
      titleSmall: TextStyle(fontFamily: fontFam),
      displayLarge: TextStyle(fontFamily: fontFam),
    ),
  );

  return baseTheme;
}

// main() { String botAPIToken = '1251lmoin3no312ncn23oin';
//   var instance = Bot(botAPIToken);
//   instance.messegsStream.listen((msg) {
//     if (msg == 'Hello World') { 'مرحب معاك اسامة في ا لخط'; } } ); }

// class Bot {   Bot(String apiToken);
//   Stream messegsStream = Stream.periodic(const Duration(seconds: 5), (t) {
//     return 'Hello World';   }); }


