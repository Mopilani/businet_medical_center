import 'package:businet_medical_center/models/costumer_model.dart';
import 'package:businet_medical_center/models/receipt_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:updater/updater.dart' as updater;

import 'receipt_view_and_repay.dart';

class CostumerControle extends StatefulWidget {
  const CostumerControle({
    Key? key,
    this.model,
    this.editMode = false,
    this.editPasswordMode = false,
  }) : super(key: key);
  final CostumerModel? model;
  final bool editMode;
  final bool editPasswordMode;

  @override
  State<CostumerControle> createState() => _CostumerControleState();
}

class _CostumerControleState extends State<CostumerControle> {
  late FocusNode firstnameNode;
  late FocusNode lastnameNode;
  late FocusNode phoneNumberNode;
  late FocusNode debtCeilingNode;
  late FocusNode bonusNode;
  late FocusNode noteNode;
  late FocusNode emailNode;
  // late FocusNode totalWantedNode;
  late FocusNode receiptsArchiveNode;

  late TextEditingController idController;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController phoneNumberController;
  late TextEditingController debtCeilingController;
  late TextEditingController bonusController;
  late TextEditingController noteController;
  late TextEditingController emailController;
  // late TextEditingController totalWantedController;
  late TextEditingController receiptsArchiveController;

