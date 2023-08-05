import 'package:businet_medical_center/models/instruction_model.dart';
import 'package:businet_medical_center/models/lab/analysis_group_model.dart';
import 'package:businet_medical_center/models/lab/analysis_model.dart';
import 'package:businet_medical_center/models/lab/analysis_sample_model.dart';
import 'package:businet_medical_center/models/lab/analysis_sample_unit_model.dart';
import 'package:businet_medical_center/models/lab/analysis_sub_group_model.dart';
import 'package:businet_medical_center/models/lab/analysis_work_group_model.dart';
import 'package:businet_medical_center/models/lab/external_lab_model.dart';
import 'package:businet_medical_center/models/processes_model.dart';
import 'package:businet_medical_center/utils/updaters.dart';
import 'package:businet_medical_center/views/widgets/focusable_field.dart';
import 'package:businet_medical_center/views/widgets/spec_field.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:updater/updater.dart' as updater;

class LabAnalysisListView extends StatefulWidget {
  const LabAnalysisListView({Key? key}) : super(key: key);

  @override
  State<LabAnalysisListView> createState() => _LabAnalysisListViewState();
}

class _LabAnalysisListViewState extends State<LabAnalysisListView> {
  List<AnalysisModel> models = [];
  // List<AnalysisGroupModel> groups = [];
  List<AnalysisGroupModel> analysisGroupModels = <AnalysisGroupModel>[];
  List<AnalysisSubGroupModel> analysisSubGroupModels = [];
  List<AnalysisWorkGroupModel> analysisWorkGroupModels = [];
  List<AnalysisSampleModel> analysisSampleModels = [];
  List<ExternalLabModel> externalLabModels = [];
  List<InstructionModel> instructionModels = [];
  List<AnalysisSampleUnitModel> analysisSampleUnitModels = [];

  TextEditingController idController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  // AnalysisGroupModel? selectedAnalysisGroup;

  // String? selectedAnalysisGroupTitle;
  AnalysisModel? selectedModel;

  TextEditingController analysisSampleSearchController =
      TextEditingController();
  TextEditingController analysisSampleUnitSearchController =
      TextEditingController();
  TextEditingController receiptDateController = TextEditingController();
  TextEditingController analysisWorkGroupSearchController =
      TextEditingController();
  TextEditingController analysisGroupSearchController = TextEditingController();
  TextEditingController analysisSubGroupSearchController =
      TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController labToLabPriceController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController refForMaleController = TextEditingController();
  TextEditingController refForFemaleController = TextEditingController();
  TextEditingController femaleLowLimitController = TextEditingController();
  TextEditingController maleLowLimitController = TextEditingController();
  TextEditingController femaleHighLimitController = TextEditingController();
  TextEditingController maleHighLimitController = TextEditingController();
  TextEditingController instructionSearchController = TextEditingController();
  TextEditingController externalLabSearchController = TextEditingController();
  TextEditingController externalLabPriceController = TextEditingController();

  String? currentSelected = '';

  @override
  void initState() {
    super.initState();
    getAwaiters();
  }

  void getAwaiters() async {
    await InstructionModel.getAll().then((value) {
      instructionModels.clear();
      instructionModels.addAll(value);
      ThisPageSecondUpdater().add('');
    });
    await ExternalLabModel.getAll().then((value) {
      externalLabModels.clear();
      externalLabModels.addAll(value);
      ThisPageSecondUpdater().add('');
    });
    await AnalysisGroupModel.getAll().then((value) {
      analysisGroupModels.clear();
      analysisGroupModels.addAll(value);
      ThisPageSecondUpdater().add('');
    });
    await AnalysisSampleModel.getAll().then((value) {
      analysisSampleModels.clear();
      analysisSampleModels.addAll(value);
      ThisPageSecondUpdater().add('');
    });
    await AnalysisSubGroupModel.getAll().then((value) {
      analysisSubGroupModels.clear();
      analysisSubGroupModels.addAll(value);
      ThisPageSecondUpdater().add('');
    });
    await AnalysisWorkGroupModel.getAll().then((value) {
      analysisWorkGroupModels.clear();
      analysisWorkGroupModels.addAll(value);
      ThisPageSecondUpdater().add('');
    });
    await AnalysisSampleUnitModel.getAll().then((value) {
      analysisSampleUnitModels.clear();
      analysisSampleUnitModels.addAll(value);
      analysisSampleUnit = analysisSampleUnitModels.first;
      ThisPageSecondUpdater().add('');
    });
    // await Future.delayed(Dur)
    // ThisPageSecondUpdater().add('');
  }

