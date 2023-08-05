import 'package:businet_medical_center/models/bill_model.dart';
import 'package:businet_medical_center/models/processes_model.dart';
import 'package:businet_medical_center/models/receipt_and_bill_payment_method_entry_model.dart';
import 'package:businet_medical_center/models/system_config.dart';
import 'package:businet_medical_center/utils/enums.dart';
import 'package:businet_medical_center/utils/updaters.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:updater/updater.dart' as updater;
import '../../../models/payment_method_model.dart';
import 'bills_control.dart';
import 'bills_control_page_view_model.dart';

Future<bool?> loadingOver(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const CircularProgressIndicator(),
        ),
      );
    },
  );
}

Future<bool?> askBeforImportingToBillStock(BuildContext context) async {
  // TextEditingController noteController = TextEditingController(text: note);
  submit([tx]) {
    Navigator.pop(context, tx);
  }

  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            height: 200,
            width: 300,
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 200,
                width: 300,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        textWithButtomPad(
                            'هل انت متأكد من استيراد البضاعة الى المخزن'),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            okButton(() => submit(true)),
                            MaterialButton(
                              child: Text('cancel'.tr),
                              onPressed: () => submit(false),
                            ),
                          ],
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

Future<void> writeNoteDialog(
    BuildContext context, TextEditingController noteController) async {
  // TextEditingController noteController = TextEditingController(text: note);
  submit([tx]) {
    Navigator.pop(context);
  }

  await showDialog(
    context: context,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            height: 500,
            width: 600,
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 500,
                width: 600,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        textWithButtomPad('اضافة ملاحظة لهذا الايصال'),
                        SizedBox(
                          width: 500,
                          height: 390,
                          child: TextField(
                            autofocus: true,
                            onSubmitted: submit,
                            controller: noteController,
                            expands: true,
                            decoration: const InputDecoration(
                              fillColor: Colors.black12,
                              filled: true,
                            ),
                            maxLines: null,
                            minLines: null,
                          ),
                        ),
                        const SizedBox(),
                        okButton(submit),
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

bool _popPressed = true;

Future doneDialog(context) async {
  _popPressed = false;
  submit() {
    _popPressed = true;
    BillControleViewUpdater().add(0);
    BillUpdater().add(0);
    Navigator.pop(context);
  }

  await showDialog(
    context: context,
    builder: (context) {
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
                    future: saveBill(),
                    builder: (context, snapshot) {
                      return SizedBox(
                        height: 300,
                        width: 300,
                        child: Card(
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

class BillPaymentMethodEntryWidget extends StatelessWidget {
  const BillPaymentMethodEntryWidget({
    Key? key,
    required this.billPaymentMethod,
    required this.index,
  }) : super(key: key);
  final BillPaymentMethodEntryModel billPaymentMethod;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {},
      onLongPress: () {
        BillPageViewModel().totalPayed -= billPaymentMethod.value;
        BillPageViewModel().totalWanted += billPaymentMethod.value;
        BillPageViewModel().billPaymentMethods.removeAt(index);
        BillUpdater().add(0);
      },
      borderRadius: BorderRadius.circular(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              billPaymentMethod.paymentMethod.methodName.toString() +
                  (billPaymentMethod.paymentMethod.currency),
              textAlign: TextAlign.start,
              style:  const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const VerticalDivider(),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {},
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 50),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: Text(
                        billPaymentMethod.value.toString(),
                        textAlign: TextAlign.start,
                        style:  const TextStyle(
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       const VerticalDivider(),
          //       InkWell(
          //         borderRadius: BorderRadius.circular(15),
          //         onTap: () {},
          //         child: ConstrainedBox(
          //           constraints: const BoxConstraints(minWidth: 30),
          //           child: Padding(
          //             padding: const EdgeInsets.only(left: 4, right: 4),
          //             child: Text(
          //               receiptEntry.quantity.toString(),
          //               textAlign: TextAlign.start,
          //               style:  TextStyle(
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Expanded(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       const VerticalDivider(),
          //       Text(
          //         receiptEntry.total.toString(),
          //         textAlign: TextAlign.start,
          //         style:  TextStyle(
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

Future getBillAgree(context, [bool viewMode = false]) async {
  BillPageViewModel().totalWanted =
      BillPageViewModel().totalCost - BillPageViewModel().totalPayed;
  BillPageViewModel().enterWasPressedAndHasentReturned = true;
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
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 80,
                width: 700,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: updater.UpdaterBloc(
                      updater: BillUpdater(
                        init: 0,
                        updateForCurrentEvent: true,
                      ),
                      update: (context, state) {
                        return Column(
                          children: [
                             const Text(
                              'فاتورة أمر شراء بضاعة',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                                'رقم الفاتورة: ${ProcessesModel.stored!.lastBillId}'),
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
                                      itemCount: BillPageViewModel()
                                          .billPaymentMethods
                                          .length,
                                      itemBuilder: (context, index) {
                                        return BillPaymentMethodEntryWidget(
                                          index: index,
                                          billPaymentMethod: BillPageViewModel()
                                              .billPaymentMethods[index],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 32,
                                right: 32,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'تم دفع: ${BillPageViewModel().totalPayed}',
                                    style:  const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // if ()
                                  //   Text(
                                  //     'المرتجع: ${BillPageViewModel().totalWanted}',
                                  //     style:  TextStyle(
                                  //       fontSize: 24,
                                  //       fontWeight: FontWeight.bold,
                                  //     ), ), if (!receiptReturned)
                                  Text(
                                    'المطلوب: ${BillPageViewModel().totalWanted}',
                                    style:  const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  const SizedBox(width: 16),
                                  Text(
                                    'المورد: ${BillPageViewModel().supplierModel.name}',
                                    style:  const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'المجموع: ${BillPageViewModel().totalCost}',
                              style:  const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                MaterialButton(
                                  onPressed: viewMode
                                      ? null
                                      : () async {
                                          await getPaymentMethod(context)
                                              .then((value) {
                                            BillUpdater().add(0);
                                            BillControleViewUpdater().add(0);
                                          });
                                        },
                                  child: Text('payment'.tr),
                                ),
                                MaterialButton(
                                  onPressed: viewMode
                                      ? null
                                      : () async {
                                          // print(BillPageViewModel().totalWanted);
                                          // print(BillPageViewModel().totalPayed ==
                                          //     BillPageViewModel().totalCost);
                                          if (BillPageViewModel().totalWanted ==
                                                  0 &&
                                              BillPageViewModel().totalPayed ==
                                                  BillPageViewModel()
                                                      .totalCost) {
                                          } else {
                                            showSimpleNotification(
                                               const Text(
                                                'عليك اتمام الدفع اولا',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              position:
                                                  NotificationPosition.bottom,
                                            );
                                            return;
                                          }
                                          Navigator.pop(context);

                                          // await doneDialo g(context).then(
                                          //   (value) {
                                          //     Navigator.pop(context);
                                          //     // cancelAny();
                                          //   },
                                          // );
                                        },
                                  child:  const Text('ok'),
                                ),
                                MaterialButton(
                                  child:  const Text('cancel'),
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
      );
    },
  ).then((value) {
    BillPageViewModel().enterWasPressedAndHasentReturned = false;
  }, onError: (e, s) {
    BillPageViewModel().enterWasPressedAndHasentReturned = false;
  });
}

// ignore: must_be_immutable
class BillEntryWidget extends StatelessWidget {
  BillEntryWidget({
    Key? key,
    required this.billEntry,
    required this.index,
  }) : super(key: key);
  final BillEntryModel billEntry;
  final int index;
  BillEntryModel? selectedBillEntry = BillPageViewModel().selectedBillEntry;

  Widget textar(
    String text,
    double minWidth, [
    double? width,
    int? flex,
    bool vd = true,
  ]) {
    var widget = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const VerticalDivider(),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth),
          child: Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Text(
              text,
              textAlign: TextAlign.start,
              style:  const TextStyle(
                overflow: TextOverflow.clip,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
    if (flex != null) {
      return Expanded(flex: flex, child: widget);
    } else {
      return SizedBox(width: width, child: widget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BillPageViewModel().selectedBillEntry = billEntry;
        BillPageViewModel().skuSearchController.text =
            billEntry.skuModel.id.toString();
        BillPageViewModel().skuCostPriceController.text =
            billEntry.skuModel.costPrice.toString();
        BillPageViewModel().skuMaxPriceController.text =
            billEntry.skuModel.highestPrice.toString();
        BillPageViewModel().skuSalePriceController.text =
            billEntry.skuModel.salePrice.toString();
        BillPageViewModel().skuTaxController.text = billEntry.tax.toString();
        BillPageViewModel().skuDiscController.text = billEntry.disc.toString();
        try {
          BillPageViewModel().expierMonthController.text =
              billEntry.expierDate.split('-').first;
        } catch (e) {
          //
        }
        try {
          BillPageViewModel().expierYearController.text =
              billEntry.expierDate.split('-').last;
        } catch (e) {
          //
        }
        BillPageViewModel().skuQuantityController.text =
            (billEntry.quantity / billEntry.containSize!).toString();
        BillPageViewModel().currentSaleUnitDropDownValue =
            billEntry.saleunit.id;
        BillPageViewModel().saleUnitModel = billEntry.saleunit;
        // print(billEntry.saleunit.id);
        // print(billEntry.containSize);
        BillPageViewModel().containSizeController.text =
            (billEntry.containSize ?? '0.0').toString();
        BillPageViewModel().skuFreeQUantityController.text =
            billEntry.freeQuantity.toString();
        BillPageViewModel().skuNoteController.text = billEntry.note;
        BillPageViewModel().foundSKU = billEntry.skuModel;
        // if (billEntry.saleunit.containsUnknownQuantity == true) {
        //   if (billEntry.containSize != null) { if (billEntry.quantity ==
        //         ((billEntry.quantity / billEntry.containSize!.toDouble()) *
        // billEntry.containSize!.toDouble())) {} else {  billEntry.quantity =
        //           billEntry.quantity * billEntry.containSize!.toDouble();}}}
        BillControleViewUpdater().add('');
      },
      borderRadius: BorderRadius.circular(2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: selectedBillEntry?.skuModel.id == billEntry.skuModel.id
              ? SystemConfig().theme == 'light'
                  ? Colors.black26
                  : Colors.grey
              : index.isEven
                  ? SystemConfig().theme == 'light'
                      ? Colors.blue[50]
                      : Colors.blue.withOpacity(0.4)
                  : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            textar(
                billEntry.skuModel.description.toString(), 50, null, 2, false),
            textar(billEntry.skuModel.costPrice.toString(), 50, 100, 1),
            BillPageViewModel().selectedBillType == BillType.goodsReceived
                ? const SizedBox()
                : textar(
                    billEntry.skuModel.highestPrice.toString(), 50, 100, 1),
            textar(billEntry.skuModel.salePrice.toString(), 50, 100, 1),
            textar(billEntry.quantity.toString(), 30, 100),
            BillPageViewModel().selectedBillType == BillType.goodsReceived
                ? textar(billEntry.freeQuantity.toString(), 30, 120)
                : const SizedBox(),
            BillPageViewModel().selectedBillType == BillType.goodsReceived
                ? textar(billEntry.expierDate.toString(), 30, 100)
                : const SizedBox(),
            BillPageViewModel().selectedBillType == BillType.goodsReceived
                ? textar(billEntry.disc.toString(), 30, 100)
                : const SizedBox(),
            BillPageViewModel().selectedBillType == BillType.goodsReceived
                ? textar(billEntry.tax.toString(), 30, 100)
                : const SizedBox(),
            textar(billEntry.total.toString(), 30, 100, 1),
          ],
        ),
      ),
    );
  }
}

changePrice(context, [entry]) {
  if (entry != null) BillPageViewModel().selectedBillEntry = entry;
  if (BillPageViewModel().selectedBillEntry == null) return;
  if (BillPageViewModel().selectedBillEntry!.skuModel.openRate) {
    TextEditingController numberController = TextEditingController(
        text: BillPageViewModel()
            .selectedBillEntry!
            .skuModel
            .salePrice
            .toString());
    submit([tx]) {
      var value = double.tryParse(numberController.text);
      if (value == null) {
        toast('القيمة التي ادخلتها غير صحيحة');
        return;
      }
      if (value <= 0.0) {
        toast('القيمة التي ادخلتها اصغر من 1');
        return;
      }
      if (BillPageViewModel().selectedBillEntry != null) {
        if (value <
            BillPageViewModel().selectedBillEntry!.skuModel.lowestPrice) {
          toast('القيمة التي ادخلتها اصغر من اقل سعر بيع');
          return;
        }
        BillPageViewModel().selectedBillEntry!.skuModel.salePrice = value;
        BillPageViewModel().selectedBillEntry!.total =
            BillPageViewModel().selectedBillEntry!.quantity *
                BillPageViewModel().selectedBillEntry!.skuModel.salePrice;
      }
      BillPageViewModel().totalCost = 0;
      for (var rEntry in BillPageViewModel().billEntries.values) {
        BillPageViewModel().totalCost += rEntry.total;
      }
      BillControleViewUpdater().add('');
      Navigator.pop(context);
    }

    showDialog(
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
              height: 300,
              width: 300,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 300,
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          textWithButtomPad('تعديل السعر'),
                          TextField(
                            autofocus: true,
                            onSubmitted: submit,
                            controller: numberController,
                          ),
                          const Spacer(),
                          okButton(submit),
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
}

changeQuantity(context, [entry]) {
  if (entry != null) BillPageViewModel().selectedBillEntry = entry;
  if (BillPageViewModel().selectedBillEntry == null) return;
  TextEditingController numberController = TextEditingController(
      text: BillPageViewModel().selectedBillEntry!.quantity.toString());
  submit([tx]) {
    var value = double.tryParse(numberController.text);
    if (value == null) {
      toast('القيمة التي ادخلتها غير صحيحة');
      return;
    }
    if (value <= 0.0) {
      toast('القيمة التي ادخلتها اصغر من 1');
      return;
    }
    if (BillPageViewModel().selectedBillEntry != null) {
      BillPageViewModel().selectedBillEntry!.quantity = value;
      BillPageViewModel().selectedBillEntry!.total =
          BillPageViewModel().selectedBillEntry!.quantity *
              BillPageViewModel().selectedBillEntry!.skuModel.salePrice;
    }
    BillPageViewModel().totalCost = 0;
    for (var rEntry in BillPageViewModel().billEntries.values) {
      BillPageViewModel().totalCost += rEntry.total;
    }
    BillControleViewUpdater().add('');
    Navigator.pop(context);
  }

  showDialog(
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
            height: 300,
            width: 300,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 300,
                width: 300,
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        textWithButtomPad('تعديل الكمية'),
                        TextField(
                          autofocus: true,
                          onSubmitted: submit,
                          controller: numberController,
                        ),
                        const Spacer(),
                        okButton(submit),
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

Widget okButton(void Function() function) {
  return MaterialButton(
    onPressed: function,
    child:  Text(
      'ok'.tr,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget textWithButtomPad(String text) {
  return Column(
    children: [
      Text(
        text.tr,
        style:  const TextStyle(
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 32),
    ],
  );
}

Future getPaymentMethod(context) async {
  TextEditingController valueController = TextEditingController(
    text: BillPageViewModel().totalWanted.toString(),
  );
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
                  color: Colors.white,
                  child: FutureBuilder<List<PaymentMethodModel>>(
                    future: BillPageViewModel().registeredPaymentMethods.isEmpty
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
                        BillPageViewModel().registeredPaymentMethods =
                            snapshot.data!;
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
                                    itemCount: BillPageViewModel()
                                        .registeredPaymentMethods
                                        .length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          BillPageViewModel()
                                                  .selectedPaymentMethod =
                                              BillPageViewModel()
                                                      .registeredPaymentMethods[
                                                  index];
                                          PaymentMethodsViewUpdater().add('');
                                        },
                                        child: BillPaymentMethodWidget(
                                          paymentMethod: BillPageViewModel()
                                              .registeredPaymentMethods[index],
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
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                MaterialButton(
                                  child:  const Text('ok'),
                                  onPressed: () {
                                    var value = double.tryParse(
                                      valueController.text,
                                    );
                                    if (value == null ||
                                        value == 0.0 ||
                                        value.isNegative ||
                                        value >
                                            BillPageViewModel().totalWanted) {
                                      return;
                                    }
                                    BillPageViewModel().billPaymentMethods.add(
                                          BillPaymentMethodEntryModel(
                                            BillPageViewModel()
                                                .billPaymentMethods
                                                .length,
                                            paymentMethod: BillPageViewModel()
                                                .selectedPaymentMethod!,
                                            value: value,
                                          ),
                                        );
                                    // BillPageViewModel().totalCost = 0;
                                    // for (var rEntry in BillPageViewModel()
                                    //     .billEntries
                                    //     .values) {
                                    //   BillPageViewModel().totalCost +=
                                    //       rEntry.total;
                                    // }
                                    BillPageViewModel().totalPayed += value;
                                    // print(BillPageViewModel().totalPayed);
                                    // BillPageViewModel().totalWanted =
                                    //     BillPageViewModel().totalCost -
                                    //         BillPageViewModel().totalPayed;
                                    resumTotals();
                                    BillUpdater().add(0);
                                    Navigator.pop(context, 0);
                                  },
                                ),
                                MaterialButton(
                                  child:  const Text('cancel'),
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

BillModel createInstance() {
  if (BillPageViewModel().totalWanted == 0) {
    BillPageViewModel().billState = BillState.payed;
  }

  return BillModel(
    BillPageViewModel().id,
    billType: BillPageViewModel().selectedBillType,
    note: BillPageViewModel().note,
    payed: BillPageViewModel().totalPayed,
    wanted: BillPageViewModel().totalWanted,
    total: BillPageViewModel().totalCost,
    stockModel: BillPageViewModel().stockModel,
    createDate: BillPageViewModel().createDate,
    billState: BillPageViewModel().billState,
    userModel: BillPageViewModel().userModel,
    billEntries: BillPageViewModel().billEntries,
    pointOfSaleModel: BillPageViewModel().pointOfSaleModel,
    billPaymentMethods: BillPageViewModel().billPaymentMethods,
    incomingDate: BillPageViewModel().incomingDate,
    quantity: BillPageViewModel().totalQuantity,
    supplierModel: BillPageViewModel().supplierModel,
    deliveryModel: BillPageViewModel().deliveryModel,
    wasImported: BillPageViewModel().wasImportedToStock,
  );
}

Future saveBill([
  BillModel? billModel,
  bool editMode = false,
  BillType? billType,
]) async {
  BillModel bill = billModel ?? createInstance();
  if (editMode) {
    if (billType == BillType.purchaseOrder &&
        bill.billType == BillType.goodsReceived) {
      await bill.add();
    } else {
      await bill.edit();
    }
  } else {
    await bill.add();
  }
}

void bill(context) {
  // print('enter==');
  if (BillPageViewModel().enterWasPressedAndHasentReturned) {
    return;
  }
  if (BillPageViewModel().totalCost == 0) {
    return;
  }
  getBillAgree(context);
}

class BillEnteriesHeader extends StatelessWidget {
  const BillEnteriesHeader({Key? key}) : super(key: key);

  Widget textar(
    String text,
    double minWidth, [
    double? width,
    int? flex,
    bool vd = true,
  ]) {
    var widget = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        vd ? const VerticalDivider() : const SizedBox(),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth),
          child: Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Text(
              text,
              textAlign: TextAlign.start,
              style:  const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
    if (flex != null) {
      return Expanded(flex: flex, child: widget);
    } else {
      return SizedBox(width: width, child: widget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          textar('description', 50, null, 2, false),
          textar('cost_price', 50, 100, 1),
          BillPageViewModel().selectedBillType == BillType.goodsReceived
              ? const SizedBox()
              : textar('max_price', 50, 100, 1),
          textar('sale_price', 50, 100, 1),
          textar('quantity', 30, 100),
          BillPageViewModel().selectedBillType == BillType.goodsReceived
              ? textar('free_quantity', 30, 120)
              : const SizedBox(),
          BillPageViewModel().selectedBillType == BillType.goodsReceived
              ? textar('تاريخ الانتهاء', 30, 100)
              : const SizedBox(),
          BillPageViewModel().selectedBillType == BillType.goodsReceived
              ? textar('discount', 30, 100)
              : const SizedBox(),
          BillPageViewModel().selectedBillType == BillType.goodsReceived
              ? textar('tax', 30, 100)
              : const SizedBox(),
          textar('value', 30, 100, 1),
        ],
      ),
    );
  }
}

class BillPaymentMethodWidget extends StatelessWidget {
  const BillPaymentMethodWidget({
    Key? key,
    required this.paymentMethod,
  }) : super(key: key);
  final PaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: paymentMethod.id == BillPageViewModel().selectedPaymentMethod?.id
          ? Colors.black12
          : null,
      child: Row(
        children: [
          Text(
            paymentMethod.id.toString(),
            textAlign: TextAlign.start,
            style:  const TextStyle(
              overflow: TextOverflow.clip,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            paymentMethod.methodName.toString(),
            textAlign: TextAlign.start,
            style:  const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class Wid4 extends StatelessWidget {
  const Wid4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'via'.tr,
              textAlign: TextAlign.start,
              style:  const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const VerticalDivider(),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {},
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 50),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: Text(
                        'value'.tr,
                        textAlign: TextAlign.start,
                        style:  const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
