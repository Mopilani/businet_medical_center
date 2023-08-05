import 'package:businet_medical_center/models/navigator_model.dart';
import 'package:businet_medical_center/models/subcatgory_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:flutter/material.dart';


import 'package:updater/updater.dart' as updater;

import 'subcategoris_control.dart';

class SubcategoriesView extends StatefulWidget {
  const SubcategoriesView({Key? key}) : super(key: key);

  @override
  State<SubcategoriesView> createState() => _SubcategoriesViewState();
}

List<SubCatgModel> models = [];

class _SubcategoriesViewState extends State<SubcategoriesView> {
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
    SystemMDBService.db.collection('subcatgs').find().listen((data) {
      print('asfa');
      models.add(SubCatgModel.fromMap(data));
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
                const SubcategoriesControle(),
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
                      SubcategoriesControle(
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
                          models[index].subcatgoryName.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          models[index].subcatgoryDescription.toString(),
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
