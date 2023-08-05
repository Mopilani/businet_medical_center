import 'package:businet_medical_center/models/costumer_model.dart';
import 'package:businet_medical_center/models/navigator_model.dart';
import 'package:flutter/material.dart';

import 'package:updater/updater.dart' as updater;

import 'costumer_control.dart';

class CostumersView extends StatefulWidget {
  const CostumersView({
    Key? key,
    this.choosing = false,
  }) : super(key: key);

  final bool choosing;

  @override
  State<CostumersView> createState() => _CostumersViewState();
}

List<CostumerModel> _models = [];

class _CostumersViewState extends State<CostumersView> {
  @override
  Widget build(BuildContext context) {
    _models.clear();
    CostumerModel.stream().listen((data) {
      _models.add(data);
      _ViewUpdater().add('');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('العملاء'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              SysNav.push(
                context,
                const CostumerControle(),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: updater.UpdaterBloc(
        updater: _ViewUpdater(
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
              itemCount: _models.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    if (widget.choosing) {
                      Navigator.pop(
                        context,
                        _models[index],
                      );
                      return;
                    }
                    await SysNav.push(
                      context,
                      CostumerControle(
                        editMode: true,
                        model: _models[index],
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    height: 50,
                    // width: 100,
                    child: Row(
                      children: [
                        const Icon(Icons.person,
                            size: 48, color: Colors.black87),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_models[index].firstname} ${_models[index].lastname}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _models[index].firstname +
                                  _models[index].lastname,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
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

class _ViewUpdater extends updater.Updater {
  _ViewUpdater({
    initialState,
    super.updateForCurrentEvent = false,
  }) : super(initialState);
}
