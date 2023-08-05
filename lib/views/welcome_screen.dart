import 'package:businet_medical_center/main.dart';
import 'package:businet_medical_center/models/examination_page_settings_model.dart';
import 'package:businet_medical_center/models/processes_model.dart';
import 'package:businet_medical_center/models/user_model.dart';
import 'package:businet_medical_center/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:animated_background/animated_background.dart';

import '../../utils/converters.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late FocusNode usernameNode;
  late FocusNode passwordNode;
  bool errorFound = false;

  @override
  void initState() {
    super.initState();
    showWelcomeDialog();
    usernameNode = FocusNode();
    passwordNode = FocusNode();
    if (errors.isNotEmpty) {
      errorFound = true;
      print('Errors: $errors');
      // errors
      // stacksTracess
    }
  }

  Future showWelcomeDialog() async {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> _signIn() async {
      await UserModel.signin(
        usernameController.text,
        passwordController.text,
      ).then((result) async {
        try {
          await ExaminationPageSettingsModel.get(UserModel.stored!.id);
        } catch (e) {
          //
        }
        if (result != null) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(title: widget.title),
            ),
          );
        } else {
          toast('signin_faild'.tr);
        }
      });
    }

    await Future.delayed(const Duration(seconds: 1), () async {
      await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              color: Colors.transparent,
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: errorFound ? 1000 : 300,
                height: errorFound ? 800 : 300,
                child: errorFound
                    ? Column(
                        children: [
                          const Text(
                            'يبدو ان هناك خطأ ما اثناء تشغغيل البرنامج ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$errors',
                            // style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$stacksTracess',
                            // style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                child: const Text('وضع المطور'),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         const DeveloperModeView(),
                                  //   ),
                                  // );
                                },
                              ),
                              const SizedBox(width: 16),
                              MaterialButton(
                                child: const Text('تجاهل'),
                                onPressed: () {
                                  errorFound = !errorFound;
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            '!مرحبا بعودتك',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          TextField(
                            autofocus: true,
                            focusNode: usernameNode,
                            controller: usernameController,
                            onSubmitted: (text) {
                              passwordNode.requestFocus();
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.black12,
                              filled: true,
                              label: Text('username'.tr),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          TextField(
                            focusNode: passwordNode,
                            obscureText: true,
                            controller: passwordController,
                            onSubmitted: (text) {
                              _signIn();
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.black12,
                              filled: true,
                              label: Text('password'.tr),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          MaterialButton(
                            onPressed: _signIn,
                            color: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                            child: Text(
                              'signin'.tr,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/Businet_Edition_Dark.png',
            fit: width <= 1024 ? BoxFit.contain : BoxFit.fill,
            width: width <= 1024 ? null : width,
            height: height <= 786 ? null : height,
          ),
          AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: const ParticleOptions(
                baseColor: Colors.yellow,
                spawnMaxSpeed: 20,
                spawnMinSpeed: 10,
              ),
            ),
            vsync: this,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  wid33(errorFound ? 'خطأ' : 'signin',
                      onPressed: errorFound
                          ? showWelcomeDialog
                          : () {
                              if (UserModel.stored?.accessLevelModel != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(title: widget.title),
                                  ),
                                );
                              } else {
                                showWelcomeDialog();
                              }
                            }),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'businessDayDate'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (ProcessesModel.stored?.businessDayString())
                                .toString(),
                            style: const TextStyle(
                              fontSize: 22,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'dayDate'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          StreamBuilder(
                            stream: Stream.periodic(const Duration(seconds: 1)),
                            builder: (c, s) {
                              return Text(
                                dateTimeToString(DateTime.now()),
                                style: const TextStyle(
                                  fontSize: 22,
                                  // fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الاصدار',
                            style: TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '2022 - 1.13.3',
                            style: TextStyle(
                              fontSize: 22,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // WindowsTaskbar.setProgressMode(TaskbarProgressMode.indeterminate);
      //     // WindowsTaskbar.setProgress(0, 100);
      //     await WindowsTaskbar.setFlashTaskbarAppIcon(
      //       // timeout: Duration(seconds: 5),
      //       mode: TaskbarFlashMode.all,
      //     );
      //   },
      // ),
    );
  }

  Widget wid34(
    String text, {
    Function()? onPressed,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 180,
          child: MaterialButton(
            elevation: 0,
            onPressed: onPressed ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(title: widget.title),
                    ),
                  );
                },
            color: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.fromLTRB(32, 20, 32, 20),
            child: Text(
              text.tr,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget wid33(
    String text, {
    Function()? onPressed,
  }) {
    return Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          width: 180,
          child: MaterialButton(
            elevation: 0,
            onPressed: onPressed ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(title: widget.title),
                    ),
                  );
                },
            color: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.fromLTRB(32, 20, 32, 20),
            child: Text(
              text.tr,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
