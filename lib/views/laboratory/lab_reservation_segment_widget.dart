
import 'dart:async';

import 'package:businet_medical_center/models/reservation_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:businet_medical_center/utils/updaters.dart';

import 'package:updater/updater.dart' as updater;

import 'package:flutter/material.dart';

import '../../view_models/laboratory_reservation_page.dart';

class LabReservationsViewSegment extends StatelessWidget {
  const LabReservationsViewSegment({Key? key}) : super(key: key);
  Widget patientsTable(context, List<ReservationModel> dayReservations) {
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
          // Row
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
                    // Expanded(
                    //   flex: 3,
                    //   child: Padding(
                    //     padding: EdgeInsets.all(4.0),
                    //     child: Text('الخدمة'),
                    //   ),
                    // ),
                    // Expanded(
                    //   child: Padding(
                    //     padding: EdgeInsets.all(4.0),
                    //     child: Text('الاجمالي'),
                    //   ),
                    // ),
                    // Expanded(
                    //   child: Padding(
                    //     padding: EdgeInsets.all(4.0),
                    //     child: Text('المدفوع'),
                    //   ),
                    // ),
                    // Expanded(
                    //   child: Padding(
                    //     padding: EdgeInsets.all(4.0),
                    //     child: Text('المتبقي'),
                    //   ),
                    // ),
                    // Expanded(
                    //   child: Padding(
                    //     padding: EdgeInsets.all(4.0),
                    //     child: Text('الكشف'),
                    //   ),
                    // ),
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
                                  // Expanded(
                                  //   flex: 3,
                                  //   child: Padding(
                                  //     padding:
                                  //         const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  //     child: Text(
                                  //         e.serviceType.description.toString()),
                                  //   ),
                                  // ),
                                  // Expanded(
                                  //   child: Padding(
                                  //     padding:
                                  //         const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  //     child: Text(e.total.toString()),
                                  //   ),
                                  // ),
                                  // Expanded(
                                  //   child: Padding(
                                  //     padding:
                                  //         const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  //     child: Text(e.payed.toString()),
                                  //   ),
                                  // ),
                                  // Expanded(
                                  //   child: Padding(
                                  //     padding:
                                  //         const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  //     child: Text(e.wanted.toString()),
                                  //   ),
                                  // ),
                                  // Expanded(
                                  //   child: Padding(
                                  //     padding:
                                  //         const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  //     child: Checkbox(
                                  //       onChanged: (value) async {
                                  //         e.hasBeenChecked = !e
                                  //             .hasBeenChecked; // chage and save to false;
                                  //         await e.edit();
                                  //         geted = false;
                                  //         ReservationScreenUpdater().add(0);
                                  //       },
                                  //       value: e.hasBeenChecked,
                                  //     ),
                                  //   ),
                                  // ),
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
          return patientsTable(context, dayPatients);
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

  @override
  Widget build(BuildContext context) {
    return Expanded(child: assingStreamBuilderWidget(context));
  }
}