import 'package:businet_medical_center/models/stock_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

class StocksControle extends StatefulWidget {
  const StocksControle({
    Key? key,
    this.model,
    this.editMode = false,
  }) : super(key: key);
  final StockModel? model;
  final bool editMode;

  @override
  State<StocksControle> createState() => _CategoriesControleState();
}

class _CategoriesControleState extends State<StocksControle> {
  late FocusNode idNode;
  late FocusNode titleNode;
  late FocusNode descriptionNode;
  late FocusNode areaNode;
  late FocusNode townNode;
  late FocusNode stateNode;
  late FocusNode countryNode;
  late FocusNode phoneNumberNode;
  late TextEditingController idController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController areaController;
  late TextEditingController townController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController phoneNumberController;

  @override
  void initState() {
    super.initState();
    // store = Firestore.initialize('');
    idNode = FocusNode();
    if (widget.editMode) {
      id = widget.model!.id;
      title = widget.model!.title;
      description = widget.model!.description;
      area = widget.model!.area;
      town = widget.model!.town;
      state = widget.model!.state;
      country = widget.model!.country;
      phoneNumber = widget.model!.phoneNumber;
      idController = TextEditingController(text: id.toString());
      titleController = TextEditingController(text: title);
      descriptionController = TextEditingController(text: description);
      areaController = TextEditingController(text: area);
      townController = TextEditingController(text: town);
      stateController = TextEditingController(text: state);
      countryController = TextEditingController(text: country);
      phoneNumberController = TextEditingController(text: phoneNumber);
    } else {
      getSaleUnit();
      idController = TextEditingController();
      titleController = TextEditingController();
      descriptionController = TextEditingController();
      areaController = TextEditingController();
      townController = TextEditingController();
      stateController = TextEditingController();
      countryController = TextEditingController();
      phoneNumberController = TextEditingController();
    }
    idNode = FocusNode();
    titleNode = FocusNode();
    descriptionNode = FocusNode();
    areaNode = FocusNode();
    townNode = FocusNode();
    stateNode = FocusNode();
    countryNode = FocusNode();
    phoneNumberNode = FocusNode();
  }

  getSaleUnit() async {
    // saleUnitModel = (await SaleUnitModel.findById(0))!;
  }

  @override
  void dispose() {
    super.dispose();
    idNode.dispose();
  }

  bool loading = false;

  final List<StockModel> models = [];

  dynamic id;
  String title = '';
  String? description;
  String? phoneNumber;
  String? town;
  String? area;
  String? state;
  String? country;

  int currentSaleUnitDropDownValue = 0;

