import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nilesoft_app/Databasemodels/SalesModel.dart';
import 'package:nilesoft_app/Databasemodels/orderModel.dart';
import 'package:nilesoft_app/ItemstoShow.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:nilesoft_app/screens/SalesPreview.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../CustomersToShow.dart';
import '../DatabaseHelper.dart';
import 'home.dart';

class MyApp7 extends StatefulWidget {
  final int index;
  const MyApp7({Key? key, required this.index}) : super(key: key);

  @override
  State<MyApp7> createState() => _MyHomePageState();
}

SalesHeadModel salesHeadModel = SalesHeadModel();
SalesDtlModel salesDtlModel = SalesDtlModel();
int hasSN = 0;
List<SalesDtlModel> salesdtl = [];
SalesModel invoiceModel = SalesModel();
int globalIndex = 0;
String result = "";
double ttotal = 0;
double tdiscount = 0;

String accid = "";
int editOrAdd = -1;
SalesHeadModel? salesHeadModel1;
List salesDtlModel1 = [];
String? itemId;
List invoiceModelList = [];

late DatabaseHelper databaseHelper;

class _MyHomePageState extends State<MyApp7> {
  CustomersToShow customersModel = CustomersToShow([".."], [""]);
  ItemsToShow itemsModel = ItemsToShow([".."], [""], [], [], []);
  int id = -1;
  int globalIndex = 0;
  int editOrAdd = -1;
  OrderHeadModel? orderHeadModel;
  List<OrderDtlModel> orderDtlModel = [];
  String? itemId;
  final itemTextField = TextEditingController();
  List itemNames = [];
  final clientTextField = TextEditingController();
  late DatabaseHelper dbHelper;
  int counter = 1;
  String myid = "";
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
// Future<void> getLatestID() async {
//     final List<Map<String, Object?>> queryResult = await dbHelper.db
//         .rawQuery('select max(id) as id from salesInvoiceHead');
//     if (queryResult.length > 0) {
//       if (queryResult[0]['id'] != null) {
//         myid = int.parse(queryResult[0]['id'].toString());
//       }
//     }
//     setState(() {
//       myid = myid + 1;
//     });
//   }

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
  final discount2TextField = TextEditingController();

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
      itemsModel.hasserialno
          .add(double.parse(queryResult[i]["hasSerial"].toString()));
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

