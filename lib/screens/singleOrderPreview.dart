import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nilesoft_app/Databasemodels/SalesModel.dart';
import 'package:nilesoft_app/Databasemodels/orderModel.dart';
import 'package:nilesoft_app/ItemstoShow.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:nilesoft_app/screens/SalesPreview.dart';
import '../CustomersToShow.dart';
import '../DatabaseHelper.dart';
import 'home.dart';

class SingleOrder extends StatefulWidget {
  final int index;
  const SingleOrder({Key? key, required this.index}) : super(key: key);

  @override
  State<SingleOrder> createState() => _MyHomePageState();
}

SalesHeadModel salesHeadModel = SalesHeadModel();
SalesDtlModel salesDtlModel = SalesDtlModel();
List<SalesDtlModel> salesdtl = [];
SalesModel invoiceModel = SalesModel();
int globalIndex = 0;
double ttotal = 0;
double tdiscount = 0;

int editOrAdd = -1;
SalesHeadModel? salesHeadModel1;
List salesDtlModel1 = [];
String? itemId;
List invoiceModelList = [];

late DatabaseHelper databaseHelper;

class _MyHomePageState extends State<SingleOrder> {
  CustomersToShow customersModel = CustomersToShow([".."], [""]);
  ItemsToShow itemsModel = ItemsToShow([".."], [""], [], [], []);
  int id = -1;
  int globalIndex = 0;
  int editOrAdd = -1;
  OrderHeadModel? orderHeadModel;
  List<OrderDtlModel> orderDtlModel = [];
  String? itemId;
  final itemTextField = TextEditingController();