  @override
  Widget build(BuildContext context) {
    // _registeredSaleUnits.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editMode ? 'edit_stock'.tr : 'add_stock'.tr),
        flexibleSpace: loading ? const CircularProgressIndicator() : null,
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          SizedBox(
            child: Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: idController,
                autofocus: !widget.editMode,
                enabled: !widget.editMode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'id'.tr,
                ),
                onSubmitted: (result) {
                  if (result.isEmpty) {
                    showSimpleNotification(
                      const Text('لا يمكنك ترك معرف المخزن فارغا'),
                      position: NotificationPosition.bottom,
                    );
                    return;
                  }
                  try {
                    id = int.parse(result);
                  } catch (e) {
                    showSimpleNotification(
                      const Text(
                          'تأكد من كتابتك للمعرف بصورة صحيحة حيث يحتوي على ارقام فقط'),
                      position: NotificationPosition.bottom,
                    );
                    return;
                  }
                  titleNode.requestFocus();
                  titleController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: titleController.text.length,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: titleController,
                autofocus: widget.editMode,
                focusNode: titleNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'name'.tr,
                ),
                onSubmitted: (result) {
                  if (result.isEmpty) {
                    showSimpleNotification(
                      const Text('لا يمكنك ترك اسم المخزن فارغا'),
                      position: NotificationPosition.bottom,
                    );
                    return;
                  }
                  title = result;
                  descriptionNode.requestFocus();
                  descriptionController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: descriptionController.text.length,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: descriptionController,
                focusNode: descriptionNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'description'.tr,
                ),
                onSubmitted: (result) {
                  description = result;
                  areaNode.requestFocus();
                  areaController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: areaController.text.length,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: TextField(
                    controller: areaController,
                    autofocus: widget.editMode,
                    focusNode: areaNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'area'.tr,
                    ),
                    onSubmitted: (result) {
                      area = result;
                      townNode.requestFocus();
                      townController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: townController.text.length,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: TextField(
                    controller: townController,
                    autofocus: widget.editMode,
                    focusNode: townNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'town'.tr,
                    ),
                    onSubmitted: (result) {
                      town = result;
                      stateNode.requestFocus();
                      stateController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: stateController.text.length,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: TextField(
                    controller: stateController,
                    autofocus: widget.editMode,
                    focusNode: stateNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'state'.tr,
                    ),
                    onSubmitted: (result) {
                      state = result;
                      countryNode.requestFocus();
                      countryController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: countryController.text.length,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: TextField(
                    controller: countryController,
                    autofocus: widget.editMode,
                    focusNode: countryNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: 'country'.tr,
                    ),
                    onSubmitted: (result) {
                      country = result;
                      phoneNumberNode.requestFocus();
                      phoneNumberController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: phoneNumberController.text.length,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: phoneNumberController,
                autofocus: widget.editMode,
                focusNode: phoneNumberNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  labelText: 'phone_number'.tr,
                ),
                onSubmitted: (result) {
                  phoneNumber = result;
                },
              ),
            ),
          ),
          const Spacer(),
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
                await StockModel(
                  id,
                  title: title,
                  description: description,
                  area: area,
                  town: town,
                  state: state,
                  country: country,
                  phoneNumber: phoneNumber,
                  totalProducts: 0,
                  totalValue: 0,
                ).edit().then((value) {
                  setState(() {
                    loading = false;
                  });
                  showSimpleNotification(
                    const Text(
                      'تم بنجاح',
                      style: TextStyle(fontSize: 20),
                    ),
                    position: NotificationPosition.bottom,
                  );
                });
              } else {
                if (idController.text.isEmpty) {
                  showSimpleNotification(
                    const Text('لا يمكنك ترك معرف المخزن فارغا'),
                    position: NotificationPosition.bottom,
                  );
                  return;
                }
                if (title.isEmpty) {
                  showSimpleNotification(
                    const Text('لا يمكنك ترك اسم المخزن فارغا'),
                    position: NotificationPosition.bottom,
                  );
                  return;
                }
                await StockModel.get(id).then(
                  (value) async {
                    if (value == null) {
                      await StockModel(
                        id,
                        title: title,
                        description: description,
                        area: area,
                        town: town,
                        state: state,
                        country: country,
                        phoneNumber: phoneNumber,
                        totalProducts: 0,
                        totalValue: 0,
                      ).add().then((value) {
                        setState(() {
                          loading = false;
                          showSimpleNotification(
                            const Text(
                              'تم بنجاح',
                              style: TextStyle(fontSize: 20),
                            ),
                            position: NotificationPosition.bottom,
                          );
                        });
                      });
                    } else {
                      toast('معرف المنتج مدرج بالفعل');
                    }
                  },
                );
              }
            },
          ),
          const Spacer(),
        ],
      ),
      // FutureBuilder<List<StockModel>>(
      //   future: StockModel.getAll(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return const Text('حدث خطأ اثناء تحميل البيانات');
      //     }
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CircularProgressIndicator();
      //     }
      //     if (snapshot.hasData) {
      //       models.addAll(snapshot.data!);
      //     }
      //     return Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Column(
      //         children: models.map(
      //           (model) {
      //             return Text(model.title);
      //           },
      //         ).toList(),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
