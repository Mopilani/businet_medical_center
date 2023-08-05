import 'package:businet_medical_center/models/examination_page_settings_model.dart';
import 'package:businet_medical_center/models/navigator_model.dart';
import 'package:businet_medical_center/models/user_model.dart';
import 'package:businet_medical_center/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  UserModel? user = UserModel.stored;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const AccountSettingsAppBar(),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 40,
                        child: MaterialButton(
                          onPressed: () async {
                            // await SystemMDBService.db
                            //     .collection('usersExaminationPageSettings')
                            //     .drop();
                            if (ExaminationPageSettingsModel.stored == null) {
                              await ExaminationPageSettingsModel(
                                UserModel.stored!.id,
                                description: '',
                                generalCheckSegmentSettings:
                                    ExaminationPageSettingsModel
                                        .defaultGeneralCheckSegmentSettings,
                              ).add();
                            } else {
                              ExaminationPageSettingsModel
                                      .stored!.generalCheckSegmentSettings =
                                  ExaminationPageSettingsModel
                                      .defaultGeneralCheckSegmentSettings;

                              await ExaminationPageSettingsModel.stored!.edit();
                            }
                          },
                          color: Colors.black87,
                          child: const Text(
                            'تهيئة اعدادات الكشف',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Builder(builder: (context) {
                    if (user == null) {
                      return const Center(
                        child: Text(
                          'Businet',
                          style: TextStyle(
                            fontSize: 100,
                            // color: Colors.black12,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        const Icon(Icons.person,
                            size: 100, color: Colors.black45),
                        const SizedBox(height: 16),
                        Text(
                          'Your Id: ${user!.id}',
                          style: const TextStyle(
                            fontSize: 22,
                            // color: Colors.black12,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${user!.firstname} ${user!.lastname}',
                              style: const TextStyle(
                                fontSize: 72,
                                // color: Colors.black12,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Username: ${user!.username}',
                          style: const TextStyle(
                            fontSize: 22,
                            // color: Colors.black12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user!.phoneNumber,
                          style: const TextStyle(
                            fontSize: 22,
                            // color: Colors.black12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 50,
                  width: 120,
                  child: MaterialButton(
                    color: Colors.red,
                    child: Text(
                      'signout'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () async {
                      await UserModel.signout().then((_) {
                        SysNav.pushAndRemoveUntil(
                          context,
                          const WelcomeScreen(title: 'Restart'),
                          eznNeeded: false,
                        );
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 120,
                  child: MaterialButton(
                    color: Colors.blue,
                    child: Text(
                      'password'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      // SysNav.push(
                      //   context,
                      //   UsersControle(
                      //     editPasswordMode: true,
                      //     editMode: true,
                      //     model: user!,
                      //   ),
                      // );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AccountSettingsAppBar extends StatelessWidget {
  const AccountSettingsAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
      child: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Account Settings'),
        centerTitle: true,
        actions: [],
      ),
    );
  }
}

// Padding(
//   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//   child: IconButton(
//     icon: const Icon(
//       Icons.add,
//     ),
//     onPressed: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const AddNewTask(),
//         ),
//       );
//     },
//   ),
// ),
