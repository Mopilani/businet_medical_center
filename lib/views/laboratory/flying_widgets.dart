import 'package:businet_medical_center/models/costumer_model.dart';
import 'package:businet_medical_center/models/medical_service_model.dart';
import 'package:businet_medical_center/models/payment_method_model.dart';
import 'package:businet_medical_center/models/processes_model.dart';
import 'package:businet_medical_center/models/receipt_and_bill_payment_method_entry_model.dart';
import 'package:businet_medical_center/models/reservation_model.dart';
import 'package:businet_medical_center/utils/updaters.dart';
import 'package:businet_medical_center/views/mangment_views/bills/widgets.dart';
import 'package:businet_medical_center/views/reservation/reservation.dart';
import 'package:businet_medical_center/views/settings/costumers_views/costumers_view.dart';
import 'package:businet_medical_center/views/widgets/datetime_picker.dart';
import 'package:businet_medical_center/views/widgets/focusable_field.dart';
import 'package:businet_medical_center/views/widgets/overlay_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// import 'package:easy_localization/easy_localization.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:keymap/keymap.dart';

import 'package:updater/updater.dart' as updater;

import '../widgets/wid5.dart';

late PaymentMethodModel paymentMethodModel;
CostumerModel? costumerModel;
double payed = 0;
double wanted = 0;
double debitWanted = 0;
double realPayed = 0;
double totalPrice = 0;
List<ReceiptPaymentMethodEntryModel> receiptPaymentMethods = [];
List<PaymentMethodModel> registeredPaymentMethods = [];

dynamic deptSellingErrorMsg;
bool? cantSellToThisCostumer;

cancelAny() {
  receiptPaymentMethods.clear();
  // receiptState = ReceiptState.onWait;
  // receiptContents.clear();
  // returnedReceiptId = 0;
  totalPrice = 0;
  payed = 0;
  wanted = 0;
  realPayed = 0;
  debitWanted = 0;
  // note = '';
  costumerModel = null;
  deptSellingErrorMsg = null;
  // paymentMethodModel = fallBackPaymentMethodModel;
  // receiptReturned = false;
  cantSellToThisCostumer = false;
  // receiptContents.clear();
  receiptPaymentMethods.clear();
  SalesPageViewUpdater().add('');
}

