import 'dart:io';

import 'package:businet_medical_center/models/analysis_group_model.dart';
import 'package:businet_medical_center/models/analysis_model.dart';
import 'package:businet_medical_center/models/analysis_result_model.dart';
import 'package:businet_medical_center/models/checkups_group_model.dart';
import 'package:businet_medical_center/models/checkups_model.dart';
import 'package:businet_medical_center/models/dosing_model.dart';
import 'package:businet_medical_center/models/examination_page_settings_model.dart';
import 'package:businet_medical_center/models/instruction_model.dart';
import 'package:businet_medical_center/models/organ_model.dart';
import 'package:businet_medical_center/models/patient_model.dart';
import 'package:businet_medical_center/models/pharmaceutical_group_model.dart';
import 'package:businet_medical_center/models/pharmaceutical_model.dart';
import 'package:businet_medical_center/models/reservation_model.dart';
import 'package:businet_medical_center/utils/updaters.dart';
import 'package:businet_medical_center/views/reservation/flying_widgets.dart';
import 'package:businet_medical_center/views/reservation/reservation.dart';
import 'package:businet_medical_center/views/widgets/2_tabs_bar.dart';
import 'package:businet_medical_center/views/widgets/datetime_picker.dart';
import 'package:businet_medical_center/views/widgets/focusable_field.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:updater/updater.dart' as updater;

class ExaminationPage extends StatefulWidget {
  const ExaminationPage({
    Key? key,
    required this.reservation,
  }) : super(key: key);
  final ReservationModel? reservation;

  @override
  State<ExaminationPage> createState() => _ExaminationPageState();
}