  Future<void> getItemNames(String itemid) async {
    String s0 = "select name from items where itemid = '" + itemid + "'";
    List<Map<String, Object?>> queryResult = await dbHelper.db.rawQuery(s0);
    itemNames.add(queryResult[0]["name"].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("استعراض الفواتير"),
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
                                              accid = (customersModel.id[
                                                  customersModel.name
                                                      .indexOf(value)]);
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
                                // salesdtl =
                                //     invoiceModelList[widget.index]['dtl'];
                                dbHelper.deleteDtl(myid);
                                for (var i = 0; i < salesdtl.length; i++) {
                                  await dbHelper.insertInvoiceDtl(salesdtl[i]);
                                }

                                databaseHelper.db.rawUpdate(
                                    "UPDATE salesInvoiceHead SET clientName= '$clientName' , accid= '$accid' where id=" +
                                        invoiceModelList[widget.index]['dtl']
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
    for (var i = 0; i < invoiceModelList[widget.index]['dtl'].length; i++) {
      ttotal = ttotal +
          (invoiceModelList[widget.index]['dtl'][i]['qty'] *
                  invoiceModelList[widget.index]['dtl'][i]['price'] -
              invoiceModelList[widget.index]['dtl'][i]['disratio']) +
          (invoiceModelList[widget.index]['dtl'][i]['qty'] *
                  invoiceModelList[widget.index]['dtl'][i]['price']) *
              (invoiceModelList[widget.index]['dtl'][i]['tax'] / 100);
    }
    return ttotal;
  }

  double calcDiscount() {
    tdiscount = 0;
    for (var i = 0; i < invoiceModelList[widget.index]['dtl'].length; i++) {
      tdiscount =
          tdiscount + (invoiceModelList[widget.index]['dtl'][i]['disratio']);
    }
    return tdiscount;
  }

  Future<void> sendInvoices() async {
    databaseHelper = DatabaseHelper();
    databaseHelper.initDB().whenComplete(() async {});
    String s1 = "select * from salesInvoiceHead where sent=0";

    final List<Map<String, Object?>> invoiceHead =
        await databaseHelper.db.rawQuery(s1);
    myid = invoiceHead[0]["id"].toString();
    for (int i = 0; i < invoiceHead.length; i++) {
      salesHeadModel.accid = (invoiceHead[i]["accid"].toString());
      salesHeadModel.clientName = invoiceHead[i]["clientName"].toString();
      salesHeadModel.descr = invoiceHead[i]["descr"].toString();
      salesHeadModel.invoiceno = invoiceHead[i]["invoiceno"].toString();
      // databaseHelper.db.rawUpdate(
      //     "UPDATE salesInvoiceHead SET sent = 1 where id=" +
      //         invoiceHead[i]["id"].toString());
      String s2 = "select * from salesInvoiceDtl where id=" +
          invoiceHead[i]["id"].toString();

      final List<Map<String, Object?>> invoicDtl =
          await databaseHelper.db.rawQuery(s2);
      // databaseHelper.db.rawUpdate(
      //     "UPDATE salesInvoiceDtl SET sent = 1 where id=" +
      //         invoiceHead[i]["id"].toString());
      invoiceModel.salesdtlModel = [];

      for (int j = 0; j < invoicDtl.length; j++) {
        salesDtlModel = SalesDtlModel();
        salesDtlModel.id = (invoicDtl[j]["id"].toString());
        salesDtlModel.itemId = invoicDtl[j]["itemId"].toString();
        salesDtlModel.itemName = invoicDtl[j]["itemName"].toString();
        salesDtlModel.price = double.parse(invoicDtl[j]["price"].toString());
        salesDtlModel.disam = double.parse(invoicDtl[j]["disam"].toString());
        salesDtlModel.disratio =
            double.parse(invoicDtl[j]["disratio"].toString());

        salesDtlModel.tax = double.parse(invoicDtl[j]["tax"].toString());
        salesDtlModel.qty = double.parse(invoicDtl[j]["qty"].toString());
        invoiceModel.salesdtlModel.add(salesDtlModel);
        getItemNames(salesDtlModel.itemId.toString());
      }
      invoiceModel.salesHeadModel = salesHeadModel;
      setState(() {
        invoiceModelList.add(invoiceModel.toJson());
      });
    }
    String s0 = "select clientName from salesInvoiceHead where accid='" +
        salesHeadModel.accid.toString() +
        "'";
    final List<Map<String, Object?>> accname =
        await databaseHelper.db.rawQuery(s0);

    clientTextField.text = accname[0]["clientName"].toString();
    byanTextField.text = invoiceModelList[widget.index]['descr'].toString();
    var s = jsonEncode(invoiceModelList);

    print(s);
  }

  Widget myWidget1(BuildContext context) {
    return ListView.builder(
        itemCount: invoiceModelList[0]['dtl'].length,
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
                    "اسم الصنف:     " + itemNames[index],
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
                              invoiceModelList[widget.index]['dtl'][index]
                                      ['qty']
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
                              invoiceModelList[widget.index]['dtl'][index]
                                      ['price']
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
                              invoiceModelList[widget.index]['dtl'][index]
                                      ['tax']
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
                              invoiceModelList[widget.index]['dtl'][index]
                                      ['disam']
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
                                salesDtlModel1 =
                                    invoiceModelList[widget.index]['dtl'];

                                editOrAdd = 1;
                                itemTextField.text =
                                    invoiceModelList[widget.index]['dtl'][index]
                                            ['itemName']
                                        .toString();
                                priceTextField.text =
                                    invoiceModelList[widget.index]['dtl'][index]
                                            ['price']
                                        .toString();
                                taxTextField.text =
                                    invoiceModelList[widget.index]['dtl'][index]
                                            ['tax']
                                        .toString();
                                discountTextField.text =
                                    invoiceModelList[widget.index]['dtl'][index]
                                            ['discount']
                                        .toString();
                                qty.text = invoiceModelList[widget.index]['dtl']
                                        [index]['tax']
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
                              (invoiceModelList[widget.index]['dtl'][index]
                                          ['qty'] *
                                      invoiceModelList[widget.index]['dtl']
                                          [index]['price'])
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
                      child: GestureDetector(
                        onTap: () {
                          itemTextField.text = itemTextField.text;
                          itemTextField.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: itemTextField.text.length,
                          );
                        },
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: SingleChildScrollView(
                            child: EasyAutocomplete(
                                suggestions: itemsModel.name,
                                controller: itemTextField,
                                suggestionTextStyle:
                                    const TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                  hintText: "اختر الصنف",
                                  icon: Icon(Icons.arrow_drop_down_sharp),
                                ),
                                //controller: itemsControllers[index],
                                // autofocus: true,

                                onChanged: (value) async {
                                  //dbHelper.db.rawQuery(s);
                                  if (editOrAdd == 0) {
                                    if (kDebugMode) {
                                      print('onChanged value: $value');
                                    }
                                  } else {
                                    value = itemName!;
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
                                    priceTextField.text = itemsModel.price[
                                            itemsModel.name.indexOf(itemName!) -
                                                1]
                                        .toString();
                                    value = "";
                                  });
                                }),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () async {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SimpleBarcodeScannerPage(),
                                  ));
                              setState(() {
                                if (res is String) {
                                  result = res;
                                }
                              });
                            },
                            child: const Icon(
                              Icons.qr_code_scanner_sharp,
                            ))
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
                              controller: qty,
                              onTap: () {
                                qty.text = qty.text;
                                qty.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: qty.text.length,
                                );
                              },
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
                              onChanged: (value) {
                                discount2TextField.text = "0";
                                discountTextField.text = "0";
                              },
                              onTap: () {
                                priceTextField.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: priceTextField.text.length,
                                );
                              },
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
                              onTap: () {
                                taxTextField.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: taxTextField.text.length,
                                );
                              },
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
                          width: MediaQuery.of(context).size.width / 12,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              onTap: () {
                                discountTextField.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: discountTextField.text.length,
                                );
                              },
                              onChanged: (value) {
                                if (value == "") {
                                  discount2TextField.text = "0";
                                }
                                if (value != "") {
                                  discount2TextField.text = ((double.parse(
                                              discountTextField.text
                                                  .toString())) /
                                          ((double.parse(
                                              priceTextField.text))) *
                                          100)
                                      .toString();
                                }
                              },
                              style: const TextStyle(
                                  fontFamily: 'Almarai',
                                  fontStyle: FontStyle.normal),
                              controller: discountTextField,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'الخصم',
                                labelText: 'الخصم ',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              onTap: () {
                                discount2TextField.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: discount2TextField.text.length,
                                );
                              },
                              onChanged: (value) {
                                if (value == "") {
                                  discountTextField.text = "0";
                                }
                                if (value != "") {
                                  discountTextField.text = (((double.parse(
                                                  discount2TextField.text
                                                      .toString())) /
                                              100) *
                                          ((double.parse(priceTextField.text))))
                                      .toString();
                                }
                              },
                              style: const TextStyle(
                                  fontFamily: 'Almarai',
                                  fontStyle: FontStyle.normal),
                              controller: discount2TextField,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'الخصم %',
                                labelText: '%الخصم',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: ElevatedButton(
                        child: const Text('حفظ',
                            style: TextStyle(
                                fontFamily: 'Almarai',
                                fontStyle: FontStyle.normal)),
                        onPressed: () {
                          if (itemName != null &&
                              discountTextField.text != "" &&
                              priceTextField.text != "" &&
                              qty.text != "" &&
                              taxTextField.text != "" &&
                              itemsModel.name.contains(itemTextField.text)) {
                            if (editOrAdd == 0) {
                              salesdtl.add(SalesDtlModel(
                                itemId: itemId,
                                itemName: itemName,
                                price: double.parse(priceTextField.text),
                                disam: double.parse(discountTextField.text),
                                disratio: double.parse(discount2TextField.text),
                                qty: double.parse(qty.text),
                                tax: double.parse(taxTextField.text),
                                id: myid.toString(),
                              ));
                            } else {
                              setState(() {
                                salesdtl[globalIndex] = SalesDtlModel(
                                  itemId: itemId,
                                  itemName: itemName,
                                  disam: double.parse(discountTextField.text),
                                  price: double.parse(priceTextField.text),
                                  disratio:
                                      double.parse(discount2TextField.text),
                                  qty: double.parse(qty.text),
                                  tax: double.parse(taxTextField.text),
                                  id: invoiceModelList[widget.index]['dtl']
                                      [globalIndex]['id'],
                                );
                              });
                            }

                            if (itemsModel.hasserialno[
                                    itemsModel.name.indexOf(itemName!) - 1] ==
                                1) {
                              hasSN = hasSN + int.parse(qty.text);

                              print("!!!!!!");
                            }
                            itemTextField.clear();
                            discountTextField.clear();
                            priceTextField.clear();
                            qty.clear();
                            discount2TextField.clear();
                            taxTextField.clear();
                            if (kDebugMode) {
                              print(salesdtl.length);
                            }
                            Navigator.pop(_context);
                          } else {}
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  // String s = '';
  // _displayDialog1(BuildContext _context) {
  //   return showDialog(
  //       context: _context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text(
  //             "اضافة جديد",
  //             textDirection: TextDirection.rtl,
  //           ),
  //           actions: <Widget>[
  //             SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                   SingleChildScrollView(
  //                     child: Directionality(
  //                       textDirection: TextDirection.rtl,
  //                       child: EasyAutocomplete(
  //                           suggestions: itemsModel.name,
  //                           controller: itemTextField,
  //                           suggestionTextStyle: const TextStyle(fontSize: 18),
  //                           decoration: const InputDecoration(
  //                             hintText: "اختر الصنف",
  //                             icon: Icon(Icons.arrow_drop_down_sharp),
  //                           ),
  //                           //controller: itemsControllers[index],
  //                           // autofocus: true,
  //                           onChanged: (value) {
  //                             if (editOrAdd == 0) {
  //                               if (kDebugMode) {
  //                                 print('onChanged value: $value');
  //                               }
  //                             } else {
  //                               itemName = value;
  //                             }
  //                           },
  //                           onSubmitted: (value) {
  //                             if (kDebugMode) {
  //                               print('onSubmitted value: $value');
  //                             }
  //                             setState(() {
  //                               itemName = value;
  //                               itemTextField.text = value;
  //                               itemId = itemsModel
  //                                   .id[itemsModel.name.indexOf(value)];
  //                               priceTextField.text = itemsModel
  //                                   .price[itemsModel.name.indexOf(itemName!)]
  //                                   .toString();
  //                               value = "";
  //                             });
  //                           }),
  //                     ),
  //                   ),
  //                   Row(
  //                     children: [
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width / 5,
  //                         child: Directionality(
  //                           textDirection: TextDirection.rtl,
  //                           child: TextFormField(
  //                             style: const TextStyle(
  //                                 fontFamily: 'Almarai',
  //                                 fontStyle: FontStyle.normal),
  //                             controller: qty,
  //                             textAlign: TextAlign.right,
  //                             textDirection: TextDirection.rtl,
  //                             keyboardType: TextInputType.number,
  //                             decoration: const InputDecoration(
  //                               hintText: 'الكمية',
  //                               labelText: 'الكمية',
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width / 4,
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width / 5,
  //                         child: Directionality(
  //                           textDirection: TextDirection.rtl,
  //                           child: TextFormField(
  //                             style: const TextStyle(
  //                                 fontFamily: 'Almarai',
  //                                 fontStyle: FontStyle.normal),
  //                             controller: priceTextField,
  //                             textAlign: TextAlign.right,
  //                             textDirection: TextDirection.rtl,
  //                             keyboardType: TextInputType.number,
  //                             decoration: const InputDecoration(
  //                               hintText: 'السعر',
  //                               labelText: 'السعر',
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width / 5,
  //                         child: Directionality(
  //                           textDirection: TextDirection.rtl,
  //                           child: TextFormField(
  //                             style: const TextStyle(
  //                                 fontFamily: 'Almarai',
  //                                 fontStyle: FontStyle.normal),
  //                             controller: taxTextField,
  //                             textAlign: TextAlign.right,
  //                             textDirection: TextDirection.rtl,
  //                             keyboardType: TextInputType.number,
  //                             decoration: const InputDecoration(
  //                               hintText: 'الضريبة',
  //                               labelText: 'الضريبة',
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width / 4,
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width / 5,
  //                         child: Directionality(
  //                           textDirection: TextDirection.rtl,
  //                           child: TextFormField(
  //                             style: const TextStyle(
  //                                 fontFamily: 'Almarai',
  //                                 fontStyle: FontStyle.normal),
  //                             controller: discountTextField,
  //                             textAlign: TextAlign.right,
  //                             textDirection: TextDirection.rtl,
  //                             keyboardType: TextInputType.number,
  //                             decoration: const InputDecoration(
  //                               hintText: 'الخصم',
  //                               labelText: 'الخصم',
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   ElevatedButton(
  //                       child: const Text('حفظ',
  //                           style: TextStyle(
  //                               fontFamily: 'Almarai',
  //                               fontStyle: FontStyle.normal)),
  //                       onPressed: () async {
  //                         if (editOrAdd == 0) {
  //                           salesdtl.add(SalesDtlModel(
  //                               itemId: itemId,
  //                               disam: double.parse(discountTextField.text),
  //                               itemName: itemName,
  //                               price: double.parse(priceTextField.text),
  //                               qty: double.parse(qty.text),
  //                               tax: double.parse(taxTextField.text),
  //                               id: invoiceModelList[widget.index]['dtl']
  //                                   [globalIndex]['id']));
  //                           for (var i = 0; i < salesdtl.length; i++) {
  //                             await dbHelper.insertInvoiceDtl(salesdtl[i]);
  //                           }
  //                           await sendInvoices();
  //                           setState(() {
  //                             qty.text = "";
  //                             priceTextField.text = "";
  //                             taxTextField.text = "";
  //                             discountTextField.text = "";
  //                           });
  //                           salesdtl = [];
  //                           Navigator.pop(context);
  //                         } else {
  //                           if (itemTextField.text != "" &&
  //                               discountTextField.text != "" &&
  //                               priceTextField.text != "" &&
  //                               qty.text != "" &&
  //                               taxTextField.text != "" &&
  //                               itemsModel.name.contains(itemTextField.text)) {
  //                             itemName = itemTextField.text;
  //                             double mqty = double.parse(qty.text);
  //                             double mprice = double.parse(priceTextField.text);
  //                             double mtax = double.parse(taxTextField.text);
  //                             double mdiscount =
  //                                 double.parse(discountTextField.text);

  //                             databaseHelper.db.rawUpdate(
  //                                 "UPDATE salesInvoiceDtl SET itemName ='$itemName' where id=" +
  //                                     invoiceModelList[widget.index]['dtl']
  //                                             [globalIndex]['id']
  //                                         .toString());
  //                             databaseHelper.db.rawUpdate(
  //                                 "UPDATE salesInvoiceDtl SET qty =$mqty where id=" +
  //                                     invoiceModelList[widget.index]['dtl']
  //                                             [globalIndex]['id']
  //                                         .toString());
  //                             databaseHelper.db.rawUpdate(
  //                                 "UPDATE salesInvoiceDtl SET price = $mprice where id=" +
  //                                     invoiceModelList[widget.index]['dtl']
  //                                             [globalIndex]['id']
  //                                         .toString());
  //                             databaseHelper.db.rawUpdate(
  //                                 "UPDATE salesInvoiceDtl SET tax =$mtax where id=" +
  //                                     invoiceModelList[widget.index]['dtl']
  //                                             [globalIndex]['id']
  //                                         .toString());
  //                             databaseHelper.db.rawUpdate(
  //                                 "UPDATE salesInvoiceDtl SET discount =$mdiscount where id=" +
  //                                     invoiceModelList[widget.index]['dtl']
  //                                             [globalIndex]['id']
  //                                         .toString());

  //                             if (editOrAdd != 0) {
  //                               setState(() {});
  //                             }
  //                             itemTextField.clear();
  //                             discountTextField.clear();
  //                             priceTextField.clear();
  //                             qty.clear();
  //                             taxTextField.clear();
  //                             if (kDebugMode) {
  //                               // print(salesDtlModel.length);
  //                             }
  //                             Navigator.pop(context);
  //                           }
  //                         }
  //                       }),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }
}
