import 'package:businet_medical_center/models/navigator_model.dart';
import 'package:businet_medical_center/models/stock_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:flutter/material.dart';

import 'package:updater/updater.dart' as updater;

import 'stocks_control.dart';

class StocksView extends StatefulWidget {
  const StocksView({Key? key, this.choosing = false}) : super(key: key);
  final bool choosing;
  @override
  State<StocksView> createState() => _StockViewState();
}

List<StockModel> models = [];

class _StockViewState extends State<StocksView> {
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
    SystemMDBService.db.collection('stocks').find().listen((data) {
      models.add(StockModel.fromMap(data));
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
                const StocksControle(),
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
                    if (widget.choosing) {
                      Navigator.pop(context, models[index]);
                      return;
                    }
                    await SysNav.push(
                      context,
                      StocksControle(
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
                          models[index].title.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          models[index].state.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
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
