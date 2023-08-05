import 'package:businet_medical_center/models/checkups_group_model.dart';
import 'package:businet_medical_center/models/checkups_model.dart';
import 'package:businet_medical_center/utils/updaters.dart';
import 'package:businet_medical_center/views/widgets/focusable_field.dart';
import 'package:flutter/material.dart';
import 'package:updater/updater.dart' as updater;

class CheckupsListView extends StatefulWidget {
  const CheckupsListView({Key? key}) : super(key: key);

  @override
  State<CheckupsListView> createState() => _CheckupsListViewState();
}

class _CheckupsListViewState extends State<CheckupsListView> {
  List<CheckupsModel> models = [];
  List<CheckupsGroupModel> groups = [];
  TextEditingController descriptionController = TextEditingController();
  CheckupsGroupModel? selectedAnalysisGroup;
  String? selectedAnalysisGroupTitle;
  CheckupsModel? selectedModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفحوصات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder(
              future: CheckupsGroupModel.getAll().then((value) {
                groups.clear();
                groups.addAll(value);
                ThisPageSecondUpdater().add('');
              }),
              builder: (context, s) => const SizedBox(),
            ),
            updater.UpdaterBlocWithoutDisposer(
              updater: ThisPageUpdater(
                init: '',
                updateForCurrentEvent: true,
              ),
              update: (context, s) {
                return Expanded(
                  child: FutureBuilder<List<CheckupsModel>>(
                    future: CheckupsModel.getAll(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'عذرا حدث خطأ ما: ${snapshot.error}',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        models = (snapshot.data!);
                        return ListView.builder(
                          itemCount: models.length,
                          itemBuilder: (context, index) {
                            var model = models[index];
                            return InkWell(
                              onTap: () {
                                selectedModel = model;
                                descriptionController.text = model.description;
                                selectedAnalysisGroup = model.analysisGroup;
                                selectedAnalysisGroupTitle =
                                    model.analysisGroup.title;
                                ThisPageSecondUpdater().add('');
                              },
                              child: Card(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  child: Text(model.description),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return const Center(
                          child: Text(
                            'لا يوجد بيانات لعرضها',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
            updater.UpdaterBlocWithoutDisposer(
              updater: ThisPageSecondUpdater(
                init: '',
                updateForCurrentEvent: true,
              ),
              update: (context, s) {
                return SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: FocusableField(
                          descriptionController,
                          FocusNode(),
                          '',
                          (text) {
                            return true;
                          },
                          null,
                          null,
                          null,
                          false,
                        ),
                      ),
                      DropdownButton<String>(
                        items: groups.map((e) {
                          return DropdownMenuItem<String>(
                            value: e.title,
                            child: Text(e.title),
                            onTap: () {
                              selectedAnalysisGroup = e;
                            },
                          );
                        }).toList(),
                        value: selectedAnalysisGroupTitle,
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          selectedAnalysisGroupTitle = value;
                          ThisPageSecondUpdater().add('');
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 50,
                          color: Colors.black87,
                          onPressed: selectedModel == null
                              ? null
                              : () async {
                                  await selectedModel!.deleteWithMID();
                                  selectedModel = null;
                                  ThisPageUpdater().add('');
                                  ThisPageSecondUpdater().add('');
                                },
                          child: const Text('حذف'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 50,
                          color: Colors.black87,
                          onPressed: selectedModel == null
                              ? null
                              : () async {
                                  selectedModel!.description =
                                      descriptionController.text;
                                  selectedModel!.analysisGroup =
                                      selectedAnalysisGroup!;
                                  print(selectedModel!.analysisGroup.title);
                                  await selectedModel!.edit();
                                  ThisPageUpdater().add('');
                                  ThisPageSecondUpdater().add('');
                                },
                          child: const Text('تعديل'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 50,
                          minWidth: 120,
                          color: Colors.black87,
                          onPressed: () async {
                            // var analysisGroupId = ProcessesModel.stored!.requestAnalysisGroupId();
                            if (descriptionController.text.isEmpty) {
                              return;
                            }
                            if (selectedAnalysisGroup == null) {
                              return;
                            }
                            await CheckupsModel(
                              0,
                              description: descriptionController.text,
                              analysisGroup: selectedAnalysisGroup!,
                            ).add();
                            ThisPageUpdater().add(0);
                            ThisPageSecondUpdater().add('');
                          },
                          child: const Text('اضافة'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('مجموعات التحاليل'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: FutureBuilder(
//                 future: CheckupsGroupModel.getAll(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text(
//                         'عذرا حدث خطأ ما: ${snapshot.error}',
//                         style: const TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                     );
//                   }
//                   if (snapshot.hasData) {
//                     return Column(
//                       children: [],
//                     );
//                   }
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else {
//                     return const Center(
//                       child: Text('لا يوجد بيانات لعرضها'),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
