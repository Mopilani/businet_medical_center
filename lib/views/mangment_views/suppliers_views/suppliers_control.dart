import 'package:businet_medical_center/models/bill_model.dart';
import 'package:businet_medical_center/models/supplier_model.dart';
import 'package:businet_medical_center/views/mangment_views/bills/bills_control.dart';
import 'package:businet_medical_center/views/widgets/done_success_ovrly_notification.dart';
import 'package:businet_medical_center/views/widgets/focusable_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

class SuppliersControle extends StatefulWidget {
  const SuppliersControle({
    Key? key,
    this.model,
    this.editMode = false,
  }) : super(key: key);
  final SupplierModel? model;
  final bool editMode;

  @override
  State<SuppliersControle> createState() => _CategoriesControleState();
}

class _CategoriesControleState extends State<SuppliersControle> {
  late FocusNode idNode;
  late FocusNode nameNode;
  late FocusNode emailNode;
  late FocusNode areaNode;
  late FocusNode townNode;
  late FocusNode stateNode;
  late FocusNode countryNode;
  late FocusNode zipCodeNode;
  late FocusNode phoneNumberNode;
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController areaController;
  late TextEditingController townController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController zipCodeController;
  late TextEditingController phoneNumberController;
  List<String> billsNo = [];
  double totalWanted = 0;
  double totalPayed = 0;

  @override
  void initState() {
    super.initState();

    idNode = FocusNode();
    nameNode = FocusNode();
    emailNode = FocusNode();
    areaNode = FocusNode();
    townNode = FocusNode();
    stateNode = FocusNode();
    countryNode = FocusNode();
    zipCodeNode = FocusNode();
    phoneNumberNode = FocusNode();

    if (widget.editMode) {
      id = widget.model!.id;
      name = widget.model!.name;
      email = widget.model!.email;
      area = widget.model!.area;
      town = widget.model!.town;
      state = widget.model!.state;
      country = widget.model!.country;
      zipCode = widget.model!.zipCode;
      phoneNumber = widget.model!.phoneNumber;
      billsNo = widget.model!.billsNo.reversed.toList();
      totalPayed = widget.model!.totalPayed;
      totalWanted = widget.model!.totalWanted;
      idController = TextEditingController(text: id.toString());
      nameController = TextEditingController(text: name);
      emailController = TextEditingController(text: email);
      areaController = TextEditingController(text: area);
      townController = TextEditingController(text: town);
      stateController = TextEditingController(text: state);
      countryController = TextEditingController(text: country);
      zipCodeController = TextEditingController(text: zipCode);
      phoneNumberController = TextEditingController(text: phoneNumber);
    } else {
      idController = TextEditingController();
      nameController = TextEditingController();
      emailController = TextEditingController();
      areaController = TextEditingController();
      townController = TextEditingController();
      stateController = TextEditingController();
      countryController = TextEditingController();
      zipCodeController = TextEditingController();
      phoneNumberController = TextEditingController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    idNode.dispose();
  }

  bool loading = false;

  final List<SupplierModel> models = [];

  late int id;
  String name = '';
  String? email;
  String? area;
  String? town;
  String? state;
  String? country;
  String? zipCode;
  String? phoneNumber;

  int currentSaleUnitDropDownValue = 0;

  @override
  Widget build(BuildContext context) {
    // _registeredSaleUnits.clear();
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.editMode ? 'edit_supplier'.tr : 'add_supplier'.tr),
        flexibleSpace: loading ? const CircularProgressIndicator() : null,
        actions: [
          MaterialButton(
            color: Colors.blue,
            child: const Text(
              'حفظ',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              setState(() {
                loading = true;
              });

              if (widget.editMode) {
                await SupplierModel(
                  id,
                  name: name,
                  email: email,
                  area: area,
                  town: town,
                  state: state,
                  country: country,
                  zipCode: zipCode,
                  phoneNumber: phoneNumber,
                  totalPayed: widget.model!.totalPayed,
                  totalWanted: widget.model!.totalWanted,
                  billsNo: widget.model!.billsNo,
                ).edit().then((value) {
                  setState(() {
                    loading = false;
                    doneSuccessfulyOverLayNotification();
                  });
                });
              } else {
                if (idController.text.isEmpty) {
                  showSimpleNotification(
                    const Text('لا يمكنك ترك معرف المورد فارغا'),
                    position: NotificationPosition.bottom,
                  );
                  return;
                }
                if (name.isEmpty) {
                  showSimpleNotification(
                    const Text('لا يمكنك ترك اسم المورد فارغا'),
                    position: NotificationPosition.bottom,
                  );
                  return;
                }
                await SupplierModel.get(id).then(
                  (value) async {
                    if (value == null) {
                      await SupplierModel(
                        id,
                        name: name,
                        email: email,
                        area: area,
                        town: town,
                        state: state,
                        country: country,
                        zipCode: zipCode,
                        phoneNumber: phoneNumber,
                        billsNo: [],
                      ).add().then((value) {
                        setState(() {
                          loading = false;
                          doneSuccessfulyOverLayNotification();
                        });
                      });
                    } else {
                      toast('معرف المورد مدرج بالفعل');
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          FocusableField(
            idController,
            idNode,
            'id',
            (result) {
              id = int.parse(result);
              return true;
            },
            nameNode,
            nameController,
            'لا يمكنك ترك معرف المورد فارغا',
            true,
          ),
          const SizedBox(height: 16),
          FocusableField(nameController, nameNode, 'name', (result) {
            name = result;
            return true;
          }, emailNode, emailController, 'لا يمكنك ترك اسم المورد فارغا'),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child:
                  FocusableField(emailController, emailNode, 'email', (result) {
                email = result;
                return true;
              }, phoneNumberNode, phoneNumberController),
            ),
            Expanded(
              child: FocusableField(
                  phoneNumberController, phoneNumberNode, 'phone', (result) {
                phoneNumber = result;
                return true;
              }, areaNode, areaController),
            ),
          ]),
          Row(children: [
            Expanded(
              child: FocusableField(areaController, areaNode, 'area', (result) {
                area = result;
                return true;
              }, townNode, townController),
            ),
            Expanded(
              child: FocusableField(townController, townNode, 'town', (result) {
                town = result;
                return true;
              }, stateNode, stateController),
            ),
            Expanded(
              child:
                  FocusableField(stateController, stateNode, 'state', (result) {
                state = result;
                return true;
              }, countryNode, countryController),
            ),
            Expanded(
              child: FocusableField(countryController, countryNode, 'country',
                  (result) {
                country = result;
                return true;
              }, zipCodeNode, zipCodeController),
            ),
          ]),
          FocusableField(zipCodeController, zipCodeNode, 'zipCode', (result) {
            zipCode = result;
            return true;
          }),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '  اجمالي المدفوع:  $totalPayed',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '  اجمالي المطلوب:  $totalWanted',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: billsNo.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    await BillModel.get(
                      int.parse(billsNo[index].split(' - ').first),
                      billsNo[index].split(' - ')[1],
                    ).then((model) {
                      if (model == null) {
                        toast('غير موجود');
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BillsControle(
                            editMode: true,
                            model: model,
                          ),
                        ),
                      );
                    });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        () {
                          var text = '';
                          var r = billsNo[index].split(' - ');
                          text += r[0];
                          text += ' - ';
                          text += billTypesTranslations[r[1]].toString();
                          text += ' - ';
                          text += billStatesTranslations[r[2]].toString();
                          text += ' - ';
                          text += r[3];
                          text += ' - ';
                          text += r[4];
                          return text;
                        }(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // const Spacer(),

          // const Spacer(),
        ],
      ),
    );
  }
}