  @override
  void initState() {
    super.initState();
    firstnameNode = FocusNode();
    lastnameNode = FocusNode();
    phoneNumberNode = FocusNode();
    debtCeilingNode = FocusNode();
    bonusNode = FocusNode();
    noteNode = FocusNode();
    emailNode = FocusNode();
    // totalWantedNode = FocusNode();
    receiptsArchiveNode = FocusNode();

    if (widget.editMode) {
      id = widget.model!.id;
      firstname = widget.model!.firstname;
      lastname = widget.model!.lastname;
      phoneNumber = widget.model!.phoneNumber;
      debtCeiling = widget.model!.debtCeiling;
      bonus = widget.model!.bonus;
      note = widget.model!.note;
      email = widget.model!.email;
      totalWanted = widget.model!.totalWanted;
      totalPayed = widget.model!.totalPayed;
      receiptsArchive = widget.model!.receiptsArchive.reversed.toList();

      idController = TextEditingController(text: id.toString());
      firstnameController = TextEditingController(text: firstname);
      lastnameController = TextEditingController(text: lastname);
      phoneNumberController = TextEditingController(text: phoneNumber);
      debtCeilingController =
          TextEditingController(text: debtCeiling.toString());
      bonusController = TextEditingController(text: bonus.toString());
      noteController = TextEditingController(text: note);
      emailController = TextEditingController(text: email);
      // totalWantedController =
      //     TextEditingController(text: totalWanted.toString());
      // receiptsArchiveController =
      //     TextEditingController(text: receiptsArchive.toString());
    } else {
      idController = TextEditingController();
      firstnameController = TextEditingController();
      lastnameController = TextEditingController();
      phoneNumberController = TextEditingController();
      debtCeilingController = TextEditingController();
      bonusController = TextEditingController();
      noteController = TextEditingController();
      emailController = TextEditingController();
      // totalWantedController = TextEditingController();
      // receiptsArchiveController = TextEditingController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    firstnameNode.dispose();
    lastnameNode.dispose();
    phoneNumberNode.dispose();

    idController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    phoneNumberController.dispose();
    debtCeilingController.dispose();
    bonusController.dispose();
    noteController.dispose();
    emailController.dispose();
    // totalWantedController.dispose();
    // receiptsArchiveController.dispose();
  }

  bool loading = false;
  // final List<CatgoryModel> models = [];

  int id = 0;
  String firstname = '';
  String lastname = '';
  String phoneNumber = '';
  String? email;
  double debtCeiling = .0;

  String? note;
  String? bonus = '';
  double totalWanted = .0;
  double totalPayed = .0;
  // double realPayed = .0;
  List<String> receiptsArchive = [];

  int currentAccessLevelDropDownValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editMode ? 'edit_costumers'.tr : 'add_costumers'.tr),
        flexibleSpace: loading ? const CircularProgressIndicator() : null,
        actions: [
          MaterialButton(
            color: Colors.blue,
            onPressed: () async {
              setState(() {
                loading = true;
              });

              if (widget.editMode) {
                await CostumerModel(
                  id,
                  firstname: firstname,
                  lastname: lastname,
                  phoneNumber: phoneNumber,
                  debtCeiling: debtCeiling,
                  totalWanted: totalWanted,
                  totalPayed: totalPayed,
                  email: email,
                  note: note,
                  receiptsArchive: receiptsArchive,
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
                // if (accessLevelModel == null) {
                //   showSimpleNotification(
                //     const Text('عليك اعطاء المستخدم بعض الصلاحيات'),
                //     position: NotificationPosition.bottom,
                //   );
                //   return;
                // }
                await CostumerModel.get(id).then(
                  (value) async {
                    if (value == null) {
                      await CostumerModel(
                        id,
                        firstname: firstname,
                        lastname: lastname,
                        phoneNumber: phoneNumber,
                        debtCeiling: debtCeiling,
                        totalWanted: totalWanted,
                        totalPayed: totalPayed,
                        email: email,
                        note: note,
                        receiptsArchive: receiptsArchive,
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
      body: Column(
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
                            const Text('عليك بملء هذا المجال'),
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
                                const Text('عليك بملء هذا المجال'),
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
                            emailNode.requestFocus();
                            emailController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: emailController.text.length,
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
                          controller: emailController,
                          autofocus: widget.editMode,
                          focusNode: emailNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: 'البريد الالكتروني',
                          ),
                          onSubmitted: (result) {
                            if (result.isEmpty) {
                              showSimpleNotification(
                                const Text('عليك بملء هذا المجال'),
                                position: NotificationPosition.bottom,
                              );
                              return;
                            }
                            email = result;
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
                            debtCeilingNode.requestFocus();
                            debtCeilingController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: debtCeilingController.text.length,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: TextField(
                    controller: debtCeilingController,
                    focusNode: debtCeilingNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'سقف الدين',
                    ),
                    onSubmitted: (result) {
                      if (result.isEmpty) {
                        showSimpleNotification(
                          const Text('عليك بملء هذا المجال'),
                          position: NotificationPosition.bottom,
                        );
                        return;
                      }
                      try {
                        debtCeiling = double.parse(result);
                      } catch (e) {
                        showSimpleNotification(
                          const Text(
                              'تأكد من كتابتك للمعرف بصورة صحيحة حيث يحتوي على ارقام فقط'),
                          position: NotificationPosition.bottom,
                        );
                        return;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 32),
              // const Text('مستوى المستخدم'),
              // const SizedBox(width: 12),
              // FutureBuilder<List<AccessLevelModel>>(
              //   future: AccessLevelModel.getAll(),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       _registeredAccessLevels.clear();
              //       _registeredAccessLevels.addAll(snapshot.data!);
              //       return DropdownButton<int>(
              //         items: _registeredAccessLevels.map((element) {
              //           if (accessLevelModel?.id == element.id) {
              //             currentAccessLevelDropDownValue =
              //                 _registeredAccessLevels.indexOf(element);
              //           }
              //           return DropdownMenuItem<int>(
              //             onTap: () {
              //               accessLevelModel = element;
              //             },
              //             value: _registeredAccessLevels.indexOf(element),
              //             child: Row(
              //               children: [
              //                 Text(element.levelDescription),
              //                 const SizedBox(width: 16),
              //                 Text(element.levelNumber.toString()),
              //               ],
              //             ),
              //           );
              //         }).toList(),
              //         value: currentAccessLevelDropDownValue,
              //         onChanged: (result) {
              //           setState(() {
              //             currentAccessLevelDropDownValue = result!;
              //           });
              //         },
              //       );
              //     }
              //     if (snapshot.hasError) {
              //       return Center(
              //         child: Text(
              //           snapshot.error.toString(),
              //         ),
              //       );
              //     }
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const CircularProgressIndicator();
              //     } else {
              //       return const Text('لا يوجد مستخدمين مضافين من قبل');
              //     }
              //   },
              // ),
              const SizedBox(width: 32),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '  اجمالي المتفق:  $totalPayed',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '  اجمالي المدفوع:  ${totalPayed - totalWanted}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '   اجمالي المطلوب أجلا:  $totalWanted',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ReceiptViewAndRepay(),
                    //   ),
                    // );
                  },
                  color: Colors.black12,
                  child: const Text('تسديد دين او اجل'),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: receiptsArchive.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    await ReceiptModel.get(
                      int.parse(receiptsArchive[index].split(' - ').first),
                      // receiptsArchive[index].split(' - ')[0],
                    ).then((model) {
                      if (model == null) {
                        toast('غير موجود');
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReceiptViewAndRepay(receipt: model),
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ReceiptView(
                      //       editMode: true,
                      //       model: model,
                      //     ),
                      //   ),
                      // );
                    });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        () {
                          var text = '';
                          var r = receiptsArchive[index].split(' - ');
                          text += r[0];
                          text += ' - ';
                          text += receiptStatesTranslations[r[1]].toString();
                          text += ' - ';
                          text += r[2];
                          text += ' - ';
                          text += r[3];
                          return text;
                        }(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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

class CostumerLevelUpdater extends updater.Updater {
  CostumerLevelUpdater({
    init,
    bool updateForCurrentEvent = false,
  }) : super(init, updateForCurrentEvent: updateForCurrentEvent);
}
