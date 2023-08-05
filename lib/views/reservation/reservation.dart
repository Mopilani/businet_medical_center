import 'dart:async';

import 'package:businet_medical_center/models/medical_service_model.dart';
import 'package:businet_medical_center/models/patient_model.dart';
import 'package:businet_medical_center/models/payment_method_model.dart';
import 'package:businet_medical_center/models/processes_model.dart';
import 'package:businet_medical_center/models/reservation_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:businet_medical_center/utils/updaters.dart';
import 'package:businet_medical_center/views/examination/examination_page_widget.dart';
import 'package:businet_medical_center/views/widgets/datetime_picker.dart';
import 'package:businet_medical_center/views/widgets/focusable_field.dart';
import 'package:businet_medical_center/views/widgets/overlay_widgets.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:updater/updater.dart' as updater;

import 'flying_widgets.dart';

class ReservationViews extends StatefulWidget {
  const ReservationViews({
    Key? key,
    required this.examination,
  }) : super(key: key);
  final bool examination;

  @override
  State<ReservationViews> createState() => _ReservationViewsState();
}

int? selectedReservationId;
ReservationModel? selectedReservation;
int? selectedPatientFileId;
TextEditingController nameController = TextEditingController();
TextEditingController ageController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();
TextEditingController reservationDateTimeController =
    TextEditingController(text: DateTime.now().toString());
TextEditingController reservationListOfDateTimeController =
    TextEditingController(text: DateTime.now().toString());
TextEditingController noteController = TextEditingController();
TextEditingController totalController = TextEditingController();
TextEditingController serviceDescriptionController = TextEditingController();
FocusNode nameNode = FocusNode();
FocusNode ageNode = FocusNode();
FocusNode phoneNumberNode = FocusNode();
FocusNode dateTimeNode = FocusNode();
FocusNode noteNode = FocusNode();
FocusNode totalNode = FocusNode();
FocusNode serviceDescriptionNode = FocusNode();

Gender selectedGenderType = Gender.male;

class _ReservationViewsState extends State<ReservationViews> {
  AgeUnitType selectedAgeUnitType = AgeUnitType.year;
  MedicalServiceModel? selectedMedicalService;

  TextEditingController periodDateTimeController =
      TextEditingController(text: DateTime.now().toString());

  // For Search
  TextEditingController searchPhoneNumberController = TextEditingController();
  TextEditingController searchNameController = TextEditingController();

  List<PatientModel> foundPatients = [];
  PersistentBottomSheetController? bottomSheetController;

