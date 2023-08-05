import 'dart:async';

import 'package:businet_medical_center/models/lab/analysis_group_model.dart';
import 'package:businet_medical_center/models/lab/analysis_model.dart';
import 'package:businet_medical_center/models/patient_model.dart';
import 'package:businet_medical_center/models/payment_method_model.dart';
import 'package:businet_medical_center/utils/updaters.dart';
import 'package:businet_medical_center/views/widgets/datetime_picker.dart';
import 'package:businet_medical_center/views/widgets/focusable_field.dart';
import 'package:businet_medical_center/views/widgets/overlay_widgets.dart';
import 'package:flutter/material.dart';
import 'package:updater/updater.dart' as updater;

import '../../view_models/laboratory_reservation_page.dart';
import 'available_analysis_view_segment_widget.dart';
import 'flying_widgets.dart';
import 'lab_reservation_segment_widget.dart';

class LaboratoryView extends StatefulWidget {
  const LaboratoryView({Key? key}) : super(key: key);

  @override
  State<LaboratoryView> createState() => _LaboratoryViewState();
}

class _LaboratoryViewState extends State<LaboratoryView> {
  @override
  void initState() {
    super.initState();
    getAwaiters();
  }

  getAwaiters() async {
    paymentMethodModel = (await PaymentMethodModel.get(0))!;
    await AnalysisModel.getAll().then((value) => allAnalysis.addAll(value));
    await AnalysisGroupModel.getAll()
        .then((value) => analysisGroups.addAll(value));
  }

