import 'package:businet_medical_center/models/navigator_model.dart';
import 'package:businet_medical_center/models/payment_method_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:businet_medical_center/views/settings/payment_methods_views/payment_method_control.dart';
import 'package:flutter/material.dart';

import 'package:updater/updater.dart' as updater;

class PaymentMethodsView extends StatefulWidget {
  const PaymentMethodsView({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsView> createState() => _PaymentMethodsViewState();
}

List<PaymentMethodModel> models = [];

class _PaymentMethodsViewState extends State<PaymentMethodsView> {
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
    SystemMDBService.db.collection('PayMethods').find().listen((data) async {
      var model = PaymentMethodModel.fromMap(data);
      models.add(model);
      // model.postPayMethod = false;
      // await model.edit();
      _SUpdater().add('');
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              SysNav.push(
                context,
                const PaymentMethodControle(),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: updater.UpdaterBloc(
        updater: _SUpdater(
          updateForCurrentEvent: true,
        ),
        update: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 8.0,
              ),
              controller: ScrollController(),
              itemCount: models.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    await SysNav.push(
                      context,
                      PaymentMethodControle(
                        editMode: true,
                        model: models[index],
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
                        Text(
                          models[index].methodName.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          // models[index].currency == true
                          //     ? 'كمية غير محددة'
                          //     :
                          models[index].currency.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              // children: [],
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
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
