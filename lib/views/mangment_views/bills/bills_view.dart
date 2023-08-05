import 'package:businet_medical_center/models/bill_model.dart';
import 'package:businet_medical_center/models/navigator_model.dart';
import 'package:businet_medical_center/utils/enums.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:flutter/material.dart';

import 'package:updater/updater.dart' as updater;

import 'bills_control.dart';

class BillsView extends StatefulWidget {
  const BillsView({Key? key}) : super(key: key);

  @override
  State<BillsView> createState() => _BillsViewState();
}

List<BillModel> models = [];

class _BillsViewState extends State<BillsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    models.clear();
    BillModel.stream().listen((data) {
      // print('asfa');
      models.add((data));
      _SUpdater().add('[]');
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () async {
              await SystemMDBService.db.collection('bills').drop();
              setState(() {});
              return;
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: () {
          //     SysNav.push(
          //       context,
          //       const CategoriesControle(),
          //     );
          //   },
          // ),
          const SizedBox(width: 16),
        ],
      ),
      body: updater.UpdaterBloc(
        updater: _SUpdater(
          updateForCurrentEvent: true,
        ),
        update: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: 1,
              //   childAspectRatio: 8.0,
              // ),
              controller: ScrollController(),
              itemCount: models.length,
              itemBuilder: (context, index) {
                var model = models[index];
                return InkWell(
                  onTap: () async {
                    await SysNav.push(
                      context,
                      BillsControle(
                        editMode: true,
                        model: model,
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    height: 50,
                    // width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${model.id}: ${model.createDate}   |   ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              '${model.supplierModel.name}  -  ${model.stockModel.title}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const Spacer(),
                            Text(
                              '${billTypeTranslations[model.billType]}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (() {
                                switch (model.billState) {
                                  case BillState.payed:
                                    return const Icon(
                                      Icons.circle,
                                      color: Colors.green,
                                    );
                                  case BillState.onWait:
                                    return const Icon(
                                      Icons.access_time_filled_rounded,
                                      color: Color.fromARGB(255, 216, 201, 67),
                                    );
                                  case BillState.returned:
                                    return const Icon(
                                      Icons.access_time_filled_rounded,
                                    );
                                  case BillState.canceled:
                                    return const Icon(
                                      Icons.access_time_filled_rounded,
                                    );
                                  case BillState.partialPay:
                                    return const Icon(
                                      Icons.payments,
                                      color: Colors.greenAccent,
                                    );
                                  default:
                                    return const Icon(
                                      Icons.radio_button_unchecked_outlined,
                                    );
                                }
                              }()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
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
          return Center(
            child: FutureBuilder(
              future: Future.delayed(
                const Duration(seconds: 1),
                () => 'No Data Found',
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == 'No Data Found') {
                    return const Center(
                      child: Text('لا يوجد فواتير تم حفظها بعد'),
                    );
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          );
        },
      ),
    );
  }
}

class _SUpdater extends updater.Updater {
  _SUpdater({
    initialState,
    super.updateForCurrentEvent = false,
  }) : super(initialState);
}

Map<BillType, String> billTypeTranslations = <BillType, String>{
  BillType.goodsReceived: 'فاتورة استلام بضاعة',
  BillType.purchaseOrder: 'فاتورة شراء',
  BillType.sellOrder: 'فاتورة بيع',
};