  PageController pageController = PageController();

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    getAwaiters();
  }

  getAwaiters() async {
    paymentMethodModel = (await PaymentMethodModel.get(0))!;
  }

  @override
  void dispose() {
    super.dispose();
    selectedReservationId = null;
    selectedPatientFileId = null;
    selectedReservation = null;
  }

  Widget patientsTable(List<ReservationModel> dayReservations) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 350,
      child: Column(
        children: [
          // const Text(
          //   'الحجوزات',
          //   style: TextStyle(
          //     fontSize: 20,
          //   ),
          // ),
          Row(
            children: [
              const Text(
                'بحث: ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                width: 250,
                height: 50,
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
              SizedBox(
                width: 150,
                height: 50,
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
          Expanded(
            child: Column(
              children: [
                Row(
                  children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text('الرقم'),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text('الاسم'),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text('الخدمة'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                       
                       
                              child: Text('الاجمالي'),
                            ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text('المدفوع'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text('المتبقي'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text('الكشف'),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dayReservations.length,
                    itemBuilder: (context, index) {
                      ReservationModel e = dayReservations[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              selectedReservation = e;
                              // cancelAny();
                              // totalPrice = selectedReservation!.total;
                              // wanted = selectedReservation!.total;
                              selectedPatientFileId = e.patientId;
                              selectedReservationId = e.id;
                              nameController.text = e.patientName;
                              phoneNumberController.text = e.patientphone;
                              totalController.text = e.total.toString();
                              reservationDateTimeController.text =
                                  e.dateTime.toString();
                              serviceDescriptionController.text =
                                  e.serviceType.description;
                              ageController.text = e.age.toString();
                              noteController.text = e.note;
                              selectedGenderType = e.gender;
                              selectedAgeUnitType = e.ageUnitType;
                              ReservationScreenUpdater().add(0);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedReservationId == e.id
                                    ? Colors.black26
                                    : null,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                      child: Text(e.patientDialyId.toString()),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                      child: Text(e.patientName.toString()),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                      child: Text(
                                          e.serviceType.description.toString()),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                      child: Text(e.total.toString()),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                      child: Text(e.payed.toString()),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                      child: Text(e.wanted.toString()),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                      child: Checkbox(
                                        onChanged: (value) async {
                                          e.hasBeenChecked = !e
                                              .hasBeenChecked; // chage and save to false;
                                          await e.edit();
                                          geted = false;
                                          ReservationScreenUpdater().add(0);
                                        },
                                        value: e.hasBeenChecked,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            height: 8,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    // SystemMDBService.db.collection('patients').drop();
    // SystemMDBService.db.collection('reservations').drop();
    // streamBuilderWidget = assingStreamBuilderWidget(context);

    return Scaffold(
      appBar: AppBar(
        title: updater.UpdaterBlocWithoutDisposer(
          updater: ReservationScreenAppBarThisIsJustForAppBarTextUpdater(
            init: '',
            updateForCurrentEvent: true,
          ),
          update: (context, s) {
            return Text(
              currentPageIndex == 0 ? 'الحجوزات' : 'الكشف',
              style: const TextStyle(
                fontSize: 20,
              ),
            );
          },
        ),
        centerTitle: true,
        flexibleSpace: !widget.examination
            ? null
            : updater.UpdaterBlocWithoutDisposer(
                updater: ReservationScreenAppBarUpdater(
                  init: '',
                  updateForCurrentEvent: true,
                ),
                update: (context, s) {
                  return SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(56, 8, 56, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MaterialButton(
                            height: 60,
                            onPressed: () {
                              currentPageIndex = 0;
                              pageController.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.ease,
                              );
                              geted = false;
                              setState(() {});
                              ReservationScreenAppBarUpdater().add('');
                              ReservationScreenAppBarThisIsJustForAppBarTextUpdater()
                                  .add('');
                            },
                            color: Colors.black87,
                            child: const Text('الحجز'),
                          ),
                          const SizedBox(width: 12),
                          MaterialButton(
                            height: 60,
                            onPressed: () {
                              if (selectedReservation == null) return;
                              currentPageIndex = 1;
                              pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.ease,
                              );
                              ReservationScreenAppBarUpdater().add('');
                              ReservationScreenAppBarThisIsJustForAppBarTextUpdater()
                                  .add('');
                            },
                            color: Colors.black87,
                            child: const Text('الكشف'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      body: updater.UpdaterBlocWithoutDisposer(
        updater: ReservationScreenUpdater(
          init: '',
          updateForCurrentEvent: true,
        ),
        update: (context, s) {
          return PageView(
            controller: pageController,
            children: [
              reservationPage(context),
              ExaminationPage(reservation: selectedReservation),
            ],
          );
        },
      ),
    );
  }

  bool checked = false;
  bool geted = false;
  List<ReservationModel> dayPatients = [];

  // Widget? streamBuilderWidget;

  Widget assingStreamBuilderWidget(context) {
    if (!geted) {
      dayPatients.clear();
      SystemMDBService.db.collection('reservations').find().transform(
        StreamTransformer<Map<String, dynamic>, ReservationModel>.fromHandlers(
          handleData: (data, sink) {
            sink.add(ReservationModel.fromMap(data));
          },
        ),
      ).transform<ReservationModel>(
          StreamTransformer<ReservationModel, ReservationModel>.fromHandlers(
              handleData: (model, sink) {
        int r1;
        int r2;
        // if (withTime) {
        //   r1 = model.dateTime.compareTo(from);
        //   r2 = model.dateTime.compareTo(to);
        // } else {
        DateTime from = DateTime.parse(periodDateTimeController.text);
        DateTime to = DateTime.parse(periodDateTimeController.text);
        DateTime createDate = DateTime(
          model.dateTime.year,
          model.dateTime.month,
          model.dateTime.day,
        );
        r1 = createDate.compareTo(DateTime(
          from.year,
          from.month,
          from.day,
        ));
        r2 = createDate.compareTo(DateTime(
          to.year,
          to.month,
          to.day,
        ));
        // } print('${model.dateTime} ${r1 == 1} && ${r2 == 1}');
        // print(model.patientName);
        print('===================');
        print('${model.dateTime} $r1 && $r2');
        print((r1 != 0 && r2 != 0));
        print((r1 == 1 && r2 == -1));
        // print('===================');
        if ((r1 != 0 && r2 != 0) || (r1 == 1 && r2 == -1)) {
          return;
        }
        sink.add(model);
      })).listen((event) {
        dayPatients.add(event);
        CustomBuilderUpdater().add(0);
      }).onDone(() {
        geted = true;
      });
    }

    return updater.StatelessUpdaterBloc(
      updater: CustomBuilderUpdater(
        init: '',
        updateForCurrentEvent: true,
      ),

      // ReservationModel.collectOfTime(
      //   DateTime.parse(reservationListOfDateTimeController.text),
      //   DateTime.now().add( const Duration(days: 1), ), ),
      update: (context, snap) {
        if (snap.hasError) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 350,
            child: Center(
              child: Text('حدث خطأ ما:  ${snap.error}'),
            ),
          );
        }
        if (snap.hasData) {
          // print('/////////////');
          return patientsTable(dayPatients);
        }

        // if (snap.connectionState == ConnectionState.waiting) {
        //   return SizedBox(
        //     height: MediaQuery.of(context).size.height - 350,
        //     child: const Center(
        //       child: CircularProgressIndicator(),
        //     ),
        //   );
        // } else {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 350,
          child: const Center(
            child: Text(
              'لا يوجد حجوزات لعرضها',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        );
        // }
      },
    );
  }

  Widget reservationPage(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          // if (streamBuilderWidget != null)
          // streamBuilderWidget!,
          // else
          assingStreamBuilderWidget(context),
          if (!widget.examination)
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'بيانات المريض',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
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
                                  onChanged: (text) =>
                                      patientNameSearch(context, text),
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
                                      var tr =
                                          e == Gender.male ? 'ذكر' : 'انثى';
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
                                      var r = await medicalServiceCrudOverlay(
                                          context);
                                      if (r != null) {
                                        serviceDescriptionController.text =
                                            r.description;
                                        totalController.text =
                                            r.price.toString();
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
                            IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () async {
                                var r = await notesCrudOverlay(context);
                                if (r != null) {
                                  noteController.text = r.content;
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ProcessesModel.stored!.lastReservationId.toString(),
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 170,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 50,
                                      child: MaterialButton(
                                        onPressed:
                                            saveReservationButtonFunction,
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
                                        onPressed: selectedReservationId == null
                                            ? null
                                            : () {},
                                        color: Colors.black87,
                                        child: const Text(
                                          'تعديل',
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
                                        onPressed: selectedReservationId == null
                                            ? null
                                            : () {
                                                ReservationModel.delete(
                                                    selectedReservationId!);
                                              },
                                        color: Colors.black87,
                                        child: const Text(
                                          'حذف',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 305,
                                  height: 50,
                                  child: MaterialButton(
                                    color: Colors.black87,
                                    onPressed: selectedReservationId == null
                                        ? null
                                        : () async {},
                                    child: const Text(
                                      'طباعة ايصال',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 50,
                                      child: MaterialButton(
                                        color: Colors.black87,
                                        onPressed: selectedReservationId == null
                                            ? null
                                            : () async {
                                                getBillAgree(context,
                                                    selectedReservation!);
                                              },
                                        child: const Text(
                                          'الحساب',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      height: 50,
                                      child: MaterialButton(
                                        color: Colors.black87,
                                        onPressed: selectedReservationId == null
                                            ? null
                                            : () async {},
                                        child: const Text(
                                          'الكرت',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> saveReservationButtonFunction() async {
    var reservationId = await ProcessesModel.stored!.requestReservationId();
    var patientDialyId = await ProcessesModel.stored!.requestDialyId();
    var patientId = await ProcessesModel.stored!.requestPatientId();

    if (selectedMedicalService == null) {
      toast(
        'لا يمكنك ترك خانة نوع الفحص الطبي فارغة',
      );
      return;
    }
    if (reservationDateTimeController.text.isEmpty) {
      toast(
        'لا يمكنك ترك خانة التاريخ فارغة',
      );
      return;
    }
    if (ageController.text.isEmpty) {
      toast(
        'لا يمكنك ترك خانة العمر فارغة',
      );
      return;
    }
    if (totalController.text.isEmpty) {
      toast(
        'لا يمكنك ترك خانة الاجمالي فارغة',
      );
      return;
    }
    if (nameController.text.isEmpty) {
      toast(
        'لا يمكنك ترك خانة اسم المريض فارغة',
      );
      return;
    }

    int age = int.parse(ageController.text);
    double total = double.parse(totalController.text);

    PatientModel patient = PatientModel(
      patientId,
      name: nameController.text,
      phone: phoneNumberController.text,
    );

    ReservationModel reservationModel = ReservationModel(
      reservationId,
      age: age,
      ageUnitType: selectedAgeUnitType,
      dateTime: DateTime.parse(reservationDateTimeController.text),
      gender: selectedGenderType,
      hasBeenChecked: false,
      note: noteController.text,
      payed: 0,
      serviceType: selectedMedicalService!,
      total: total,
      wanted: total,
      patientDialyId: patientDialyId,
      patientId: patientId,
      patientName: patient.name,
      patientphone: patient.phone,
      debitWanted: realPayed,
      realPayed: debitWanted,
      receiptPaymentMethods: receiptPaymentMethods,
    );

    await reservationModel.add();
    await patient.add();
    await ProcessesModel.stored!.edit();
    toast(
      'تم الحفظ',
    );
    ReservationScreenUpdater().add(0);
    geted = false;
    nameController.clear();
    ageController.clear();
    phoneNumberController.clear();
    // reservationDateTimeController.clear();
    reservationListOfDateTimeController.clear();
    noteController.clear();
    totalController.clear();
    serviceDescriptionController.clear();
    selectedGenderType = Gender.male;
    selectedAgeUnitType = AgeUnitType.year;
  }
}

  // await FlutterPlatformAlert.showCustomAlert(
                              //   windowTitle: 'رقم ${e.id}',
                              //   text: 'This is body',
                              // );
                              // var r = AudioPlayer();
                              // String path =
                              //     'C:/Users/Mopilani/Music/Spirit(MP3_128K).mp3';
                              // Source source = DeviceFileSource(path);
                              // await r.play(source);
                              // final clickedButton =
                              //     await FlutterPlatformAlert.showAlert(
                              //   windowTitle: 'رقم ${e.id}',
                              //   text: 'This is body',
                              //   alertStyle: AlertButtonStyle.yesNoCancel,
                              //   iconStyle: IconStyle.asterisk,
                              // );
                              // print(clickedButton.name);