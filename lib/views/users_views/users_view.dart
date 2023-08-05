import 'package:businet_medical_center/models/navigator_model.dart';
import 'package:businet_medical_center/models/user_model.dart';
import 'package:flutter/material.dart';

import 'package:updater/updater.dart' as updater;

import 'users_control.dart';

class UsersView extends StatefulWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState();
}

List<UserModel> models = [];

class _UsersViewState extends State<UsersView> {
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
    UserModel.stream().listen((data) {
      models.add(data);
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
                const UsersControle(),
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
                      UsersControle(
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
                    child: Row(
                      children: [
                        const Icon(Icons.person,
                            size: 48, color: Colors.black87),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${models[index].firstname} ${models[index].lastname}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              models[index].username,
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

class _SUpdater extends updater.Updater {
  _SUpdater({
    initialState,
    super.updateForCurrentEvent = false,
  }) : super(initialState);
}