  @override
  Widget build(BuildContext context) {
    // SystemMDBService.db.collection('labAnalysises').drop();
    return updater.UpdaterBlocWithoutDisposer(
        updater: ThisPageSecondUpdater(
          init: '',
          updateForCurrentEvent: true,
        ),
        update: (context, s) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('التحاليل'),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                                selectedModel!.description = description;
                                selectedModel!.receiptDate = receiptDate;
                                selectedModel!.analysisSample = analysisSample!;
                                selectedModel!.analysisSampleUnit =
                                    analysisSampleUnit!;
                                selectedModel!.analysisGroup = analysisGroup!;
                                selectedModel!.analysisSubGroup =
                                    analysisSubGroup!;
                                selectedModel!.analysisWorkGroup =
                                    analysisWorkGroup!;
                                selectedModel!.barcode = barcode;
                                selectedModel!.instruction = instruction;
                                selectedModel!.externalLab = externalLab;
                                selectedModel!.femaleRefHighLimit =
                                    femaleRefHighLimit;
                                selectedModel!.femaleRefLowLimit =
                                    femaleRefLowLimit;
                                selectedModel!.maleRefHighLimit =
                                    maleRefHighLimit;
                                selectedModel!.maleRefLowLimit =
                                    maleRefLowLimit;
                                selectedModel!.price = price;
                                selectedModel!.externalLabPrice =
                                    externalLabPrice;
                                selectedModel!.labToLabPrice = labToLabPrice;
                                selectedModel!.sentToOtherLab = sentToOtherLab;
                                selectedModel!.refForFemale = refForFemale;
                                selectedModel!.refForMale = refForMale;
                                await selectedModel!.edit();
                                // ThisPageUpdater().add('');
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
                        onPressed: saveAnalysis,
                        child: const Text('اضافة'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: NFocusableField(
                                  controller: descriptionController,
                                  node: FocusNode(),
                                  labelTextWillBeTranslated: 'الاسم',
                                  onSubmited: (text) {
                                    return true;
                                  },
                                  onChanged: (text) {
                                    description = text;
                                    return true;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    SpecField1<AnalysisSampleModel>(
                                      defaultValue: analysisSample,
                                      fieldController:
                                          analysisSampleSearchController,
                                      fieldLabel: 'العينة: ',
                                      listOfT: analysisSampleModels,
                                      onTap: (e) {
                                        analysisSample = e;
                                        analysisSampleSearchController.text =
                                            analysisSample!.description;
                                        ThisPageSecondUpdater().add('');
                                      },
                                      titleRetriver: (e) {
                                        return e.description;
                                      },
                                    ),
                                    SpecField1<AnalysisSampleUnitModel>(
                                      defaultValue: analysisSampleUnit,
                                      fieldController:
                                          analysisSampleUnitSearchController,
                                      fieldLabel: 'وحدة العينة: ',
                                      listOfT: analysisSampleUnitModels,
                                      onTap: (e) {
                                        analysisSampleUnit = e;
                                        analysisSampleUnitSearchController
                                                .text =
                                            analysisSampleUnit!.description;
                                        ThisPageSecondUpdater().add('');
                                      },
                                      titleRetriver: (e) {
                                        return e.description;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    NFocusableField(
                                      controller: receiptDateController,
                                      node: FocusNode(),
                                      labelTextWillBeTranslated: 'الاستلام بعد',
                                      onSubmited: (text) {
                                        return true;
                                      },
                                      onChanged: (text) {
                                        receiptDate = int.parse(text);
                                        return true;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    SpecField1<AnalysisGroupModel>(
                                      defaultValue: analysisGroup,
                                      fieldController:
                                          analysisGroupSearchController,
                                      fieldLabel: 'المجموعة الاساسية: ',
                                      listOfT: analysisGroupModels,
                                      onTap: (e) {
                                        analysisGroup = e;
                                        analysisGroupSearchController.text =
                                            analysisGroup!.title;
                                        ThisPageSecondUpdater().add('');
                                      },
                                      titleRetriver: (e) {
                                        return e.title;
                                      },
                                    ),
                                    SpecField1<AnalysisSubGroupModel>(
                                      defaultValue: analysisSubGroup,
                                      fieldController:
                                          analysisSubGroupSearchController,
                                      fieldLabel: 'المجموعة الفرعية: ',
                                      listOfT: analysisSubGroupModels,
                                      onTap: (e) {
                                        analysisSubGroup = e;
                                        analysisSubGroupSearchController.text =
                                            analysisSubGroup!.title;
                                        ThisPageSecondUpdater().add('');
                                      },
                                      titleRetriver: (e) {
                                        return e.title;
                                      },
                                    ),
                                    SpecField1<AnalysisWorkGroupModel>(
                                      defaultValue: analysisWorkGroup,
                                      fieldController:
                                          analysisWorkGroupSearchController,
                                      fieldLabel: 'مجموعة العمل',
                                      listOfT: analysisWorkGroupModels,
                                      onTap: (e) {
                                        analysisWorkGroup = e;
                                        analysisWorkGroupSearchController.text =
                                            analysisWorkGroup!.title;
                                        ThisPageSecondUpdater().add('');
                                      },
                                      titleRetriver: (e) {
                                        return e.title;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    NFocusableField(
                                      controller: priceController,
                                      node: FocusNode(),
                                      labelTextWillBeTranslated: 'السعر',
                                      onSubmited: (text) {
                                        FocusNode().requestFocus();
                                        return true;
                                      },
                                      onChanged: (text) {
                                        var result = double.tryParse(text);
                                        if (result != null) {
                                          price = result;
                                        } else {
                                          toast('عفوا, ادخل الرقم بصورة صحيحة');
                                        }
                                        return true;
                                      },
                                    ),
                                    NFocusableField(
                                      controller: labToLabPriceController,
                                      node: FocusNode(),
                                      labelTextWillBeTranslated:
                                          'سعر Lap to Lap',
                                      onSubmited: (text) {
                                        return true;
                                      },
                                      onChanged: (text) {
                                        var result = double.tryParse(text);
                                        if (result != null) {
                                          labToLabPrice = result;
                                        } else {
                                          toast('عفوا, ادخل الرقم بصورة صحيحة');
                                        }
                                        return true;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: sentToOtherLab,
                                      onChanged: (value) {
                                        if (value != null) {
                                          sentToOtherLab = value;
                                          ThisPageSecondUpdater().add('');
                                        }
                                      },
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: SpecField1<ExternalLabModel>(
                                        defaultValue: externalLab,
                                        fieldController:
                                            externalLabSearchController,
                                        fieldLabel: 'الجهة خارجية: ',
                                        listOfT: externalLabModels,
                                        enabled: sentToOtherLab,
                                        onTap: (e) {
                                          externalLab = e;
                                          externalLabSearchController.text =
                                              externalLab!.title;
                                          ThisPageSecondUpdater().add('');
                                        },
                                        titleRetriver: (e) {
                                          return e.title;
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: NFocusableField(
                                        enabled: sentToOtherLab,
                                        controller: externalLabPriceController,
                                        node: FocusNode(),
                                        labelTextWillBeTranslated: 'السعر',
                                        onSubmited: (text) {
                                          return true;
                                        },
                                        onChanged: (text) {
                                          var result = double.tryParse(text);
                                          if (result != null) {
                                            externalLabPrice = result;
                                          } else {
                                            toast(
                                                'عفوا, ادخل الرقم بصورة صحيحة');
                                          }
                                          return true;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: NFocusableField(
                                  controller: barcodeController,
                                  node: FocusNode(),
                                  labelTextWillBeTranslated: 'الباركود',
                                  onSubmited: (text) {
                                    return true;
                                  },
                                  onChanged: (text) {
                                    barcode = text;
                                    return true;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: NFocusableField(
                                  controller: refForMaleController,
                                  node: FocusNode(),
                                  labelTextWillBeTranslated:
                                      'Ref For Male Adult',
                                  maxLines: 2,
                                  minLines: 2,
                                  onSubmited: (text) {
                                    return true;
                                  },
                                  onChanged: (text) {
                                    refForMale = text;
                                    return true;
                                  },
                                ),
                              ),
                              Expanded(
                                child: NFocusableField(
                                  controller: refForFemaleController,
                                  node: FocusNode(),
                                  labelTextWillBeTranslated:
                                      'Ref For Female Adult',
                                  onSubmited: (text) {
                                    return true;
                                  },
                                  onChanged: (text) {
                                    refForFemale = text;
                                    return true;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: NFocusableField(
                                  controller: refForMaleController,
                                  node: FocusNode(),
                                  labelTextWillBeTranslated:
                                      'Ref For Male Child',
                                  maxLines: 2,
                                  minLines: 2,
                                  onSubmited: (text) {
                                    return true;
                                  },
                                  onChanged: (text) {
                                    refForMale = text;
                                    return true;
                                  },
                                ),
                              ),
                              Expanded(
                                child: NFocusableField(
                                  controller: refForFemaleController,
                                  node: FocusNode(),
                                  labelTextWillBeTranslated:
                                      'Ref For Female Child',
                                  onSubmited: (text) {
                                    return true;
                                  },
                                  onChanged: (text) {
                                    refForFemale = text;
                                    return true;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.arrow_upward),
                                          Expanded(
                                            child: NFocusableField(
                                              controller:
                                                  femaleHighLimitController,
                                              node: FocusNode(),
                                              labelTextWillBeTranslated:
                                                  'High Limit',
                                              onSubmited: (text) {
                                                return true;
                                              },
                                              onChanged: (text) {
                                                var result =
                                                    double.tryParse(text);
                                                if (result != null) {
                                                  femaleRefHighLimit = result;
                                                } else {
                                                  toast(
                                                      'عفوا, ادخل الرقم بصورة صحيحة');
                                                }
                                                return true;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.arrow_downward),
                                          Expanded(
                                            child: NFocusableField(
                                              controller:
                                                  femaleLowLimitController,
                                              node: FocusNode(),
                                              labelTextWillBeTranslated:
                                                  'Low Limit',
                                              onSubmited: (text) {
                                                return true;
                                              },
                                              onChanged: (text) {
                                                var result =
                                                    double.tryParse(text);
                                                if (result != null) {
                                                  femaleRefLowLimit = result;
                                                } else {
                                                  toast(
                                                      'عفوا, ادخل الرقم بصورة صحيحة');
                                                }
                                                return true;
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
                                      child: Row(
                                        children: [
                                          const Icon(Icons.arrow_upward),
                                          Expanded(
                                            child: NFocusableField(
                                              controller:
                                                  maleHighLimitController,
                                              node: FocusNode(),
                                              labelTextWillBeTranslated:
                                                  'High Limit',
                                              onSubmited: (text) {
                                                return true;
                                              },
                                              onChanged: (text) {
                                                var result =
                                                    double.tryParse(text);
                                                if (result != null) {
                                                  maleRefHighLimit = result;
                                                } else {
                                                  toast(
                                                      'عفوا, ادخل الرقم بصورة صحيحة');
                                                }
                                                return true;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.arrow_downward),
                                          Expanded(
                                            child: NFocusableField(
                                              controller:
                                                  maleLowLimitController,
                                              node: FocusNode(),
                                              labelTextWillBeTranslated:
                                                  'Low Limit',
                                              onSubmited: (text) {
                                                return true;
                                              },
                                              onChanged: (text) {
                                                var result =
                                                    double.tryParse(text);
                                                if (result != null) {
                                                  maleRefLowLimit = result;
                                                } else {
                                                  toast(
                                                      'عفوا, ادخل الرقم بصورة صحيحة');
                                                }
                                                return true;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SpecField1<InstructionModel>(
                                  defaultValue: instruction,
                                  fieldController: instructionSearchController,
                                  fieldLabel: 'ملاحظة: ',
                                  listOfT: instructionModels,
                                  onTap: (e) {
                                    instruction = e;
                                    instructionSearchController.text =
                                        instruction!.content;
                                    ThisPageSecondUpdater().add('');
                                  },
                                  onChanged: (text) {
                                    instruction =
                                        InstructionModel(0, content: text);
                                    return true;
                                  },
                                  titleRetriver: (e) {
                                    return e.content;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        updater.UpdaterBlocWithoutDisposer(
                          updater: ThisPageUpdater(
                            init: '',
                            updateForCurrentEvent: true,
                          ),
                          update: (context, s) {
                            return Expanded(
                              child: FutureBuilder<List<AnalysisModel>>(
                                future: AnalysisModel.getAll(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    throw snapshot.stackTrace!;
                                    return Center(
                                      child: Text(
                                        'عذرا حدث خطأ ما: ${snapshot.error}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    models = (snapshot.data!);
                                    return ListView.builder(
                                      itemCount: models.length,
                                      itemBuilder: (context, index) {
                                        var model = models[index];
                                        return InkWell(
                                          onTap: () => onTapAnalysis(model),
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 4, 8, 4),
                                              child: Text(model.description),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void onTapAnalysis(AnalysisModel model) {
    selectedModel = model;

    description = model.description;
    descriptionController.text = model.description;

    analysisSample = model.analysisSample;
    analysisGroup = model.analysisGroup;
    analysisSampleUnit = model.analysisSampleUnit;
    analysisSubGroup = model.analysisSubGroup;
    analysisWorkGroup = model.analysisWorkGroup;

    barcode = model.barcode;
    barcodeController.text = barcode ?? '';

    externalLab = model.externalLab;
    externalLabPrice = model.externalLabPrice;
    externalLabPriceController.text = externalLabPrice.toString();

    labToLabPrice = model.labToLabPrice;
    labToLabPriceController.text = labToLabPrice.toString();

    femaleRefHighLimit = model.femaleRefHighLimit;
    femaleRefLowLimit = model.femaleRefLowLimit;
    femaleHighLimitController.text = maleRefHighLimit.toString();
    femaleLowLimitController.text = maleRefLowLimit.toString();
    maleRefHighLimit = model.maleRefHighLimit;
    maleRefLowLimit = model.maleRefLowLimit;
    maleHighLimitController.text = maleRefHighLimit.toString();
    maleLowLimitController.text = maleRefLowLimit.toString();

    price = model.price;
    priceController.text = price.toString();

    receiptDate = model.receiptDate;
    receiptDateController.text = receiptDate.toString();

    refForFemale = model.refForFemale;
    refForFemaleController.text = refForFemale;

    refForMale = model.refForMale;
    refForMaleController.text = refForMale;

    sentToOtherLab = model.sentToOtherLab;

    instruction = model.instruction;
    instructionSearchController.text = '${instruction?.content}';
    ThisPageSecondUpdater().add('');
    // ThisPageUpdater().add('');
  }

  void saveAnalysis() async {
    var labAnalysisId = await ProcessesModel.stored!.requestLabAnalysisId();
    var id = int.tryParse(idController.text.isNotEmpty
        ? idController.text
        : labAnalysisId.toString());
    if (descriptionController.text.isEmpty) {
      return;
    }
    if (id == null) {
      toast('لا يمكنك ترك المعرف فارغا');
      return;
    }
    var model = AnalysisModel(
      id,
      description: descriptionController.text,
    );

    if (analysisSample == null) {
      analysisSampleWanted = 'عليك بملء المجال';
      toast('analysisSampleWanted');
      return;
    }
    if (analysisSampleUnit == null) {
      analysisSampleUnitWanted = 'عليك بملء المجال';
      toast('analysisSampleUnitWanted');
      return;
    }
    if (analysisGroup == null) {
      analysisGroupWanted = 'عليك بملء المجال';
      toast('analysisGroupWanted');
      return;
    }
    if (analysisSubGroup == null) {
      analysisSubGroupWanted = 'عليك بملء المجال';
      toast('analysisSubGroupWanted');
      return;
    }
    if (analysisWorkGroup == null) {
      analysisWorkGroupWanted = 'عليك بملء المجال';
      toast('analysisWorkGroupWanted');
      return;
    }
    if (barcode == null) {
      barcodeWanted = 'عليك بملء المجال';
      toast('barcodeWanted');
      return;
    }
    // if (instruction == null) {
    //   instructionWanted = 'عليك بملء المجال';
    //   toast('instructionWanted');
    //   return;
    // }
    if (sentToOtherLab && externalLab == null) {
      externalLabWanted = 'عليك بملء المجال';
      toast('externalLabWanted');
      return;
    }
    // if (femaleRefHighLimit == null) {
    //   femaleRefHighLimitWanted = 'عليك بملء المجال';
    //   toast('femaleRefHightLimitWanted');
    //   return;
    // }
    // if (femaleRefLowLimit == null) {
    //   femaleRefLowLimitWanted = 'عليك بملء المجال';
    //   toast('femaleRefLowLimitWanted');
    //   return;
    // }
    // if (maleRefHighLimit == null) {
    //   maleRefHighLimitWanted = 'عليك بملء المجال';
    //   toast('maleRefHightLimitWanted');
    //   return;
    // }
    // if (maleRefLowLimit == null) {
    //   maleRefLowLimitWanted = 'عليك بملء المجال';
    //   toast('maleRefLowLimitWanted');
    //   return;
    // }

    if (descriptionController.text.isEmpty) {
      toast('لا يمكنك ترك الخانة فارغة');
    }
    if (descriptionController.text.isEmpty) {
      toast('لا يمكنك ترك الخانة فارغة');
    }

    model.description = description;
    model.receiptDate = receiptDate;
    model.analysisSample = analysisSample!;
    model.analysisSampleUnit = analysisSampleUnit!;
    model.analysisGroup = analysisGroup!;
    model.analysisSubGroup = analysisSubGroup!;
    model.analysisWorkGroup = analysisWorkGroup!;
    model.barcode = barcode!;
    model.instruction = instruction;
    model.externalLab = externalLab!;
    model.femaleRefHighLimit = femaleRefHighLimit;
    model.femaleRefLowLimit = femaleRefLowLimit;
    model.maleRefHighLimit = maleRefHighLimit;
    model.maleRefLowLimit = maleRefLowLimit;
    model.price = price;
    model.externalLabPrice = externalLabPrice;
    model.labToLabPrice = labToLabPrice;
    model.sentToOtherLab = sentToOtherLab;
    model.refForFemale = refForFemale;
    model.refForMale = refForMale;
    await model.add();
    await ProcessesModel.stored!.edit();
    ThisPageUpdater().add(0);
    ThisPageSecondUpdater().add('');
  }

  late int id;
  AnalysisGroupModel? analysisGroup;
  AnalysisSubGroupModel? analysisSubGroup;
  AnalysisWorkGroupModel? analysisWorkGroup;
  AnalysisSampleModel? analysisSample;
  InstructionModel? instruction;
  AnalysisSampleUnitModel? analysisSampleUnit;
  ExternalLabModel? externalLab;
  double externalLabPrice = 0;
  late String description;
  double price = 0;
  double labToLabPrice = 0;
  late int receiptDate;
  String? barcode;
  late String refForMale;
  late String refForFemale;
  bool sentToOtherLab = false;
  double femaleRefLowLimit = 0.0;
  double femaleRefHighLimit = 0.0;
  double maleRefLowLimit = 0.0;
  double maleRefHighLimit = 0.0;

  String? analysisSampleWanted;
  String? analysisSampleUnitWanted;
  String? analysisGroupWanted;
  String? analysisSubGroupWanted;
  String? analysisWorkGroupWanted;
  String? barcodeWanted;
  // String? instructionWanted;
  String? externalLabWanted;
  String? femaleRefHighLimitWanted;
  String? femaleRefLowLimitWanted;
  String? maleRefHighLimitWanted;
  String? maleRefLowLimitWanted;
}
