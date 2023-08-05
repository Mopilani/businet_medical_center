import 'package:businet_medical_center/models/payment_method_model.dart';
import 'package:businet_medical_center/models/processes_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:updater/updater.dart' as updater;

class PaymentMethodControle extends StatefulWidget {
  const PaymentMethodControle({
    Key? key,
    this.model,
    this.editMode = false,
  }) : super(key: key);
  final PaymentMethodModel? model;
  final bool editMode;

  @override
  State<PaymentMethodControle> createState() => _PaymentMethodControleState();
}

class _PaymentMethodControleState extends State<PaymentMethodControle> {
  late FocusNode idNode;
  late FocusNode nameNode;
  late FocusNode currencyNode;
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController currencyController;

  @override
  void initState() {
    super.initState();
    // store = Firestore.initialize('');
    idNode = FocusNode();
    if (widget.editMode) {
      id = widget.model!.id;
      name = widget.model!.methodName;
      currency = widget.model!.currency;
      postPayMethod = widget.model!.postPayMethod;
      // tax = widget.model!.tax;
      idController = TextEditingController(text: id.toString());
      nameController = TextEditingController(text: name);
      currencyController = TextEditingController(text: currency.toString());
    } else {
      getSaleUnit();
      idController = TextEditingController();
      nameController = TextEditingController();
      currencyController = TextEditingController();
    }
    idNode = FocusNode();
    nameNode = FocusNode();
    currencyNode = FocusNode();
  }

  getSaleUnit() async {
    // s = (await PaymentMethodModel.findById(0))!;
  }

  bool postPayMethod = false;

  @override
  void dispose() {
    super.dispose();
    idNode.dispose();
  }

  bool loading = false;

  final List<PaymentMethodModel> models = [];

  int id = 0;
  String name = '';
  String currency = 'ج.س';

  int currentSaleUnitDropDownValue = 0;

  @override
  Widget build(BuildContext context) {
    // _registeredSaleUnits.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editMode ? 'edit_sale_unit'.tr : 'add_sale_unit'.tr),
        flexibleSpace: loading ? const CircularProgressIndicator() : null,
      ),
      body: updater.UpdaterBloc(
          updater: ThisPageUpdater(
            initialState: 0,
            updateForCurrentEvent: true,
          ),
          update: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
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
                                  const Text(
                                      'لا يمكنك ترك معرف وحدة البيع فارغا'),
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
                              nameNode.requestFocus();
                              nameController.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: nameController.text.length,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'معرف اخر وحدة بيع: ${ProcessesModel.stored!.lastSaleUnitId}',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: TextField(
                      controller: nameController,
                      autofocus: widget.editMode,
                      focusNode: nameNode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        labelText: 'name'.tr,
                      ),
                      onSubmitted: (result) {
                        if (result.isEmpty) {
                          showSimpleNotification(
                            const Text('لا يمكنك ترك اسم وحدة البيع فارغا'),
                            position: NotificationPosition.bottom,
                          );
                          return;
                        }
                        name = result;
                        currencyNode.requestFocus();
                        currencyController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: currencyController.text.length,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: TextField(
                          controller: currencyController,
                          focusNode: currencyNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: 'العملة'.tr,
                          ),
                          onSubmitted: (result) {
                            try {
                              currency = result;
                            } catch (e) {
                              showSimpleNotification(
                                const Text(
                                    'تأكد من كتابتك للكمية بصورة صحيحة حيث يحتوي على ارقام فقط'),
                                position: NotificationPosition.bottom,
                              );
                              return;
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: CheckboxListTile(
                        onChanged: (value) {
                          postPayMethod = !postPayMethod;
                          ThisPageUpdater().add(0);
                        },
                        title: const Text('طريقة دفع اجل'),
                        value: postPayMethod,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                    'حفظ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });

                    if (widget.editMode) {
                      await PaymentMethodModel(
                        id,
                        methodName: name,
                        currency: currency,
                        postPayMethod: postPayMethod,
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
                          const Text('لا يمكنك ترك معرف الشريحة فارغا'),
                          position: NotificationPosition.bottom,
                        );
                        return;
                      }
                      if (name.isEmpty) {
                        showSimpleNotification(
                          const Text('لا يمكنك ترك اسم الشريحة فارغا'),
                          position: NotificationPosition.bottom,
                        );
                        return;
                      }
                      await PaymentMethodModel.get(id).then(
                        (value) async {
                          if (value == null) {
                            await PaymentMethodModel(
                              id,
                              methodName: name,
                              currency: currency,
                              postPayMethod: postPayMethod,
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
                            toast('معرف وحدة البيع مدرج بالفعل');
                          }
                        },
                      );
                    }
                  },
                ),
                const Spacer(),
              ],
            );
          }),
      // FutureBuilder<List<PaymentMethodModel>>(
      //   future: PaymentMethodModel.getAll(),
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
      //             return Text(model.name);
      //           },
      //         ).toList(),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}

class ThisPageUpdater extends updater.Updater {
  ThisPageUpdater({
    dynamic initialState,
    bool updateForCurrentEvent = false,
  }) : super(initialState, updateForCurrentEvent: updateForCurrentEvent);
}