Future getPaymentMethod(context, ReservationModel reservation) async {
  TextEditingController valueController = TextEditingController(
    text: wanted.toString(),
  );
  void addPaymentAndExit() {
    var value = double.tryParse(
      valueController.text,
    );
    if (value == null || value == 0.0 || value.isNegative || value > wanted) {
      return;
    }
    // if(supplierM)
    receiptPaymentMethods.add(
      ReceiptPaymentMethodEntryModel(
        receiptPaymentMethods.length,
        paymentMethod: paymentMethodModel,
        value: value,
      ),
    );
    // totalPrice = 0;
    // for (var rEntry in receiptContents.values) {
    // totalPrice += reservation.total;
    // }
    payed += value;
    wanted = totalPrice - payed;
    print(
        'paymentMethodModel.postPayMethod: ${paymentMethodModel.postPayMethod}');
    if (paymentMethodModel.postPayMethod) {
      debitWanted += value;
      realPayed = payed - debitWanted;
    } else {
      // debitWanted -= value;
      realPayed = payed - debitWanted;
    }
    ReceiptUpdater().add(0);
    Navigator.pop(context, 0);
  }

  return await showDialog(
    context: context,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            height: 400,
            width: 400,
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 400,
                width: 400,
                child: Card(
                  child: FutureBuilder<List<PaymentMethodModel>>(
                    future: registeredPaymentMethods.isEmpty
                        ? PaymentMethodModel.getAll()
                        : null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                          ),
                        );
                      }
                      try {
                        registeredPaymentMethods = snapshot.data!;
                      } catch (e) {
                        //
                      }
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Expanded(
                              child: updater.UpdaterBloc(
                                updater: PaymentMethodsViewUpdater(
                                  init: 0,
                                  updateForCurrentEvent: true,
                                ),
                                update: (context, state) {
                                  return ListView.builder(
                                    controller: ScrollController(),
                                    itemCount: registeredPaymentMethods.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          paymentMethodModel =
                                              registeredPaymentMethods[index];
                                          PaymentMethodsViewUpdater().add('');
                                        },
                                        child: Wid6(
                                          paymentMethod:
                                              registeredPaymentMethods[index],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            // Navigator.pop(context,
                            //     registeredPaymentMethods[index]);
                            TextField(
                              controller: valueController,
                              onSubmitted: (text) {
                                addPaymentAndExit();
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                MaterialButton(
                                  onPressed: addPaymentAndExit,
                                  child: Text('ok'.tr),
                                ),
                                MaterialButton(
                                  child: Text('cancel'.tr),
                                  onPressed: () {
                                    Navigator.pop(context, 0);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future showReservationDialog(context, ReservationModel reservation) async {
  MedicalServiceModel? selectedMedicalService;
  return await showDialog(
    context: context,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            height: 400,
            width: 400,
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 400,
                width: 400,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('اعادة حجز موعد للمريض'),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: FocusableField(
                                serviceDescriptionController,
                                serviceDescriptionNode,
                                'الخدمة',
                                (text) {
                                  return true;
                                },
                                totalNode,
                                totalController,
                                'عذرا خانة الخدمة فارغة',
                                false,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () async {
                                var r =
                                    await medicalServiceCrudOverlay(context);
                                if (r != null) {
                                  serviceDescriptionController.text =
                                      r.description;
                                  totalController.text = r.price.toString();
                                  selectedMedicalService = r;
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: DateTimePicker(
                            controller: reservationDateTimeController,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2100),
                          ),
                        ),
                        const SizedBox(height: 48),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: MaterialButton(
                            onPressed: () async {
                              var reservationId = await ProcessesModel.stored!
                                  .requestReservationId();

                              if (selectedMedicalService == null) {
                                toast(
                                  'لا يمكنك ترك خانة نوع الفحص الطبي فارغة',
                                );
                                return;
                              }
                              ReservationModel reservationModel =
                                  selectedReservation!.copyWith(
                                reservationId,
                                dateTime: DateTime.parse(
                                  reservationDateTimeController.text,
                                ),
                                serviceType: selectedMedicalService!,
                              );
                              await reservationModel.add();
                              await ProcessesModel.stored!.edit();
                            },
                            color: Colors.black87,
                            child: const Text(
                              'حفظ',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class Wid6 extends StatelessWidget {
  const Wid6({
    Key? key,
    required this.paymentMethod,
  }) : super(key: key);
  final PaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: paymentMethod.id == paymentMethodModel.id ? Colors.black12 : null,
      child: Row(
        children: [
          Text(
            paymentMethod.id.toString(),
            textAlign: TextAlign.start,
            style: const TextStyle(
              overflow: TextOverflow.clip,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            paymentMethod.methodName.toString(),
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

bool enterWasPressedAndHasentReturned = true;

Future getBillAgree(context, ReservationModel reservation) async {
  cancelAny();
  totalPrice = selectedReservation!.total;
  // wanted = selectedReservation!.total;
  wanted = totalPrice - payed;
  enterWasPressedAndHasentReturned = true;
  // String? errorText;
  // print(costumerModel);
  TextEditingController costumerNameCont = TextEditingController(
    text: '${costumerModel?.firstname ?? ''} ${costumerModel?.lastname ?? ''}',
  );

  Future chooseCostumer() async {
    // Navigator the the comstumers view to get the costumer
    var r = await Navigator.push<CostumerModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const CostumersView(choosing: true),
      ),
    );

    /// if there is no costumer selected show a warning so the operation
    /// of selecting a costumer will not affect in the current operation
    if (r == null) {
      toast(
        'لم يتم اختيار اي عميل حتى الان',
      );
      return;
    }

    /// when the costumer is selected will be showed in the view
    costumerModel = r;
    costumerNameCont.text =
        '${costumerModel?.firstname ?? ''} ${costumerModel?.lastname ?? ''}';

    // if (realWanted == totalPrice - realPayed) {
    //   toast(
    //     'هناك خطأ يجب التبليغ عنه: المطلوب بالدين لا يساوي الاجمالي منقوصا منه المدفوع',
    //     duration: const Duration(seconds: 10),
    //   );
    //   return;
    // }
    /// Then updating the view and returning the costumer instance
    ReceiptUpdater().add(0);
    return r;
  }

  await showDialog(
    context: context,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            height: 500,
            width: 700,
            child: GestureDetector(
              onTap: () {},
              child: KeyboardWidget(
                bindings: [
                  KeyAction(
                    LogicalKeyboardKey.numpadAdd,
                    'Pay By Default',
                    () {
                      if (wanted == 0.0 ||
                          wanted.isNegative ||
                          wanted > wanted) {
                        return;
                      }
                      receiptPaymentMethods.add(
                        ReceiptPaymentMethodEntryModel(
                          receiptPaymentMethods.length,
                          paymentMethod: paymentMethodModel,
                          value: wanted,
                        ),
                      );
                      totalPrice = reservation.total;
                      // for (var rEntry in receiptContents.values) {
                      //   totalPrice += rEntry.total;}
                      payed += wanted;
                      wanted = totalPrice - payed;

                      if (paymentMethodModel.postPayMethod) {
                        debitWanted += wanted;
                        realPayed = payed - debitWanted;
                      } else {
                        realPayed = payed - debitWanted;
                        // debitPayed += wanted; debitWanted = totalPrice - payed;
                      }
                      // debitPayed += wanted; debitWanted = totalPrice - payed;
                      ReceiptUpdater().add(0);
                    },
                  ),
                  KeyAction(
                    LogicalKeyboardKey.enter,
                    '',
                    () => okOperation(context),
                  ),
                ],
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 80,
                  width: 700,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: updater.UpdaterBloc(
                        updater: ReceiptUpdater(
                          init: 0,
                          updateForCurrentEvent: true,
                        ),
                        update: (context, state) {
                          return Column(
                            children: [
                              const Text(
                                'أيصال',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                  'رقم الايصال: ${ProcessesModel.stored!.lastDialyId}'),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      height: 25,
                                      child: Wid4(),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: ListView.builder(
                                        controller: ScrollController(),
                                        itemCount: receiptPaymentMethods.length,
                                        itemBuilder: (context, index) {
                                          return Wid5(
                                            index: index,
                                            receiptPaymentMethod:
                                                receiptPaymentMethods[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'الدفع المتفق: $realPayed',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // if (receiptReturned)
                                  //   Text(
                                  //     'المرتجع المتفق: $wanted',
                                  //     style: const TextStyle(
                                  //       fontSize: 24,
                                  //       fontWeight: FontWeight.bold,
                                  //       color: Colors.grey,
                                  //     ),
                                  //   ),
                                  // if (!receiptReturned)
                                  Text(
                                    'المتبقي المتفق: $debitWanted',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'تم دفع: $payed',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // const SizedBox(width: 16),
                                  // const SizedBox(width: 16),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'المجموع: $totalPrice',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'العميل: ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        // height: 45,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            errorText: deptSellingErrorMsg,
                                          ),
                                          controller: costumerNameCont,
                                          onSubmitted: (text) async {
                                            // costumerNameCont.requestFocus();
                                            var value = int.tryParse(text);
                                            if (value == null) return;
                                            var costumer =
                                                await CostumerModel.get(value);
                                            if (costumer == null) {
                                              toast('لا يوجد عميل بهذا الرقم');
                                              await chooseCostumer();
                                              return;
                                            }
                                            // costumerNameCont.clear();
                                            costumerNameCont.text =
                                                '${costumer.firstname} ${costumer.lastname}';
                                            costumerModel = costumer;
                                            ReceiptUpdater().add(0);
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          8,
                                          0,
                                          8,
                                          0,
                                        ),
                                        child: IconButton(
                                          icon: costumerModel != null
                                              ? const Icon(Icons.close)
                                              : const Icon(Icons.search),
                                          onPressed: costumerModel != null
                                              ? () {
                                                  costumerModel = null;
                                                  deptSellingErrorMsg = null;
                                                  ReceiptUpdater().add(0);
                                                  costumerNameCont.clear();
                                                }
                                              : chooseCostumer,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(width: 16),
                                  // if (receiptReturned)
                                  //   Text(
                                  //     'المرتجع: $wanted',
                                  //     style: const TextStyle(
                                  //       fontSize: 24,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // if (!receiptReturned)
                                  Text(
                                    'المتبقي: $wanted',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // const Spacer(-),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  MaterialButton(
                                    child: Text('payment'.tr),
                                    onPressed: () async {
                                      await getPaymentMethod(
                                              context, reservation)
                                          .then((value) {
                                        ReceiptUpdater().add(0);
                                      });
                                    },
                                  ),
                                  MaterialButton(
                                    onPressed: () => okOperation(context),
                                    child: Text('ok'.tr),
                                  ),
                                  MaterialButton(
                                    child: Text('cancel'.tr),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  ).then((value) {
    enterWasPressedAndHasentReturned = false;
  }, onError: (e, s) {
    enterWasPressedAndHasentReturned = false;
  });
}

okOperation(context) async {
  try {
    if ((debitWanted + costumerModel!.totalWanted) >
        (costumerModel!.debtCeiling)) {
      deptSellingErrorMsg =
          'سقف العميل لا يعطي صلاحية اكثر من ${costumerModel!.debtCeiling}';
      cantSellToThisCostumer = true;
      toast(
        deptSellingErrorMsg.toString(),
        duration: const Duration(seconds: 3),
      );
      return;
    }
  } catch (e) {
    // print(e);
    // print(s);
    // return;
  }
  if (wanted != 0 || payed != totalPrice) {
    showSimpleNotification(
      const Text(
        'عليك اتمام الدفع اولا',
        style: TextStyle(fontSize: 20),
      ),
      position: NotificationPosition.bottom,
    );
    return;
  }
  await doneDialog(context).then(
    (success) {
      if (success == true) {
        Navigator.pop(context);
        cancelAny();
      }
    },
  );
}

bool _popPressed = true;

Future<bool?> doneDialog(context) async {
  bool success = true;
  _popPressed = false;
  submit() {
    _popPressed = true;
    SalesPageViewUpdater().add(0);
    ReceiptSegmentUpdater().add(0);
    ReceiptUpdater().add(0);
    Navigator.pop(context, success);
  }

  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: KeyboardWidget(
            bindings: [
              KeyAction(
                LogicalKeyboardKey.numpadAdd,
                'Pay By Default',
                () {
                  submit();
                },
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                color: Colors.transparent,
                height: 300,
                width: 300,
                child: GestureDetector(
                  onTap: () {},
                  child: FutureBuilder(
                    future: () async {
                      selectedReservation!.debitWanted = debitWanted;
                      selectedReservation!.realPayed = realPayed;
                      selectedReservation!.payed = payed;
                      selectedReservation!.wanted = wanted;
                      await selectedReservation!.edit();
                    }(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        print(snapshot.stackTrace);
                        success = false;
                        return SizedBox(
                          height: 300,
                          width: 300,
                          child: Card(
                            // color: Colors.white,
                            child: Column(
                              children: [
                                const Spacer(),
                                textWithButtomPad('حدث خطأ ما'),
                                const Spacer(),
                                Text(snapshot.error.toString(),
                                    textAlign: TextAlign.center),
                                const Spacer(),
                                const Icon(
                                  Icons.error,
                                  size: 100,
                                  color: Colors.yellow,
                                ),
                                const Spacer(),
                                okButton(submit),
                                const Spacer(),
                              ],
                            ),
                          ),
                        );
                      }
                      Future.delayed(const Duration(seconds: 2), () {
                        try {
                          if (_popPressed) {
                            return;
                          }
                          submit();
                        } catch (e) {
                          //
                        }
                      });
                      return SizedBox(
                        height: 300,
                        width: 300,
                        child: Card(
                          // color: Colors.white,
                          child: Column(
                            children: [
                              const Spacer(),
                              textWithButtomPad('تم بنجاح'),
                              const Spacer(),
                              const Icon(Icons.done, size: 100),
                              const Spacer(),
                              okButton(submit),
                              const Spacer(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
