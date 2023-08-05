import 'package:businet_medical_center/models/lab/analysis_group_model.dart';
import 'package:businet_medical_center/models/lab/analysis_model.dart';
import 'package:businet_medical_center/models/medical_service_model.dart';
import 'package:businet_medical_center/models/patient_model.dart';
import 'package:businet_medical_center/models/reservation_model.dart';
import 'package:flutter/material.dart';

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

AgeUnitType selectedAgeUnitType = AgeUnitType.year;
MedicalServiceModel? selectedMedicalService;

TextEditingController periodDateTimeController =
    TextEditingController(text: DateTime.now().toString());

// For Search
TextEditingController searchPhoneNumberController = TextEditingController();
TextEditingController searchNameController = TextEditingController();

List<PatientModel> foundPatients = [];
PersistentBottomSheetController? bottomSheetController;

bool checked = false;
bool geted = false;
List<ReservationModel> dayPatients = [];

List<AnalysisModel> allAnalysis = [];
List<AnalysisModel> wantedAnalysis = [];
List<AnalysisGroupModel> analysisGroups = [];