  final clientTextField = TextEditingController();
  late DatabaseHelper dbHelper;
  int counter = 1;
  String? myid;
  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    dbHelper.initDB().whenComplete(() async {
      setState(() {
        // print("x");
        // print(dbHelper.retrieveUsers().toString());
        // print(dbHelper.retrieveUsers2());
      });
    });
    //invoiceModelList = [];
    invoiceModelList.clear();
    salesDtlModel = SalesDtlModel();
    invoiceModel = SalesModel();
    sendin();
    getCustomer();
    getItems();
  }

  sendin() async {
    await sendInvoices();
  }

  String? clientName;
  String? itemName;

  String dropdownvalue = 'اختر اسم العميل';
  String dropdownvalue2 = 'اختر اسم المنتج';
  final byanTextField = TextEditingController();
  List<TextEditingController> priceControllers = [TextEditingController()];
  List<TextEditingController> taxControllers = [TextEditingController()];
  List<TextEditingController> discountControllers = [TextEditingController()];
  List<TextEditingController> qtyControllers = [TextEditingController()];
  List<TextEditingController> itemsControllers = [TextEditingController()];
  final priceTextField = TextEditingController();
  final discountTextField = TextEditingController();
  final taxTextField = TextEditingController();
  final qty = TextEditingController();
  int cqty = 0;

  Future<void> getItems() async {
    String s = "select * from items";

    List<Map<String, Object?>> queryResult = await dbHelper.db.rawQuery(s);
    for (int i = 0; i < queryResult.length; i++) {
      itemsModel.id.add(queryResult[i]["id"].toString());
      itemsModel.name.add(queryResult[i]["name"].toString());
      itemsModel.price.add(double.parse(queryResult[i]["price"].toString()));
      itemsModel.qty.add(double.parse(queryResult[i]["qty"].toString()));
    }
  }

  Future<void> getCustomer() async {
    String s = "select * from Customers";

    List<Map<String, Object?>> queryResult = await dbHelper.db.rawQuery(s);
    for (int i = 0; i < queryResult.length; i++) {
      customersModel.id.add(queryResult[i]["id"].toString());
      customersModel.name.add(queryResult[i]["name"].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("استعراض الطلبيات"),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: SizedBox(
                height: MediaQuery.of(context).size.height / 1,
                child: Column(children: [
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 2,
                  // ),

                  Card(
                      elevation: 1,
                      shadowColor: const Color.fromRGBO(0, 0, 0, 1),
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromRGBO(139, 139, 139, .5),
                              width: 1),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15.0),
                            bottom: Radius.circular(15.0),
                          )),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
                                      child: EasyAutocomplete(
                                          suggestions: customersModel.name,
                                          controller: clientTextField,
                                          decoration: const InputDecoration(
                                              hintText: "اختر العميل"),
                                          suggestionTextStyle:
                                              const TextStyle(fontSize: 18),
                                          onChanged: (value) =>
                                              // ignore: avoid_print
                                              print('onChanged value: $value'),
                                          onSubmitted: (value) {
                                            print('onSubmitted value: $value');
                                            setState(() {
                                              clientName = value;
                                              // //  clientId = (customersModel
                                              //       .id[customersModel.name.indexOf(value)]);
                                            });
                                          }),
                                    ),
                                  ),
                                )
                              ]),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 100,
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: TextFormField(
                                style: const TextStyle(
                                    fontStyle: FontStyle.normal),
                                controller: byanTextField,
                                decoration: const InputDecoration(
                                  hintText: 'البيان',
                                  labelText: 'البيان',
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("اجمالي الخصم" + calcDiscount().toString()),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      Text("اجمالي الفاتورة" + calcTotal().toString()),
                    ],
                  ),
                  Column(children: [
                    SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1.8,
                        child: myWidget1(context),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height / 20,
                          child: ElevatedButton(
                              onPressed: () async {
                                for (var i = 0; i < salesdtl.length; i++) {
                                  await dbHelper.insertInvoiceDtl(salesdtl[i]);
                                }
                                databaseHelper.db.rawUpdate(
                                    "UPDATE orderHead SET clientName= '$clientName' where id=" +
                                        invoiceModelList[widget.index]
                                                    ['salesdtlModel']
                                                [globalIndex]['id']
                                            .toString());
                                setState(() {
                                  qty.text = "";
                                  priceTextField.text = "";
                                  taxTextField.text = "";
                                  discountTextField.text = "";
                                });
                                salesdtl = [];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyApp1()));
                              },
                              child: const Text(
                                "انهاء الفاتورة",
                                style: TextStyle(fontSize: 12),
                              )),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height / 20,
                          child: ElevatedButton(
                              onPressed: () {
                                //  dbHelper.retrieveUsers2();
                                setState(() {
                                  editOrAdd = 0;
                                  itemTextField.text = "";
                                });

                                _displayDialog(context);
                              },
                              child: const Text(
                                "إضافة صنف جديد",
                                style: TextStyle(fontSize: 12),
                              )),
                        ),
                      ],
                    ),
                  ]),
                ]))));
  }

  double calcTotal() {
    ttotal = 0;
    for (var i = 0;
        i < invoiceModelList[widget.index]['salesdtlModel'].length;
        i++) {
      ttotal = ttotal +
          (invoiceModelList[widget.index]['salesdtlModel'][i]['qty'] *
                  invoiceModelList[widget.index]['salesdtlModel'][i]['price'] -
              invoiceModelList[widget.index]['salesdtlModel'][i]['discount']) +
          (invoiceModelList[widget.index]['salesdtlModel'][i]['qty'] *
                  invoiceModelList[widget.index]['salesdtlModel'][i]['price']) *
              (invoiceModelList[widget.index]['salesdtlModel'][i]['tax'] / 100);
    }
    return ttotal;
  }

  double calcDiscount() {
    tdiscount = 0;
    for (var i = 0;
        i < invoiceModelList[widget.index]['salesdtlModel'].length;
        i++) {
      tdiscount = tdiscount +
          (invoiceModelList[widget.index]['salesdtlModel'][i]['discount']);
    }
    return tdiscount;
  }

  Future<void> sendInvoices() async {
    databaseHelper = DatabaseHelper();
    databaseHelper.initDB().whenComplete(() async {});
    String s1 = "select * from orderHead";

    final List<Map<String, Object?>> invoiceHead =
        await databaseHelper.db.rawQuery(s1);

    for (int i = 0; i < invoiceHead.length; i++) {
      salesHeadModel.accid = (invoiceHead[i]["clientId"].toString());
      salesHeadModel.clientName = invoiceHead[i]["clientName"].toString();
      salesHeadModel.descr = invoiceHead[i]["notes"].toString();
      databaseHelper.db.rawUpdate("UPDATE orderHead SET sent = 1 where id=" +
          invoiceHead[i]["id"].toString());
      String s2 =
          "select * from orderDtl where id=" + invoiceHead[i]["id"].toString();

      final List<Map<String, Object?>> invoicDtl =
          await databaseHelper.db.rawQuery(s2);
      databaseHelper.db.rawUpdate("UPDATE orderDtl SET sent = 1 where id=" +
          invoiceHead[i]["id"].toString());
      invoiceModel.salesdtlModel = [];

      for (int j = 0; j < invoicDtl.length; j++) {
        salesDtlModel = SalesDtlModel();
        salesDtlModel.id = (invoicDtl[j]["id"].toString());
        salesDtlModel.itemId = invoicDtl[j]["itemId"].toString();
        salesDtlModel.itemName = invoicDtl[j]["itemName"].toString();
        salesDtlModel.price = double.parse(invoicDtl[j]["price"].toString());
        salesDtlModel.disam = double.parse(invoicDtl[j]["discount"].toString());
        salesDtlModel.tax = double.parse(invoicDtl[j]["tax"].toString());
        salesDtlModel.qty = double.parse(invoicDtl[j]["qty"].toString());
        invoiceModel.salesdtlModel.add(salesDtlModel);
      }
      invoiceModel.salesHeadModel = salesHeadModel;
      setState(() {
        invoiceModelList.add(invoiceModel.toJson());
      });
    }
    clientTextField.text =
        invoiceModelList[widget.index]['clientName'].toString();
    byanTextField.text = invoiceModelList[widget.index]['notes'].toString();
    var s = jsonEncode(invoiceModelList);

    print(s);
  }

  Widget myWidget1(BuildContext context) {
    return ListView.builder(
        itemCount: invoiceModelList[widget.index]['salesdtlModel'].length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            controller: ScrollController(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: Card(
                elevation: 1,
                shadowColor: const Color.fromRGBO(0, 0, 0, 1),
                shape: const RoundedRectangleBorder(
                    side: BorderSide(
                        color: Color.fromRGBO(139, 139, 139, .5), width: 1),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15.0),
                      bottom: Radius.circular(15.0),
                    )),
                child: Column(children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 80),
                  Text(
                    "اسم الصنف:     " +
                        invoiceModelList[widget.index]['salesdtlModel'][index]
                                ['itemName']
                            .toString(),
                    style: const TextStyle(
                        fontFamily: 'Almarai',
                        fontStyle: FontStyle.normal,
                        fontSize: 12),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "الكمية:  " +
                              invoiceModelList[widget.index]['salesdtlModel']
                                      [index]['qty']
                                  .toString(),
                          style: const TextStyle(
                              fontFamily: 'Almarai',
                              fontStyle: FontStyle.normal,
                              fontSize: 12),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "السعر:  " +
                              invoiceModelList[widget.index]['salesdtlModel']
                                      [index]['price']
                                  .toString(),
                          style: const TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 7.2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "الضريبة:  " +
                              invoiceModelList[widget.index]['salesdtlModel']
                                      [index]['tax']
                                  .toString(),
                          style: const TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "الخصم: " +
                              invoiceModelList[widget.index]['salesdtlModel']
                                      [index]['discount']
                                  .toString(),
                          style: const TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 12,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 7),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                //  salesDtlModel.removeAt(index);
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 153, 29, 20),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0),
                        child: IconButton(
                            onPressed: () {
                              _displayDialog(context);
                              setState(() {
                                salesDtlModel1 = invoiceModelList[widget.index]
                                    ['salesdtlModel'];

                                editOrAdd = 1;
                                itemTextField.text =
                                    invoiceModelList[widget.index]
                                            ['salesdtlModel'][index]['itemName']
                                        .toString();
                                priceTextField.text =
                                    invoiceModelList[widget.index]
                                            ['salesdtlModel'][index]['price']
                                        .toString();
                                taxTextField.text =
                                    invoiceModelList[widget.index]
                                            ['salesdtlModel'][index]['tax']
                                        .toString();
                                discountTextField.text =
                                    invoiceModelList[widget.index]
                                            ['salesdtlModel'][index]['discount']
                                        .toString();
                                qty.text = invoiceModelList[widget.index]
                                        ['salesdtlModel'][index]['tax']
                                    .toString();
                                globalIndex = index;
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 8),
                        child: Text(
                          "الاجمالي:" +
                              (invoiceModelList[widget.index]['salesdtlModel']
                                          [index]['qty'] *
                                      invoiceModelList[widget.index]
                                          ['salesdtlModel'][index]['price'])
                                  .toString(),
                          style: const TextStyle(
                              fontFamily: 'Almarai',
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        });
  }

// +
//                               ((invoiceModelList[widget.index]['salesdtlModel']
//                                       [index]['price'])! *
//                                   (invoiceModelList[widget.index]
//                                           ['salesdtlModel'][index]['qty'])
  String s = '';
  _displayDialog(BuildContext _context) {
    return showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "اضافة جديد",
              textDirection: TextDirection.rtl,
            ),
            actions: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: EasyAutocomplete(
                            suggestions: itemsModel.name,
                            controller: itemTextField,
                            suggestionTextStyle: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: "اختر الصنف",
                              icon: Icon(Icons.arrow_drop_down_sharp),
                            ),
                            //controller: itemsControllers[index],
                            // autofocus: true,
                            onChanged: (value) {
                              if (editOrAdd == 0) {
                                if (kDebugMode) {
                                  print('onChanged value: $value');
                                }
                              } else {
                                itemName = value;
                              }
                            },
                            onSubmitted: (value) {
                              if (kDebugMode) {
                                print('onSubmitted value: $value');
                              }
                              setState(() {
                                itemName = value;
                                itemTextField.text = value;
                                itemId = itemsModel
                                    .id[itemsModel.name.indexOf(value)];
                                priceTextField.text = itemsModel
                                    .price[itemsModel.name.indexOf(itemName!)]
                                    .toString();
                                value = "";
                              });
                            }),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontFamily: 'Almarai',
                                  fontStyle: FontStyle.normal),
                              controller: qty,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'الكمية',
                                labelText: 'الكمية',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontFamily: 'Almarai',
                                  fontStyle: FontStyle.normal),
                              controller: priceTextField,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'السعر',
                                labelText: 'السعر',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontFamily: 'Almarai',
                                  fontStyle: FontStyle.normal),
                              controller: taxTextField,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'الضريبة',
                                labelText: 'الضريبة',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              style: const TextStyle(
                                  fontFamily: 'Almarai',
                                  fontStyle: FontStyle.normal),
                              controller: discountTextField,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'الخصم',
                                labelText: 'الخصم',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        child: const Text('حفظ',
                            style: TextStyle(
                                fontFamily: 'Almarai',
                                fontStyle: FontStyle.normal)),
                        onPressed: () async {
                          if (editOrAdd == 0) {
                            salesdtl.add(SalesDtlModel(
                                itemId: itemId,
                                disam: double.parse(discountTextField.text),
                                itemName: itemName,
                                price: double.parse(priceTextField.text),
                                qty: double.parse(qty.text),
                                tax: double.parse(taxTextField.text),
                                id: invoiceModelList[widget.index]
                                    ['salesdtlModel'][globalIndex]['id']));
                            for (var i = 0; i < salesdtl.length; i++) {
                              await dbHelper.insertInvoiceDtl(salesdtl[i]);
                            }
                            await sendInvoices();
                            setState(() {
                              qty.text = "";
                              priceTextField.text = "";
                              taxTextField.text = "";
                              discountTextField.text = "";
                            });
                            salesdtl = [];
                            Navigator.pop(context);
                          } else {
                            if (itemTextField.text != "" &&
                                discountTextField.text != "" &&
                                priceTextField.text != "" &&
                                qty.text != "" &&
                                taxTextField.text != "" &&
                                itemsModel.name.contains(itemTextField.text)) {
                              itemName = itemTextField.text;
                              double mqty = double.parse(qty.text);
                              double mprice = double.parse(priceTextField.text);
                              double mtax = double.parse(taxTextField.text);
                              double mdiscount =
                                  double.parse(discountTextField.text);

                              databaseHelper.db.rawUpdate(
                                  "UPDATE salesInvoiceDtl SET itemName ='$itemName' where id=" +
                                      invoiceModelList[widget.index]
                                                  ['salesdtlModel'][globalIndex]
                                              ['id']
                                          .toString());
                              databaseHelper.db.rawUpdate(
                                  "UPDATE salesInvoiceDtl SET qty =$mqty where id=" +
                                      invoiceModelList[widget.index]
                                                  ['salesdtlModel'][globalIndex]
                                              ['id']
                                          .toString());
                              databaseHelper.db.rawUpdate(
                                  "UPDATE salesInvoiceDtl SET price = $mprice where id=" +
                                      invoiceModelList[widget.index]
                                                  ['salesdtlModel'][globalIndex]
                                              ['id']
                                          .toString());
                              databaseHelper.db.rawUpdate(
                                  "UPDATE salesInvoiceDtl SET tax =$mtax where id=" +
                                      invoiceModelList[widget.index]
                                                  ['salesdtlModel'][globalIndex]
                                              ['id']
                                          .toString());
                              databaseHelper.db.rawUpdate(
                                  "UPDATE salesInvoiceDtl SET discount =$mdiscount where id=" +
                                      invoiceModelList[widget.index]
                                                  ['salesdtlModel'][globalIndex]
                                              ['id']
                                          .toString());

                              if (editOrAdd != 0) {
                                setState(() {});
                              }
                              itemTextField.clear();
                              discountTextField.clear();
                              priceTextField.clear();
                              qty.clear();
                              taxTextField.clear();
                              if (kDebugMode) {
                                // print(salesDtlModel.length);
                              }
                              Navigator.pop(context);
                            }
                          }
                        }),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