  @override
  void dispose() {
    super.dispose();
    allAnalysis.clear();
    wantedAnalysis.clear();
    analysisGroups.clear();
    checked = false;
    geted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   flexibleSpace: Padding(
      //     padding: const EdgeInsets.fromLTRB(92.0, 8.0, 92.0, .0),
      //     child: Row(
      //       children: [
      //         const Text(
      //           'بحث: ',
      //           style: TextStyle(
      //             fontSize: 18,
      //           ),
      //         ),
      //         Expanded(
      //           // width: 250,
      //           // height: 50,
      //           child: FocusableField(
      //             searchNameController,
      //             FocusNode(),
      //             'الاسم',
      //             (text) {
      //               return true;
      //             },
      //             null,
      //             null,
      //             null,
      //             false,
      //           ),
      //         ),
      //         Expanded(
      //           // width: 150,
      //           // height: 50,
      //           child: FocusableField(
      //             searchPhoneNumberController,
      //             FocusNode(),
      //             'رقم الهاتف',
      //             (text) {
      //               return true;
      //             },
      //             null,
      //             null,
      //             null,
      //             false,
      //           ),
      //         ),
      //         const SizedBox(width: 32),
      //         const Spacer(),
      //         const Text(
      //           'التاريخ: ',
      //           style: TextStyle(
      //             fontSize: 18,
      //           ),
      //         ),
      //         SizedBox(
      //           width: 200,
      //           height: 50,
      //           child: DateTimePicker(
      //             controller: periodDateTimeController,
      //             onChanged: (text) {
      //               geted = false;
      //               // print(geted);
      //               // CustomBuilderUpdater().add(0);
      //               setState(() {});
      //             },
      //             // initialValue: DateTime.now().toString(),
      //             initialDate: DateTime.now(),
      //             firstDate: DateTime(2010),
      //             lastDate: DateTime(2100),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: Column(
        children: [
          uppderRow(),
          const Divider(),
          lowerRow(),
          const Divider(),
          buttons(),
        ],
      ),
    );
  }

  Widget button(String name, Function() func, [double width = 100]) => SizedBox(
        width: width,
        height: 50,
        child: MaterialButton(
          onPressed: func,
          color: const Color.fromARGB(255, 255, 208, 0),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      );

  Widget buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        button('حفظ', () {}),
        button('تعديل', () {}),
        button('حذف', () {}),
        button('امر شغل', () {}),
        button('سحب العينات', () {}, 140),
        button('الحساب', () {}),
        button('النتائج', () {}),
      ],
    );
  }

  Widget uppderRow() {
    return Expanded(
      child: updater.UpdaterBlocWithoutDisposer(
        updater: LabPageUpperSegmentUpdater(
          init: '',
          updateForCurrentEvent: true,
        ),
        update: (context, s) {
          return Column(
            children: [
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(48.0, 4.0, 48.0, .0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 32),
                      const Text(
                        'بحث: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        // width: 250,
                        // height: 50,
                        child: FocusableField(
                          searchNameController,
                          FocusNode(),
                          'الاسم',
                          (text) {
                            return true;
                          },
                          null,
                          null,
                          null,
                          false,
                        ),
                      ),
                      Expanded(
                        // width: 150,
                        // height: 50,
                        child: FocusableField(
                          searchPhoneNumberController,
                          FocusNode(),
                          'رقم الهاتف',
                          (text) {
                            return true;
                          },
                          null,
                          null,
                          null,
                          false,
                        ),
                      ),
                      const SizedBox(width: 32),
                      const Spacer(),
                      const Text(
                        'التاريخ: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: DateTimePicker(
                          controller: periodDateTimeController,
                          onChanged: (text) {
                            geted = false;
                            // print(geted);
                            // CustomBuilderUpdater().add(0);
                            setState(() {});
                          },
                          // initialValue: DateTime.now().toString(),
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: Row(
                  children: [
                    registerWidget(),
                    PatientNotesWidget(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  FutureOr<bool?> patientNameSearch(context, String text) async {
    selectedPatientFileId = null;
    selectedReservationId = null;
    selectedReservation = null;
    foundPatients.clear();
    await PatientModel.findByName(text).listen((event) {
      foundPatients.add(event);
    }).asFuture();
    if (foundPatients.isEmpty) {
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
                  itemCount: foundPatients.length,
                  itemBuilder: (context, index) {
                    var patient = foundPatients[index];
                    return InkWell(
                      onTap: () {
                        selectedPatientFileId = patient.id;
                        nameController.text = patient.name;
                        phoneNumberController.text = patient.phone;
                        Navigator.pop(context);
                      },
                      child: Card(
                        child: Text(
                          patient.name,
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

  registerWidget() {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'بيانات المريض',
          //   style: TextStyle(
          //     fontSize: 18,
          //   ),
          // ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: NFocusableField(
                    controller: nameController,
                    node: nameNode,
                    labelTextWillBeTranslated: 'الاسم',
                    onSubmited: (text) {
                      return true;
                    },
                    onChanged: (text) => patientNameSearch(context, text),
                    nextNode: phoneNumberNode,
                    nextController: phoneNumberController,
                    whatToSayifIsEmpty: 'عذرا خانة الاسم فارغة',
                    isNumber: false,
                  ),
                ),
                Expanded(
                  child: FocusableField(
                    phoneNumberController,
                    phoneNumberNode,
                    'الهاتف',
                    (text) {
                      return true;
                    },
                    ageNode,
                    ageController,
                    'عذرا خانة الهاتف فارغة',
                    false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
                    'رقم الملف: ${selectedPatientFileId ?? '???'}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: FocusableField(
                    ageController,
                    ageNode,
                    'السن',
                    (text) {
                      return true;
                    },
                    serviceDescriptionNode,
                    serviceDescriptionController,
                    'عذرا خانة السن فارغة',
                    true,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: DropdownButton<AgeUnitType>(
                    items: [
                      ...AgeUnitType.values.map((e) {
                        var tr = e == AgeUnitType.day
                            ? 'يوم'
                            : e == AgeUnitType.year
                                ? 'سنة'
                                : 'شهر';
                        return DropdownMenuItem<AgeUnitType>(
                          value: e,
                          child: Text(
                            tr,
                          ),
                        );
                      }).toList(),
                    ],
                    value: selectedAgeUnitType,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {});
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                const Text('الجنس : '),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: DropdownButton<Gender>(
                    items: [
                      ...Gender.values.map((e) {
                        var tr = e == Gender.male ? 'ذكر' : 'انثى';
                        return DropdownMenuItem<Gender>(
                          value: e,
                          child: Text(
                            tr,
                          ),
                        );
                      }).toList(),
                    ],
                    value: selectedGenderType,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {});
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                const Text('تاريخ الحجز : '),
                const SizedBox(width: 8),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: DateTimePicker(
                    controller: reservationDateTimeController,
                    // initialValue: DateTime.now().toString(),
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2100),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: FocusableField(
                        serviceDescriptionController,
                        serviceDescriptionNode,
                        'الخدمة',
                        (text) {
                          return true;
                        },
                        totalNode,
                        totalController,
                        'عذرا خانة الخدمة فارغة',
                        false,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () async {
                        var r = await medicalServiceCrudOverlay(context);
                        if (r != null) {
                          serviceDescriptionController.text = r.description;
                          totalController.text = r.price.toString();
                          selectedMedicalService = r;
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 150,
                child: FocusableField(
                  totalController,
                  totalNode,
                  'الاجمالي',
                  (text) {
                    return true;
                  },
                  noteNode,
                  noteController,
                  'عذرا خانة الاجمالي فارغة',
                  false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget lowerRow() {
    return Expanded(
      child: Row(
        children: [
          LabAvailableAnalysisListsViewSegment(),
          // LabPatientAnalysisListsViewSegment(),
          LabReservationsViewSegment(),
        ],
      ),
    );
  }
}

Map<String, dynamic> notes = {
  'استلام بالايميل': false,
  'صائم': false,
  'استلام بالواتس اب': false,
  'علاج للسكر': false,
  'نقل دم': false,
  'علاج للضغط': false,
  'علاج للكبد': false,
  'علاج للغدد': false,
  'فيروس C': false,
  'علاج للسيولة': false,
  'مضاد حيوي': false,
  'امتناع عن الجماع': false,
  'حامل': false,
  'اثناء الدوره': false,
  'الدورة متأخرة': false,
};

class PatientNotesWidget extends StatelessWidget {
  const PatientNotesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: CheckboxListTile(
                        title: const Text('صائم'),
                        value: notes['صائم'],
                        onChanged: (value) {
                          if (value != null) {
                            notes['صائم'] = value;
                          }
                          LabPageUpperSegmentUpdater().add('');
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: CheckboxListTile(
                        title: const Text('نقل دم'),
                        value: notes['نقل دم'],
                        onChanged: (value) {
                          if (value != null) {
                            notes['نقل دم'] = value;
                          }
                          LabPageUpperSegmentUpdater().add('');
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: CheckboxListTile(
                        title: const Text('فيروس C'),
                        value: notes['فيروس C'],
                        onChanged: (value) {
                          if (value != null) {
                            notes['فيروس C'] = value;
                          }
                          LabPageUpperSegmentUpdater().add('');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: FocusableField(
                  noteController,
                  noteNode,
                  'ملاحظات',
                  (text) {
                    return true;
                  },
                  null,
                  null,
                  null,
                  false,
                ),
              ),
              // IconButton(
              //   icon: const Icon(Icons.more_horiz),
              //   onPressed: () async {
              //     var r = await notesCrudOverlay(context);
              //     if (r != null) {
              //       noteController.text = r.content;
              //     }
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...() {
//   List<Widget> children = [];
//   for (int i = 0; i < notes.entries.length; i += 2) {
//     children.add(
//       Expanded(
//         child: Row(
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   // Expanded(child: Text(notes[i].key)),
//                   // Checkbox(
//                   //   value: notes[i].value,
//                   //   onChanged: (value) {
//                   //     if (value != null) {
//                   //       notes[notes.entries.toList()[i].key] = value;
//                   //     }
//                   //     LabPageUpperSegmentUpdater().add('');
//                   //   },
//                   // )
//                 ],
//               ),
//             ),
//             // Expanded(
//             //   child: Row(
//             //     children: [
//             //       Text(notes[i + 1].key),
//             //       Checkbox(
//             //         value: notes[i + 1].value,
//             //         onChanged: (value) {
//             //           if (value != null) {
//             //             notes[notes.entries.toList()[i].key] = value;
//             //           }
//             //           LabPageUpperSegmentUpdater().add('');
//             //         },
//             //       )
//             //     ],
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//   return children;
// }(),
