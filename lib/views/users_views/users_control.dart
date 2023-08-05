
import 'package:businet_medical_center/models/access_level_model.dart';
import 'package:businet_medical_center/models/navigator_model.dart';
import 'package:businet_medical_center/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:updater/updater.dart' as updater;

class UsersControle extends StatefulWidget {
  const UsersControle({
    Key? key,
    this.model,
    this.editMode = false,
    this.editPasswordMode = false,
  }) : super(key: key);
  final bool editPasswordMode;
  final UserModel? model;
  final bool editMode;

  @override
  State<UsersControle> createState() => _UsersControleState();
}

class _UsersControleState extends State<UsersControle> {
  late FocusNode lastnameNode;
  late FocusNode usernameNode;
  late FocusNode passwordNode;
  late FocusNode firstnameNode;
  late FocusNode phoneNumberNode;
  late TextEditingController idController;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController usernameController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;

  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController newPasswordConfirmController;

  @override
  void initState() {
    super.initState();
    firstnameNode = FocusNode();
    lastnameNode = FocusNode();
    usernameNode = FocusNode();
    passwordNode = FocusNode();
    phoneNumberNode = FocusNode();
    if (widget.editMode) {
      id = widget.model!.id;
      firstname = widget.model!.firstname;
      lastname = widget.model!.lastname;
      phoneNumber = widget.model!.phoneNumber;
      accessLevelModel = widget.model!.accessLevelModel!;
      username = widget.model!.username;
      password = widget.model!.password;
      idController = TextEditingController(text: id.toString());
      firstnameController = TextEditingController(text: firstname);
      lastnameController = TextEditingController(text: lastname);
      usernameController = TextEditingController(text: username);
      phoneNumberController = TextEditingController(text: phoneNumber);
      passwordController = TextEditingController(text: password);

      // For Edit Password Mode
      oldPasswordController = TextEditingController();
      newPasswordController = TextEditingController();
      newPasswordConfirmController = TextEditingController();
    } else {
      idController = TextEditingController();
      firstnameController = TextEditingController();
      lastnameController = TextEditingController();
      usernameController = TextEditingController();
      phoneNumberController = TextEditingController();
      passwordController = TextEditingController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    firstnameNode.dispose();
    lastnameNode.dispose();
    usernameNode.dispose();
    passwordNode.dispose();
    phoneNumberNode.dispose();
  }

  bool loading = false;
  // final List<CatgoryModel> models = [];

  int id = 0;
  String firstname = '';
  String lastname = '';
  late String username;
  String phoneNumber = '';
  String password = '';
  AccessLevelModel? accessLevelModel;

  int currentAccessLevelDropDownValue = 0;
  final List<AccessLevelModel> _registeredAccessLevels = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editMode ? 'edit_users'.tr : 'add_users'.tr),
        flexibleSpace: loading ? const CircularProgressIndicator() : null,
        actions: [
          MaterialButton(
            color: Colors.blue,
            onPressed: widget.editPasswordMode
                ? () async {
                    if (await UserModel.checkPasswordForUser(
                        username, oldPasswordController.text)) {
                      if (newPasswordController.text ==
                          newPasswordConfirmController.text) {
                        widget.model!.password = newPasswordController.text;
                        await widget.model!.edit().then((value) {
                          setState(() {
                            loading = false;
                            showSimpleNotification(
                              const Text(
                                'تم بنجاح',
                                style: TextStyle(fontSize: 20),
                              ),
                              position: NotificationPosition.bottom,
                            );
                          });
                        });
                      } else {
                        toast('عليك التأكد من كلة السر الجديدة');
                      }
                    } else {
                      toast('كلة السر القديمة غير صحيحة');
                    }
                  }
                : () async {
                    setState(() {
                      loading = true;
                    });

                    if (widget.editMode) {
                      await UserModel(
                        id,
                        firstname: firstname,
                        lastname: lastname,
                        username: username,
                        phoneNumber: phoneNumber,
                        password: password,
                        accessLevelModel: accessLevelModel,
                      ).edit().then((value) {
                        setState(() {
                          loading = false;
                        });
                        showSimpleNotification(
                          const Text(
                            'تم بنجاح',
                            style: TextStyle(fontSize: 20),
                          ),
                          position: NotificationPosition.bottom,
                        );
                      });
                    } else {
                      if (idController.text.isEmpty) {
                        showSimpleNotification(
                          const Text('لا يمكنك ترك معرف المستخدم فارغا'),
                          position: NotificationPosition.bottom,
                        );
                        return;
                      }
                      if (username.isEmpty) {
                        showSimpleNotification(
                          const Text('لا يمكنك ترك اسم المستخدم فارغا'),
                          position: NotificationPosition.bottom,
                        );
                        return;
                      }
                      if (password.isEmpty) {
                        showSimpleNotification(
                          const Text('لا يمكنك ترك كلمة سر المستخدم فارغة'),
                          position: NotificationPosition.bottom,
                        );
                        return;
                      }
                      if (accessLevelModel == null) {
                        showSimpleNotification(
                          const Text('عليك اعطاء المستخدم بعض الصلاحيات'),
                          position: NotificationPosition.bottom,
                        );
                        return;
                      }
                      await UserModel.get(id).then(
                        (value) async {
                          if (value == null) {
                            await UserModel(
                              id,
                              firstname: firstname,
                              lastname: lastname,
                              username: username,
                              phoneNumber: phoneNumber,
                              password: password,
                              accessLevelModel: accessLevelModel,
                            ).add().then((value) {
                              setState(() {
                                loading = false;
                                showSimpleNotification(
                                  const Text(
                                    'تم بنجاح',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  position: NotificationPosition.bottom,
                                );
                              });
                            });
                          } else {
                            toast('معرف المستخدم مدرج بالفعل');
                          }
                        },
                      );
                    }
                  },
            child: const Text(
              'حفظ',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            widget.editPasswordMode
                ? const SizedBox()
                : SizedBox(
                    child: Container(
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      child: TextField(
                        controller: idController,
                        autofocus: !widget.editMode,
                        enabled: !widget.editMode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelText: 'id'.tr,
                        ),
                        onSubmitted: (result) {
                          if (result.isEmpty) {
                            showSimpleNotification(
                              const Text('لا يمكنك ترك معرف المستخدم فارغا'),
                              position: NotificationPosition.bottom,
                            );
                            return;
                          }
                          try {
                            id = int.parse(result);
                          } catch (e) {
                            showSimpleNotification(
                              const Text(
                                  'تأكد من كتابتك للمعرف بصورة صحيحة حيث يحتوي على ارقام فقط'),
                              position: NotificationPosition.bottom,
                            );
                            return;
                          }
                          firstnameNode.requestFocus();
                          firstnameController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: firstnameController.text.length,
                          );
                        },
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
            widget.editPasswordMode
                ? const SizedBox()
                : Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            controller: firstnameController,
                            autofocus: widget.editMode,
                            focusNode: firstnameNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'firstname'.tr,
                            ),
                            onSubmitted: (result) {
                              if (result.isEmpty) {
                                showSimpleNotification(
                                  const Text('لا يمكنك ترك الاول فارغا'),
                                  position: NotificationPosition.bottom,
                                );
                                return;
                              }
                              firstname = result;
                              lastnameNode.requestFocus();
                              lastnameController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: lastnameController.text.length,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            controller: lastnameController,
                            autofocus: widget.editMode,
                            focusNode: lastnameNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'lastname'.tr,
                            ),
                            onSubmitted: (result) {
                              if (result.isEmpty) {
                                showSimpleNotification(
                                  const Text('عليك بملء هذا المجال'),
                                  position: NotificationPosition.bottom,
                                );
                                return;
                              }
                              lastname = result;
                              usernameNode.requestFocus();
                              usernameController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: usernameController.text.length,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 16),
            widget.editPasswordMode
                ? const SizedBox()
                : Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            controller: usernameController,
                            autofocus: widget.editMode,
                            focusNode: usernameNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'username'.tr,
                            ),
                            onSubmitted: (result) {
                              if (result.isEmpty) {
                                showSimpleNotification(
                                  const Text('عليك بملء هذا المجال'),
                                  position: NotificationPosition.bottom,
                                );
                                return;
                              }
                              username = result;
                              phoneNumberNode.requestFocus();
                              phoneNumberController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: phoneNumberController.text.length,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            controller: phoneNumberController,
                            autofocus: widget.editMode,
                            focusNode: phoneNumberNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'phone_number'.tr,
                            ),
                            onSubmitted: (result) {
                              if (result.isEmpty) {
                                showSimpleNotification(
                                  const Text('عليك بملء هذا المجال'),
                                  position: NotificationPosition.bottom,
                                );
                                return;
                              }
                              phoneNumber = result;
                              passwordNode.requestFocus();
                              passwordController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: passwordController.text.length,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 16),
            widget.editPasswordMode
                ? const SizedBox()
                : widget.editMode
                    ? const SizedBox()
                    : Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 8, right: 8),
                              child: TextField(
                                controller: passwordController,
                                focusNode: passwordNode,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: 'password'.tr,
                                ),
                                onSubmitted: (result) {
                                  password = result;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 32),
                          widget.editPasswordMode
                              ? const SizedBox()
                              : const Text('مستوى المستخدم'),
                          const SizedBox(width: 12),
                          widget.editPasswordMode
                              ? const SizedBox()
                              : FutureBuilder<List<AccessLevelModel>>(
                                  future: AccessLevelModel.getAll(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      _registeredAccessLevels.clear();
                                      _registeredAccessLevels
                                          .addAll(snapshot.data!);
                                      return DropdownButton<int>(
                                        items: _registeredAccessLevels
                                            .map((element) {
                                          if (accessLevelModel?.id ==
                                              element.id) {
                                            currentAccessLevelDropDownValue =
                                                _registeredAccessLevels
                                                    .indexOf(element);
                                          }
                                          return DropdownMenuItem<int>(
                                            onTap: () {
                                              accessLevelModel = element;
                                            },
                                            value: _registeredAccessLevels
                                                .indexOf(element),
                                            child: Row(
                                              children: [
                                                Text(element.levelDescription),
                                                const SizedBox(width: 16),
                                                Text(element.levelNumber
                                                    .toString()),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        value: currentAccessLevelDropDownValue,
                                        onChanged: (result) {
                                          setState(() {
                                            currentAccessLevelDropDownValue =
                                                result!;
                                          });
                                        },
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          snapshot.error.toString(),
                                        ),
                                      );
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      return const Text(
                                          'لا يوجد مستخدمين مضافين من قبل');
                                    }
                                  },
                                ),
                          const SizedBox(width: 32),
                        ],
                      ),
            widget.editPasswordMode
                ? Column(
                    children: [
                      SizedBox(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            controller: oldPasswordController,
                            // focusNode: passwordNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'كلمة السر القديمة',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            controller: newPasswordController,
                            // focusNode: passwordNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'كلمة السر الجديدة',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            controller: newPasswordConfirmController,
                            // focusNode: passwordNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'تأكيد كلمة السر',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 32),
            widget.editPasswordMode
                ? const SizedBox()
                : updater.UpdaterBloc(
                    updater: UserAllowedLevelsUpdater(
                      init: 0,
                      updateForCurrentEvent: true,
                    ),
                    update: (context, state) {
                      return Wrap(
                        children: systemRoutes.entries.map(
                          (entry) {
                            bool value = false;
                            if (accessLevelModel != null) {
                              value = accessLevelModel!.allowedLevels
                                  .containsKey(entry.key);
                            }
                            return SizedBox(
                              width: 300,
                              child: CheckboxListTile(
                                value: value,
                                title: Text(entry.key),
                                onChanged: (_) {
                                  value = !value;
                                  if (value) {
                                    accessLevelModel!.allowedLevels
                                        .addAll(entry.value.toMap());
                                  } else {
                                    accessLevelModel!.allowedLevels
                                        .remove(entry.key);
                                  }
                                  // print(accessLevelModel!.allowedLevels);
                                  UserAllowedLevelsUpdater().add(0);
                                },
                              ),
                            );
                          },
                        ).toList(),
                      );
                    }),
            const SizedBox(height: 48),

            // const SizedBox(height: 48),
          ],
        ),
      ),
      // FutureBuilder<List<CatgoryModel>>(
      //   future: CatgoryModel.getAll(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return const Text('حدث خطأ اثناء تحميل البيانات');
      //     }
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CircularProgressIndicator();
      //     }
      //     if (snapshot.hasData) {
      //       models.addAll(snapshot.data!);
      //     }
      //     return Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Column(
      //         children: models.map(
      //           (model) {
      //             return Text(model.catgoryName);
      //           },
      //         ).toList(),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}

class UserAllowedLevelsUpdater extends updater.Updater {
  UserAllowedLevelsUpdater({
    init,
    bool updateForCurrentEvent = false,
  }) : super(init, updateForCurrentEvent: updateForCurrentEvent);
}
