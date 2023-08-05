import 'package:businet_medical_center/models/navigator_model.dart';
import 'package:businet_medical_center/models/sku_model.dart';
import 'package:businet_medical_center/utils/system_db.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:overlay_support/overlay_support.dart';

import 'package:updater/updater.dart' as updater;

import 'sku_controle.dart';

class StockProductsView extends StatefulWidget {
  const StockProductsView({Key? key, this.choosing = false}) : super(key: key);
  final bool choosing;

  @override
  State<StockProductsView> createState() => _StockProductsViewState();
}

List<SKUModel> skus = [];

enum SKUProperties {
  price,
  costPrice,
  salePercent,
  discount,
  createDate,
  productionDate,
  expierDate,
  lastUpdate,
  category,
  subcategory,
  saleUnit,
  supplier,
  stock,
  qunatity,
  description,
}

class _StockProductsViewState extends State<StockProductsView> {
  int currentSubCatgDropDownValue = 0;
  int showMethodDropDownValue = 0;
  String searchWithDropDownValue = 'بالاسم';
  int show = 2;
  late String catg;
  late SKUProperties property = SKUProperties.price;

  bool searchMode = false;
  bool loading = false;

  final List<String> catgs = [
    'السعر',
    'سعر التكلفة',
    'نسبة البيع',
    'الحسم',
    'تاريخ الانشاء',
    'تاريخ الانتاج',
    'تاريخ الانتهاء',
    'تاريخ اخر تحديث',
    'الشريحة الرئيسية',
    'الشريحة الفرعية',
    'وحدة البيع',
    'المورد',
    'المخزن',
    'الكمية',
    'الاسم',
  ];
  final List<String> showMethods = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
  ];

  @override
  void initState() {
    super.initState();
    catg = catgs[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  String fieldName = 'description';
  Map<String, String> searchFieldNames = {
    'بالاسم': 'description',
    'المعرف': 'id',
    'الباركود': 'barcode',
    // 'سعر البيع': 'salePrice',
    // 'سعر التكلفة': 'costPrice',
    // 'الكمية': 'quantity',
    // '': '',
  };

  var skip = 0;

  @override
  Widget build(BuildContext context) {
    if (searchMode) {
    } else {
      skus.clear();
      SystemMDBService.db
          .collection('skus')
          .find(mongo.where.skip(skip).limit(50))
          .listen((data) {
        skus.add(SKUModel.fromMap(data));
        SKUsUpdater().add('');
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (!loading) {
              Navigator.pop(context);
            } else {
              toast(
                  'الخروج اثناء تحميل الباينات قد يؤدي الى اخطاء في التطبيق, الرجاء الانتظار...');
            }
          },
        ),
        actions: [
          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                enabled: !loading,
                autofocus: widget.choosing,
                controller: TextEditingController(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(4),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        // color: Colors.white,
                        ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // focusColor: Colors.white,
                  // hoverColor: Colors.white,
                  iconColor: Colors.white,
                  fillColor: loading ? Colors.black12 : Colors.white,
                  filled: true,
                  icon: searchMode
                      ? IconButton(
                          icon: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                          onPressed: () {
                            setState(() {
                              searchMode = false;
                            });
                          },
                        )
                      : const SizedBox(),
                ),
                style: const TextStyle(),
                onSubmitted: (text) async {
                  searchMode = true;
                  dynamic value;
                  dynamic selector;
                  if (fieldName == 'id') {
                    value = int.parse(text);
                    selector = mongo.where.eq(fieldName, value);
                  } else {
                    value = text.toLowerCase();
                    // selector = mongo.where.match(fieldName, value);
                  }
                  skus.clear();
                  loading = true;
                  setState(() {});
                  SystemMDBService.db.collection('skus').find(selector)
                      // .find(mongo.where.skip(skip).limit(50))
                      .listen(
                    (data) {
                      // print(value);
                      if (fieldName != 'id' &&
                          data[fieldName]
                              .toString()
                              .toLowerCase()
                              .contains(value)) {
                        skus.add(SKUModel.fromMap(data));
                        // SKUsUpdater().add('');
                        setState(() {});
                        // print(skus);
                      } else if (fieldName == 'id') {
                        skus.add(SKUModel.fromMap(data));
                        setState(() {});
                      }
                    },
                    onDone: () {
                      loading = false;
                      setState(() {});
                    },
                    onError: (e) {
                      loading = false;
                      setState(() {});
                    },
                  );
                  // skus;
                },
              ),
            ),
          ),
          Row(
            children: [
              const Text('بحث بـ'),
              const SizedBox(width: 8),
              DropdownButton<String>(
                items: searchFieldNames.entries.toList().map(
                  (element) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        setState(() {
                          fieldName = element.value;
                        });
                      },
                      value: element.key,
                      child: Row(
                        children: [
                          Text(
                            element.key,
                            style: TextStyle(
                              color: fieldName == element.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
                value: searchWithDropDownValue,
                onChanged: (result) {
                  setState(() {
                    searchWithDropDownValue = result!;
                    // property = showMethods[showMethodDropDownValue];
                  });
                },
              ),
            ],
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.skip_next_rounded),
            onPressed: () {
              setState(() {
                // if (skip >= 0) return;
                skip += 50;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous_rounded),
            onPressed: () {
              if (skip <= 0) return;
              setState(() {
                skip -= 50;
              });
            },
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              const Text('العرض'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                items: showMethods.map(
                  (element) {
                    return DropdownMenuItem<int>(
                      onTap: () {
                        setState(() {
                          show = int.parse(element);
                        });
                      },
                      value: showMethods.indexOf(element),
                      child: Row(
                        children: [
                          Text(
                            element,
                            style: TextStyle(
                              color: show == int.parse(element)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
                value: showMethodDropDownValue,
                onChanged: (result) {
                  setState(() {
                    showMethodDropDownValue = result!;
                    // property = showMethods[showMethodDropDownValue];
                  });
                },
              ),
            ],
          ),
          const SizedBox(width: 16),
          DropdownButton<int>(
            items: catgs.map(
              (element) {
                return DropdownMenuItem<int>(
                  onTap: () {
                    setState(() {
                      catg = element;
                    });
                  },
                  value: catgs.indexOf(element),
                  child: Row(
                    children: [
                      Text(
                        element,
                        style: TextStyle(
                          color: catg == element ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
            value: currentSubCatgDropDownValue,
            onChanged: (result) {
              setState(() {
                currentSubCatgDropDownValue = result!;
                property = SKUProperties.values[currentSubCatgDropDownValue];
                // print(property);
              });
            },
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              SysNav.push(
                context,
                const ProductsControle(),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: updater.UpdaterBloc(
        updater: SKUsUpdater(
          updateForCurrentEvent: true,
        ),
        update: (context, snapshot) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: show,
              childAspectRatio: show == 1
                  ? 16
                  : show == 2
                      ? 8
                      : show == 3
                          ? 6
                          : show == 4
                              ? 4
                              : show == 5
                                  ? 4
                                  : 3,
            ),
            controller: ScrollController(),
            itemCount: skus.length,
            itemBuilder: (context, index) {
              return InkWell(
                borderRadius: BorderRadius.circular(15),
                focusColor: Colors.black12,
                onTap: () async {
                  if (widget.choosing) {
                    Navigator.pop(context, skus[index]);
                    return;
                  }
                  await SysNav.push(
                    context,
                    ProductsControle(
                      editMode: true,
                      skuModel: skus[index],
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  height: 50,
                  // width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skus[index].description.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        () {
                          switch (property) {
                            case SKUProperties.price:
                              return skus[index].salePrice.toString();

                            case SKUProperties.costPrice:
                              return skus[index].costPrice.toString();

                            case SKUProperties.salePercent:
                              return skus[index].salePercent.toString();

                            case SKUProperties.discount:
                              return skus[index].disPer.toString();

                            case SKUProperties.createDate:
                              return skus[index].createDate.toString();

                            case SKUProperties.productionDate:
                              return skus[index].productionDate.toString();

                            case SKUProperties.expierDate:
                              return skus[index].expierDate.toString();

                            case SKUProperties.lastUpdate:
                              return skus[index].lastUpdate.toString();

                            case SKUProperties.category:
                              return skus[index]
                                  .catgoryModel!
                                  .catgoryName
                                  .toString();

                            case SKUProperties.subcategory:
                              return skus[index]
                                  .subCatgModel!
                                  .subcatgoryName
                                  .toString();

                            case SKUProperties.saleUnit:
                              return skus[index].saleUnitModel!.name.toString();

                            case SKUProperties.supplier:
                              return skus[index].supplierModel!.name.toString();

                            case SKUProperties.stock:
                              return skus[index].stockModel!.title.toString();

                            case SKUProperties.qunatity:
                              return skus[index].quantity.toString();

                            case SKUProperties.description:
                              return skus[index].description.toString();
                          }
                        }(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            // children: [],
          );
          // }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class SKUsUpdater extends updater.Updater {
  SKUsUpdater({
    initialState,
    super.updateForCurrentEvent = false,
  }) : super(initialState);
}


// class StaView extends StatelessWidget {
//   const StaView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Map<String, dynamic>>(
//       stream: SKUModel.streamData(),
//       builder: (context, snapshot) {
//         print(snapshot.data);
//         if (snapshot.hasData) {
//           // skus.add(SKUModel.fromMap(snapshot.data!));
//           return ListView.builder(
//             itemCount: skus.length,
//             itemBuilder: (context, index) {
//               return Container(
//                 child: Text(skus[index].createDate.toString()),
//               );
//             },
//             // children: [],
//           );
//         }

//         if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               snapshot.error.toString(),
//             ),
//           );
//         }

//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
// }
