import 'package:businet_medical_center/models/lab/analysis_sample_unit_model.dart';
import 'package:businet_medical_center/utils/updaters.dart';
import 'package:businet_medical_center/views/widgets/focusable_field.dart';
import 'package:flutter/material.dart';
import 'package:updater/updater.dart' as updater;

class LabAnalysisSampleUnitView extends StatefulWidget {
  const LabAnalysisSampleUnitView({Key? key}) : super(key: key);

  @override
  State<LabAnalysisSampleUnitView> createState() => _AnalysisGroupViewState();
}

class _AnalysisGroupViewState extends State<LabAnalysisSampleUnitView> {
  List<AnalysisSampleUnitModel> models = [];
  TextEditingController titleController = TextEditingController();
  AnalysisSampleUnitModel? selectedModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الوحدات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            updater.UpdaterBlocWithoutDisposer(
              updater: ThisPageUpdater(
                init: '',
                updateForCurrentEvent: true,
              ),
              update: (context, s) {
                return Expanded(
                  child: FutureBuilder<List<AnalysisSampleUnitModel>>(
                    future: AnalysisSampleUnitModel.getAll(),
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
                                titleController.text = model.description;
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
                          titleController,
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
                              : () {
                                  selectedModel!.deleteWithMID();
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
                                  selectedModel!.description = titleController.text;
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
                            if (titleController.text.isEmpty) {
                              return;
                            }
                            await AnalysisSampleUnitModel(
                              0,
                              description: titleController.text,
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