class _ExaminationPageState extends State<ExaminationPage>
    with SingleTickerProviderStateMixin {
  // TabController tabController = TabController(
  //   vsync: this, length: 7,
  // );

  @override
  void initState() {
    super.initState();
    // print(widget.reservation);
    generalCheckBoardControllers.addAll({
      'property1': property1,
      'property2': property2,
      'property3': property3,
      'property4': property4,
      'property5': property5,
      'property6': property6,
      'property7': property7,
      'property8': property8,
      'property10': property10,
      'property11': property11,
      'property12': property12,
      'property13': property13,
      'property14': property14,
    });
    if (widget.reservation!.generalCheckSegmentSettings != null) {
      generalCheckSegmentSettings =
          widget.reservation!.generalCheckSegmentSettings!;
      generalCheckBoardControllers.forEach((key, cont) {
        cont.text = generalCheckSegmentSettings['values'][key];
      });
    }
    if (widget.reservation!.wantedAnalysis != null) {
      wantedAnalysis = widget.reservation!.wantedAnalysis!;
    }
    if (widget.reservation!.wantedCheckups != null) {
      wantedCheckups = widget.reservation!.wantedCheckups!;
    }
    if (widget.reservation!.wantedPharmaceuticals != null) {
      wantedPharmaceuticals = widget.reservation!.wantedPharmaceuticals!;
    }
    if (widget.reservation!.instructions != null) {
      instructions = widget.reservation!.instructions!;
    }
    if (widget.reservation!.analysisResults != null) {
      analysisResults = widget.reservation!.analysisResults!;
    }
    if (widget.reservation!.documentsFiles != null) {
      documentsFiles = widget.reservation!.documentsFiles!;
    }

    AnalysisGroupModel.getAll()
        .then(
          (value) => analysisGroups.addAll(value),
        )
        .asStream();
    AnalysisModel.getAll()
        .then(
          (value) => allAnalysis.addAll(value),
        )
        .asStream();
    CheckupsGroupModel.getAll()
        .then(
          (value) => checkupsGroups.addAll(value),
        )
        .asStream();
    CheckupsModel.getAll()
        .then(
          (value) => allCheckups.addAll(value),
        )
        .asStream();
    PharmaceuticalGroupModel.getAll()
        .then(
          (value) => pharmaceuticalsGroups.addAll(value),
        )
        .asStream();
    PharmaceuticalModel.getAll()
        .then(
          (value) => allPharmaceuticals.addAll(value),
        )
        .asStream();
    DoseModel.getAll()
        .then(
          (value) => allDosing.addAll(value),
        )
        .asStream();
    OrganModel.getAll()
        .then(
          (value) => allOrgans.addAll(value),
        )
        .asStream();
    InstructionModel.getAll()
        .then(
          (value) => allInstructions.addAll(value),
        )
        .asStream();
    var value =
        ExaminationPageSettingsModel.stored!.generalCheckSegmentSettings;
    generalCheckSegmentSettings.addAll(value);
  }

  Map<String, dynamic> generalCheckSegmentSettings = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                const Text(
                  'بيانات المريض',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: MaterialButton(
                    onPressed: selectedReservation == null
                        ? null
                        : () async {
                            showReservationDialog(
                              context,
                              selectedReservation!,
                            );
                          },
                    color: Colors.green,
                    child: const Text(
                      'اعادة حجز',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: MaterialButton(
                    onPressed: selectedReservation == null
                        ? null
                        : () async {
                            selectedReservation!.generalCheckSegmentSettings =
                                generalCheckSegmentSettings;
                            selectedReservation!.wantedAnalysis =
                                wantedAnalysis;
                            selectedReservation!.wantedCheckups =
                                wantedCheckups;
                            selectedReservation!.wantedPharmaceuticals =
                                wantedPharmaceuticals;
                            selectedReservation!.instructions = instructions;
                            selectedReservation!.analysisResults =
                                analysisResults;
                            selectedReservation!.documentsFiles =
                                documentsFiles;
                            await selectedReservation?.edit();
                          },
                    color: Colors.green,
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
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Row(
                  children: [
                    const Text('رقم الملف: '),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: FocusableField(
                        TextEditingController(
                          text: selectedPatientFileId.toString(),
                        ),
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
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Text('الاسم: '),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: FocusableField(
                        nameController,
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
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Text('الخدمة: '),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: FocusableField(
                        serviceDescriptionController,
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
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Row(
                  children: [
                    const Text('السن: '),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: FocusableField(
                        ageController,
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
                  ],
                ),
                Row(
                  children: [
                    const Text('الجنس: '),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: FocusableField(
                        TextEditingController(
                            text: selectedGenderType == Gender.male
                                ? 'ذكر'
                                : 'أنثى'),
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
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Text('ملاحظات: '),
                      const SizedBox(width: 8),
                      Expanded(
                        // width: 150,
                        // height: 50,
                        child: FocusableField(
                          noteController,
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
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DefaultTabController(
            length: 7,
            child: Expanded(
              child: Column(
                children: [
                  const Card(
                    child: SizedBox(
                      height: 40,
                      child: TabBar(
                        tabs: [
                          SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'الفحص العام',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'طلب تحاليل',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'طلب فحص',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'الادوية',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'التعليمات',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'نتائج التحاليل',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'المستندات',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: [
                        generalCheckSegment(),
                        wantedAnalysisListView(),
                        wantedCecks(),
                        pharmaceuticalView(),
                        instructionsView(),
                        analysisResultsView(),
                        documentsView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> documentsFiles = [];

  Widget documentsView() {
    return updater.UpdaterBlocWithoutDisposer(
      updater: DocumentsFilesSegmentUpdater(
        init: '',
        updateForCurrentEvent: true,
      ),
      update: (context, s) {
        return Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'اختيار ملف',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IconButton(
                    icon: const Icon(Icons.file_open),
                    iconSize: 48,
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        File file = File(result.files.single.path!);
                        file;
                      } else {
                        // User canceled the picker
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'الملفات',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: ListView.builder(
                        itemCount: documentsFiles.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Text(documentsFiles[index]),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<AnalysisModel> foundAnalysis = [];
  PersistentBottomSheetController? bottomSheetController;
  AnalysisModel? selectedAnalysisToHaveAResult;

  bool? analysisSearch(context, String text) {
    foundAnalysis.clear();
    for (var model in allAnalysis) {
      if (model.description.toLowerCase().contains(text.toLowerCase())) {
        foundAnalysis.add(model);
      }
    }
    // print(foundAnalysis);

    if (foundAnalysis.isEmpty) {
      bottomSheetController?.close();
      return null; // Dont show the buttom sheet if the list of sugestions is empty
    }
    bottomSheetController = showBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          width: 350,
          child: Row(
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  controller: ScrollController(),
                  itemCount: foundAnalysis.length,
                  itemBuilder: (context, index) {
                    var model = foundAnalysis[index];
                    return InkWell(
                      onTap: () {
                        analysisSearchController.text = model.description;
                        selectedAnalysisToHaveAResult = model;
                        Navigator.pop(context);
                      },
                      child: Card(
                        child: Text(
                          model.description,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    return null;
  }

  List<AnalysisResultModel> analysisResults = [];
  TextEditingController resultController = TextEditingController();
  TextEditingController rangeController = TextEditingController();
  TextEditingController analysisResultController = TextEditingController();
  TextEditingController analysisDateTimeController = TextEditingController(
    text: DateTime.now().toString(),
  );
  int? selectedResultIndex;
  // TextEditingController analysisSearchController = TextEditingController();

  Widget analysisResultsView() {
    return updater.UpdaterBlocWithoutDisposer(
      updater: AnalysisResultsSegmentUpdater(
        init: '',
        updateForCurrentEvent: true,
      ),
      update: (context, s) {
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Card(
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'المدى الطبيعي',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'النتيجة',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'التحليل',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'التاريخ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Card(
                            child: ListView.builder(
                              itemCount: analysisResults.length,
                              padding: const EdgeInsets.all(8),
                              itemBuilder: (context, index) {
                                AnalysisResultModel model =
                                    analysisResults[index];
                                return InkWell(
                                  onTap: () {
                                    rangeController.text = model.defaultRange;
                                    resultController.text = model.result;
                                    selectedAnalysisToHaveAResult =
                                        model.analysis;
                                    analysisDateTimeController.text =
                                        model.analysisDate.toString();
                                    selectedResultIndex = index;
                                    AnalysisResultsSegmentUpdater().add('');
                                  },
                                  child: Container(
                                    color: selectedResultIndex == index
                                        ? Colors.black38
                                        : null,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            model.defaultRange,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            model.result,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            model.analysis.description,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            model.analysisDate.toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: MaterialButton(
                            onPressed: () {
                              if (selectedAnalysisToHaveAResult == null) {
                                toast('عليك اختيار تحليل لاضافته');
                                return;
                              }
                              var result = AnalysisResultModel(
                                0,
                                analysis: selectedAnalysisToHaveAResult!,
                                analysisDate: DateTime.parse(
                                    analysisDateTimeController.text),
                                defaultRange: rangeController.text,
                                result: resultController.text,
                              );
                              analysisResults.add(result);
                              AnalysisResultsSegmentUpdater().add('');
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
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: MaterialButton(
                            onPressed: selectedResultIndex == null
                                ? null
                                : () {
                                    analysisResults
                                        .removeAt(selectedResultIndex!);
                                    selectedResultIndex = null;
                                    AnalysisResultsSegmentUpdater().add('');
                                  },
                            color: Colors.black87,
                            child: const Text(
                              'ازالة',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              // height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: TextField(
                            controller: analysisResultController,
                            onChanged: (text) => analysisSearch(context, text),
                            decoration: InputDecoration(
                              labelText: 'التحليل',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: MaterialButton(
                                    onPressed: () {
                                      resultController.text = 'Positive';
                                    },
                                    color: Colors.black87,
                                    child: const Text(
                                      'Pos',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: MaterialButton(
                                    onPressed: () {
                                      resultController.text = 'Negative';
                                    },
                                    color: Colors.black87,
                                    child: const Text(
                                      'Neg',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: SizedBox(
                                  height: 80,
                                  child: TextField(
                                    controller: resultController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      labelText: 'النتيجة',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: DateTimePicker(
                            controller: analysisDateTimeController,
                            onChanged: (text) {},
                            decoration: InputDecoration(
                              labelText: 'التاريخ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            // initialValue: DateTime.now().toString(),
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2100),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: SizedBox(
                                  height: 80,
                                  child: TextField(
                                    controller: rangeController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      labelText: 'المدى',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: MaterialButton(
                                    onPressed: () {
                                      rangeController.text += '<';
                                    },
                                    color: Colors.black87,
                                    child: const Text(
                                      '<',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: MaterialButton(
                                    onPressed: () {
                                      rangeController.text += '>';
                                    },
                                    color: Colors.black87,
                                    child: const Text(
                                      '>',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<InstructionModel> instructions = [];
  List<InstructionModel> allInstructions = [];
  TextEditingController instructionsSearchController = TextEditingController();
  FocusNode instructionsSearchNode = FocusNode();
  bool instructionsSearchMode = false;

  Widget instructionsView() {
    return updater.UpdaterBlocWithoutDisposer(
      updater: InstructonsSegmentUpdater(
        init: '',
        updateForCurrentEvent: true,
      ),
      update: (context, s) {
        return Row(
          children: [
            Expanded(
              child: Card(
                child: ListView.builder(
                  controller: ScrollController(),
                  itemCount: instructions.length,
                  itemBuilder: (context, index) {
                    var model = instructions[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(model.content)),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                instructions.remove(instructions[index]);
                                InstructonsSegmentUpdater().add(0);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: !instructionsSearchMode
                            ? null
                            : () {
                                instructionsSearchController.clear();
                              },
                      ),
                      Expanded(
                        child: NFocusableField(
                          controller: instructionsSearchController,
                          node: instructionsSearchNode,
                          labelTextWillBeTranslated: 'بحث',
                          onChanged: (text) {
                            instructionsSearchMode = true;
                            InstructonsSegmentUpdater().add(0);
                            instructionsSearchNode.requestFocus();
                            return true;
                          },
                          onSubmited: (text) {
                            return true;
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      List<InstructionModel> subList = [];
                      for (var model in allInstructions) {
                        if (model.content.toLowerCase().contains(
                              instructionsSearchController.text.toLowerCase(),
                            )) {
                          subList.add(model);
                        }
                      }
                      return ListView.builder(
                        controller: ScrollController(),
                        itemCount: subList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              for (var element in instructions) {
                                if (element.content == subList[index].content) {
                                  return;
                                }
                              }
                              instructions.add(subList[index]);
                              InstructonsSegmentUpdater().add(0);
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  top: 4,
                                  bottom: 4,
                                ),
                                child: Row(
                                  children: [
                                    Text(subList[index].content),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<DoseModel> allDosing = [];
  List<OrganModel> allOrgans = [];
  List<PharmaceuticalModel> allPharmaceuticals = [];
  List<Treatment> wantedPharmaceuticals = [];
  List<PharmaceuticalGroupModel> pharmaceuticalsGroups = [];
  String? selectedDoseDesription;
  String? selectedOrganDesription;

  Widget pharmaceuticalView() {
    return updater.UpdaterBlocWithoutDisposer(
      updater: PharamceuticalSegmentUpdater(
        init: '',
        updateForCurrentEvent: true,
      ),
      update: (context, s) {
        return Row(
          children: [
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Expanded(
                                  child: Text('الدواء',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ))),
                              Text(' | ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                  child: Text('الجرعة',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ))),
                              IconButton(
                                icon: SizedBox(),
                                onPressed: null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: wantedPharmaceuticals.length,
                        itemBuilder: (context, index) {
                          var model = wantedPharmaceuticals[index];
                          return Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          model.pharmaceutical.description)),
                                  const Text(' | '),
                                  Expanded(child: Text(model.dose.description)),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      wantedPharmaceuticals
                                          .remove(wantedPharmaceuticals[index]);
                                      PharamceuticalSegmentUpdater().add(0);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: Expanded(
                        child: Column(
                          children: [
                            tapBarWidget('كل الادوية', 'مجموعات الادوية'),
                            const SizedBox(height: 16),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  allPharmaceuticalView(),
                                  groupedPharamceuticalView(),
                                ],
                              ),
                            ),
                            DropdownButton<String>(
                              items: allDosing.map((e) {
                                return DropdownMenuItem<String>(
                                  value: e.description,
                                  child: Text(e.description),
                                  onTap: () {
                                    // selectedAnalysisGroup = e;
                                  },
                                );
                              }).toList(),
                              value: selectedDoseDesription ??
                                  (allDosing.isNotEmpty
                                      ? allDosing.first.description
                                      : selectedDoseDesription),
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                selectedDoseDesription = value;
                                PharamceuticalSegmentUpdater().add(0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String? selectedPharmaceuticalGroupTitle;
  bool pharamceuticalSearchMode = false;
  TextEditingController pharamceuticalSearchController =
      TextEditingController();
  var pharamceuticalSearchNode = FocusNode();
  Widget allPharmaceuticalView() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: !pharamceuticalSearchMode
                  ? null
                  : () {
                      pharamceuticalSearchController.clear();
                    },
            ),
            Expanded(
              child: NFocusableField(
                controller: pharamceuticalSearchController,
                node: pharamceuticalSearchNode,
                labelTextWillBeTranslated: 'بحث',
                onChanged: (text) {
                  pharamceuticalSearchMode = true;
                  PharamceuticalSegmentUpdater().add(0);
                  pharamceuticalSearchNode.requestFocus();
                  return true;
                },
                onSubmited: (text) {
                  return true;
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Builder(builder: (context) {
            List<PharmaceuticalModel> subList = [];
            for (var model in allPharmaceuticals) {
              if (model.description.toLowerCase().contains(
                    pharamceuticalSearchController.text.toLowerCase(),
                  )) {
                subList.add(model);
              }
            }
            return ListView.builder(
              controller: ScrollController(),
              itemCount: subList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    for (var element in wantedPharmaceuticals) {
                      if (element.pharmaceutical.description ==
                              subList[index].description &&
                          element.dose.description == selectedDoseDesription) {
                        return;
                      }
                    }
                    if (selectedDoseDesription == null) {
                      return;
                    }
                    Treatment check = Treatment(
                      subList[index],
                      allDosing
                          .where(
                            (element) =>
                                element.description == selectedDoseDesription,
                          )
                          .first,
                    );
                    wantedPharmaceuticals.add(check);
                    PharamceuticalSegmentUpdater().add(0);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Text(subList[index].description),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget groupedPharamceuticalView() {
    return Column(
      children: [
        DropdownButton<String>(
          items: pharmaceuticalsGroups.map((e) {
            return DropdownMenuItem<String>(
              value: e.title,
              child: Text(e.title),
              onTap: () {
                // selectedAnalysisGroup = e;
              },
            );
          }).toList(),
          value: pharmaceuticalsGroups.isNotEmpty
              ? pharmaceuticalsGroups.first.title
              : selectedPharmaceuticalGroupTitle,
          onChanged: (value) {
            if (value == null) {
              return;
            }
            selectedPharmaceuticalGroupTitle = value;
            PharamceuticalSegmentUpdater().add(0);
          },
        ),
        Expanded(
          child: Builder(builder: (context) {
            List<PharmaceuticalModel> subList = [];
            for (var model in allPharmaceuticals) {
              if (model.group.title == selectedPharmaceuticalGroupTitle) {
                subList.add(model);
              }
            }
            return ListView.builder(
              controller: ScrollController(),
              itemCount: subList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    for (var element in wantedPharmaceuticals) {
                      if (element.pharmaceutical.description ==
                              subList[index].description &&
                          element.dose.description == selectedDoseDesription) {
                        return;
                      }
                    }
                    if (selectedDoseDesription == null) {
                      return;
                    }
                    Treatment check = Treatment(
                      subList[index],
                      allDosing
                          .where(
                            (element) =>
                                element.description == selectedDoseDesription,
                          )
                          .first,
                    );
                    wantedPharmaceuticals.add(check);
                    PharamceuticalSegmentUpdater().add(0);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Text(subList[index].description),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  List<CheckOrgan> wantedCheckups = [];
  List<CheckupsModel> allCheckups = [];
  List<CheckupsGroupModel> checkupsGroups = [];

  Widget wantedCecks() {
    return updater.UpdaterBlocWithoutDisposer(
      updater: WantedChecksSegmentUpdater(
        init: '',
        updateForCurrentEvent: true,
      ),
      update: (context, s) {
        return Row(
          children: [
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    const Text('فحوصات المريض المطلوبة'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Expanded(child: Text('الفحص')),
                              Text(' | '),
                              Expanded(child: Text('العضو')),
                              IconButton(
                                icon: SizedBox(),
                                onPressed: null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: wantedCheckups.length,
                        itemBuilder: (context, index) {
                          var model = wantedCheckups[index];
                          return Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(model.checkup.description)),
                                  const Text(' | '),
                                  Expanded(
                                      child: Text(model.organ.description)),
                                  // const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      wantedCheckups
                                          .remove(wantedCheckups[index]);
                                      WantedChecksSegmentUpdater().add(0);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: Expanded(
                        child: Column(
                          children: [
                            tapBarWidget('كل الفحوصات', 'مجموعات الفحوصات'),
                            const SizedBox(height: 16),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  allCheckupsView(),
                                  groupedCheckupsView(),
                                ],
                              ),
                            ),
                            DropdownButton<String>(
                              items: allOrgans.map((e) {
                                return DropdownMenuItem<String>(
                                  value: e.description,
                                  child: Text(e.description),
                                  onTap: () {
                                    // selectedAnalysisGroup = e;
                                  },
                                );
                              }).toList(),
                              value: allOrgans.isNotEmpty
                                  ? allOrgans.first.description
                                  : selectedOrganDesription,
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                selectedOrganDesription = value;
                                WantedChecksSegmentUpdater().add(0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String? selectedCheckGroupTitle;
  bool searchMode = false;
  TextEditingController checksSearchController = TextEditingController();
  var checksSearchNode = FocusNode();
  Widget allCheckupsView() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: !searchMode
                  ? null
                  : () {
                      checksSearchController.clear();
                    },
            ),
            Expanded(
              child: NFocusableField(
                controller: checksSearchController,
                node: checksSearchNode,
                labelTextWillBeTranslated: 'بحث',
                onChanged: (text) {
                  searchMode = true;
                  WantedChecksSegmentUpdater().add(0);
                  checksSearchNode.requestFocus();
                  return true;
                },
                onSubmited: (text) {
                  return true;
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Builder(builder: (context) {
            List<CheckupsModel> subList = [];
            for (var model in allCheckups) {
              if (model.description
                  .toLowerCase()
                  .contains(checksSearchController.text.toLowerCase())) {
                subList.add(model);
              }
            }
            return ListView.builder(
              controller: ScrollController(),
              itemCount: subList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    for (var element in wantedCheckups) {
                      if (element.checkup.description ==
                              subList[index].description &&
                          element.organ.description ==
                              selectedOrganDesription) {
                        return;
                      }
                    }
                    if (selectedOrganDesription == null) {
                      return;
                    }
                    CheckOrgan check = CheckOrgan(
                        allOrgans
                            .where(
                              (element) =>
                                  element.description ==
                                  selectedOrganDesription,
                            )
                            .first,
                        subList[index]);
                    wantedCheckups.add(check);
                    WantedChecksSegmentUpdater().add(0);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Text(subList[index].description),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget groupedCheckupsView() {
    return Column(
      children: [
        DropdownButton<String>(
          items: checkupsGroups.map((e) {
            return DropdownMenuItem<String>(
              value: e.title,
              child: Text(e.title),
              onTap: () {
                // selectedAnalysisGroup = e;
              },
            );
          }).toList(),
          value: checkupsGroups.isNotEmpty
              ? checkupsGroups.first.title
              : selectedCheckGroupTitle,
          onChanged: (value) {
            if (value == null) {
              return;
            }
            selectedCheckGroupTitle = value;
            WantedChecksSegmentUpdater().add(0);
          },
        ),
        Expanded(
          child: Builder(builder: (context) {
            List<CheckupsModel> subList = [];
            for (var model in allCheckups) {
              if (model.analysisGroup.title == selectedCheckGroupTitle) {
                subList.add(model);
              }
            }
            return ListView.builder(
              controller: ScrollController(),
              itemCount: subList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    for (var element in wantedCheckups) {
                      if (element.checkup.description ==
                              subList[index].description &&
                          element.organ.description ==
                              selectedOrganDesription) {
                        return;
                      }
                    }
                    if (selectedOrganDesription == null) {
                      return;
                    }
                    CheckOrgan check = CheckOrgan(
                        allOrgans
                            .where(
                              (element) =>
                                  element.description ==
                                  selectedOrganDesription,
                            )
                            .first,
                        subList[index]);
                    wantedCheckups.add(check);
                    WantedChecksSegmentUpdater().add(0);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Text(subList[index].description),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  List<AnalysisModel> allAnalysis = [];
  List<AnalysisModel> wantedAnalysis = [];
  List<AnalysisGroupModel> analysisGroups = [];

  Widget wantedAnalysisListView() {
    return updater.UpdaterBlocWithoutDisposer(
      updater: WantedAnalysisListSegmentUpdater(
        init: '',
        updateForCurrentEvent: true,
      ),
      update: (context, s) {
        return Row(
          children: [
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    const Text('تحاليل المريض المطلوبة'),
                    Expanded(
                      child: ListView.builder(
                        itemCount: wantedAnalysis.length,
                        itemBuilder: (context, index) {
                          var analysis = wantedAnalysis[index];
                          return Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                children: [
                                  Text(analysis.description),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      wantedAnalysis
                                          .remove(wantedAnalysis[index]);
                                      WantedAnalysisListSegmentUpdater().add(0);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: Expanded(
                        child: Column(
                          children: [
                            tapBarWidget('كل التحاليل', 'مجموعات التحاليل'),
                            const SizedBox(height: 16),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  allAnalysisView(),
                                  groupedAnalysisView(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  String? selectedAnalysisGroupTitle;
  bool analysisSearchMode = false;
  TextEditingController analysisSearchController = TextEditingController();
  var analysisSearchNode = FocusNode();
  Widget allAnalysisView() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: !searchMode
                  ? null
                  : () {
                      analysisSearchController.clear();
                    },
            ),
            Expanded(
              child: NFocusableField(
                controller: analysisSearchController,
                node: analysisSearchNode,
                labelTextWillBeTranslated: 'بحث',
                onChanged: (text) {
                  searchMode = true;
                  WantedAnalysisListSegmentUpdater().add(0);
                  analysisSearchNode.requestFocus();
                  return true;
                },
                onSubmited: (text) {
                  return true;
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Builder(builder: (context) {
            List<AnalysisModel> subList = [];
            for (var analysis in allAnalysis) {
              if (analysis.description
                  .toLowerCase()
                  .contains(analysisSearchController.text.toLowerCase())) {
                subList.add(analysis);
              }
            }
            return ListView.builder(
              controller: ScrollController(),
              itemCount: subList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    for (var element in wantedAnalysis) {
                      if (element.description == subList[index].description) {
                        return;
                      }
                    }
                    wantedAnalysis.add(subList[index]);
                    WantedAnalysisListSegmentUpdater().add(0);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Text(subList[index].description),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget groupedAnalysisView() {
    return Column(
      children: [
        DropdownButton<String>(
          items: analysisGroups.map((e) {
            return DropdownMenuItem<String>(
              value: e.title,
              child: Text(e.title),
              onTap: () {
                // selectedAnalysisGroup = e;
              },
            );
          }).toList(),
          value: analysisGroups.isNotEmpty
              ? analysisGroups.first.title
              : selectedAnalysisGroupTitle,
          onChanged: (value) {
            if (value == null) {
              return;
            }
            selectedAnalysisGroupTitle = value;
            WantedAnalysisListSegmentUpdater().add(0);
          },
        ),
        Expanded(
          child: Builder(builder: (context) {
            List<AnalysisModel> subList = [];
            for (var analysis in allAnalysis) {
              if (analysis.analysisGroup.title == selectedAnalysisGroupTitle) {
                subList.add(analysis);
              }
            }
            return ListView.builder(
              controller: ScrollController(),
              itemCount: subList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    for (var element in wantedAnalysis) {
                      if (element.description == subList[index].description) {
                        return;
                      }
                    }
                    wantedAnalysis.add(subList[index]);
                    WantedAnalysisListSegmentUpdater().add(0);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Text(subList[index].description),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  TextEditingController property1 = TextEditingController();
  TextEditingController property2 = TextEditingController();
  TextEditingController property3 = TextEditingController();
  TextEditingController property4 = TextEditingController();
  TextEditingController property5 = TextEditingController();
  TextEditingController property6 = TextEditingController();
  TextEditingController property7 = TextEditingController();
  TextEditingController property8 = TextEditingController();
  TextEditingController property10 = TextEditingController();
  TextEditingController property11 = TextEditingController();
  TextEditingController property12 = TextEditingController();
  TextEditingController property13 = TextEditingController();
  TextEditingController property14 = TextEditingController();

  Map<String, TextEditingController> generalCheckBoardControllers = {};

  Widget generalCheckSegment() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                        '${generalCheckSegmentSettings['keys']!['property1']}: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NFocusableField(
                        controller: property1,
                        node: FocusNode(),
                        labelTextWillBeTranslated: '',
                        onSubmited: (text) {
                          return true;
                        },
                        onChanged: (text) {
                          generalCheckSegmentSettings['values']!['property1'] =
                              text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                        '${generalCheckSegmentSettings['keys']!['property2']}: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NFocusableField(
                        controller: property2,
                        node: FocusNode(),
                        labelTextWillBeTranslated: '',
                        onSubmited: (text) {
                          return true;
                        },
                        onChanged: (text) {
                          generalCheckSegmentSettings['values']!['property2'] =
                              text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                        '${generalCheckSegmentSettings['keys']!['property3']}: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NFocusableField(
                        controller: property3,
                        node: FocusNode(),
                        labelTextWillBeTranslated: '',
                        onSubmited: (text) {
                          return true;
                        },
                        onChanged: (text) {
                          generalCheckSegmentSettings['values']!['property3'] =
                              text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                        '${generalCheckSegmentSettings['keys']!['property4']}: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NFocusableField(
                        controller: property4,
                        node: FocusNode(),
                        labelTextWillBeTranslated: '',
                        onSubmited: (text) {
                          return true;
                        },
                        onChanged: (text) {
                          generalCheckSegmentSettings['values']!['property4'] =
                              text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                        '${generalCheckSegmentSettings['keys']!['property5']}: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NFocusableField(
                        controller: property5,
                        node: FocusNode(),
                        labelTextWillBeTranslated: '',
                        onSubmited: (text) {
                          return true;
                        },
                        onChanged: (text) {
                          generalCheckSegmentSettings['values']!['property5'] =
                              text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                        '${generalCheckSegmentSettings['keys']!['property6']}: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NFocusableField(
                        controller: property6,
                        node: FocusNode(),
                        labelTextWillBeTranslated: '',
                        onSubmited: (text) {
                          return true;
                        },
                        onChanged: (text) {
                          generalCheckSegmentSettings['values']!['property6'] =
                              text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                        '${generalCheckSegmentSettings['keys']!['property7']}: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NFocusableField(
                        controller: property7,
                        node: FocusNode(),
                        labelTextWillBeTranslated: '',
                        onSubmited: (text) {
                          return true;
                        },
                        onChanged: (text) {
                          generalCheckSegmentSettings['values']!['property7'] =
                              text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                        '${generalCheckSegmentSettings['keys']!['property8']}: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NFocusableField(
                        controller: property8,
                        node: FocusNode(),
                        labelTextWillBeTranslated: '',
                        onSubmited: (text) {
                          return true;
                        },
                        onChanged: (text) {
                          generalCheckSegmentSettings['values']!['property8'] =
                              text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: NFocusableField(
                  controller: property10,
                  node: FocusNode(),
                  labelTextWillBeTranslated: '',
                  onSubmited: (text) {
                    return true;
                  },
                  onChanged: (text) {
                    generalCheckSegmentSettings['values']!['property10'] = text;
                  },
                ),
              ),
              Text('${generalCheckSegmentSettings['keys']!['property10']}: '),
              const SizedBox(width: 8),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: NFocusableField(
                  controller: property11,
                  node: FocusNode(),
                  labelTextWillBeTranslated: '',
                  onSubmited: (text) {
                    return true;
                  },
                  onChanged: (text) {
                    generalCheckSegmentSettings['values']!['property11'] = text;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text('${generalCheckSegmentSettings['keys']!['property11']}: '),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: NFocusableField(
                  controller: property12,
                  node: FocusNode(),
                  labelTextWillBeTranslated: '',
                  onSubmited: (text) {
                    return true;
                  },
                  onChanged: (text) {
                    generalCheckSegmentSettings['values']!['property12'] = text;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text('${generalCheckSegmentSettings['keys']!['property12']}: '),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: NFocusableField(
                  controller: property13,
                  node: FocusNode(),
                  labelTextWillBeTranslated: '',
                  onSubmited: (text) {
                    return true;
                  },
                  onChanged: (text) {
                    generalCheckSegmentSettings['values']!['property13'] = text;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text('${generalCheckSegmentSettings['keys']!['property13']}: '),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: NFocusableField(
                  controller: property14,
                  node: FocusNode(),
                  labelTextWillBeTranslated: '',
                  onSubmited: (text) {
                    return true;
                  },
                  onChanged: (text) {
                    generalCheckSegmentSettings['values']!['property14'] = text;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text('${generalCheckSegmentSettings['keys']!['property14']}: '),
            ],
          ),
        ),
      ],
    );
  }
}
