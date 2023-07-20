import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nilesoft_app/Databasemodels/SalesModel.dart';
import 'package:nilesoft_app/Databasemodels/orderModel.dart';
import 'package:nilesoft_app/ItemstoShow.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:nilesoft_app/screens/SingleInvoice.dart';
import 'package:nilesoft_app/screens/singleInvoicePreview.dart';
import '../CustomersToShow.dart';
import '../DatabaseHelper.dart';
import 'home.dart';

class MyApp6 extends StatefulWidget {
  const MyApp6({Key? key}) : super(key: key);

  @override
  State<MyApp6> createState() => _MyHomePageState();
}

SalesHeadModel salesHeadModel = SalesHeadModel();
SalesDtlModel salesDtlModel = SalesDtlModel();
SalesModel invoiceModel = SalesModel();
List clientsNames = [];
List invoiceModelList = [];
double total = 0;
late DatabaseHelper databaseHelper;

class _MyHomePageState extends State<MyApp6> {
  CustomersToShow customersModel = CustomersToShow([".."], [""]);
  ItemsToShow itemsModel = ItemsToShow([".."], [""], [], [], []);
  int id = -1;
  int globalIndex = 0;
  int editOrAdd = -1;
  OrderHeadModel? orderHeadModel;
  List<OrderDtlModel> orderDtlModel = [];
  int? itemId;
  final itemTextField = TextEditingController();
  late DatabaseHelper dbHelper;
  int counter = 1;
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
    invoiceModelList = [];
    clientsNames = [];
    sendInvoices();
    getCustomer();

    getItems();
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
    print("done");
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "استعراض فواتير المبيعات",
          style: TextStyle(
            color: Color.fromRGBO(34, 112, 120, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
        height: MediaQuery.of(context).size.height / 1,
        child: Column(children: [
          // SizedBox(
          //   width: MediaQuery.of(context).size.width / 2,
          // ),

          Column(
            children: [
              Column(children: [
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1,
                    child: myWidget(context),
                  ),
                ),
              ]),
            ],
          ),
        ]),
      )),
    );
  }

  Future<void> sendInvoices() async {
    databaseHelper = DatabaseHelper();
    databaseHelper.initDB().whenComplete(() async {});
    String s1 = "select * from salesInvoiceHead where sent = 0";

    final List<Map<String, Object?>> invoiceHead =
        await databaseHelper.db.rawQuery(s1);

    for (int i = 0; i < invoiceHead.length; i++) {
      salesHeadModel.accid = (invoiceHead[i]["accid"].toString());
      salesHeadModel.clientName = invoiceHead[i]["clientName"].toString();
      salesHeadModel.descr = invoiceHead[i]["descr"].toString();
      getClinetName(invoiceHead[i]["accid"].toString());

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
        salesDtlModel.disratio =
            double.parse(invoicDtl[j]["disratio"].toString());
        salesDtlModel.disam = double.parse(invoicDtl[j]["disam"].toString());
        salesDtlModel.tax = double.parse(invoicDtl[j]["tax"].toString());
        salesDtlModel.qty = double.parse(invoicDtl[j]["qty"].toString());
        invoiceModel.salesdtlModel.add(salesDtlModel);
      }
      invoiceModel.salesHeadModel = salesHeadModel;
      setState(() {
        invoiceModelList.add(invoiceModel.toJson());
      });
    }

    var s = jsonEncode(invoiceModelList);

    print(s);
  }

  Future<String> getClinetName(String accId) async {
    String s =
        "select clientName from salesInvoiceHead where accid = '" + accId + "'";
    final List<Map<String, Object?>> accname =
        await databaseHelper.db.rawQuery(s);
    String clientName = accname[0]["clientName"].toString();
    clientsNames.add(clientName);
    return clientName;
  }

  double calcTotal(int idx) {
    total = 0;
    for (var i = 0; i < invoiceModelList[idx]['dtl'].length; i++) {
      total = total +
          (invoiceModelList[idx]['dtl'][i]['qty'] *
                  invoiceModelList[idx]['dtl'][i]['price'] -
              invoiceModelList[idx]['dtl'][i]['disratio']) +
          (invoiceModelList[idx]['dtl'][i]['qty'] *
                  invoiceModelList[idx]['dtl'][i]['price']) *
              (invoiceModelList[idx]['dtl'][i]['tax'] / 100);
    }
    return total;
  }

  Widget myWidget(BuildContext context) {
    return ListView.builder(
        itemCount: invoiceModelList.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            controller: ScrollController(),
            child: Card(
              color: const Color.fromRGBO(245, 245, 245, 1),
              shape: const RoundedRectangleBorder(
                  side: BorderSide(
                      color: Color.fromRGBO(139, 139, 139, .5), width: 1),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.0),
                    bottom: Radius.circular(15.0),
                  )),
              elevation: 2,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SSPreview(
                                  invoiceId: invoiceModelList[index]["dtl"][0]
                                      ["id"])));
                    },
                    child: Card(
                        elevation: 0,
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromRGBO(255, 255, 255, 0),
                                width: 1),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10.0),
                              bottom: Radius.circular(10.0),
                            )),
                        child: Column(children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    child: const Text(
                                      "اسم العميل:",
                                      style: const TextStyle(
                                        fontFamily: 'Almarai',
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      clientsNames[index].toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Almarai',
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 30,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        "الاحمالي",
                                        style: const TextStyle(
                                            fontFamily: 'Almarai',
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal),
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        calcTotal(index).toString(),
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
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        "البيان:  ",
                                        style: const TextStyle(
                                            fontFamily: 'Almarai',
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal),
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        invoiceModelList[index]['descr']
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
                              ]),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 60,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 5, 108, 192),
                                ),
                                Text(
                                  "غير مرسلة",
                                  style: const TextStyle(
                                      fontFamily: 'Almarai',
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                              ]),
                        ])),
                  )),
            ),
          );
        });
  }

  String s = '';
  _displayDialog(BuildContext context, index) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              title: const Text(
                "فاتورة",
                textDirection: TextDirection.rtl,
              ),
              actions: <Widget>[
                SingleChildScrollView(
                    child: Column(
                  children: [
                    ListView.builder(
                        itemCount: invoiceModelList.length,
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            controller: ScrollController(),
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height / 6,
                                child: Card(
                                    elevation: 1,
                                    shadowColor:
                                        const Color.fromRGBO(0, 0, 0, 1),
                                    shape: const RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color.fromRGBO(
                                                139, 139, 139, .5),
                                            width: 1),
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15.0),
                                          bottom: Radius.circular(15.0),
                                        )),
                                    child: Column(children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              80),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    8),
                                            child: Text(
                                              "اسم المنتج:     " +
                                                  invoiceModelList[index]
                                                          ['clientName']
                                                      .toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Almarai',
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.right,
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    8),
                                            child: Text(
                                              "السعر:     " +
                                                  invoiceModelList[index]
                                                          ['clientName']
                                                      .toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Almarai',
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.right,
                                              textDirection: TextDirection.rtl,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                20,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      8),
                                              child: Text(
                                                "الكمية:  " +
                                                    invoiceModelList[index]
                                                            ['notes']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Almarai',
                                                    fontSize: 12,
                                                    fontStyle:
                                                        FontStyle.normal),
                                                textAlign: TextAlign.right,
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      8),
                                              child: Text(
                                                "الخصم:     " +
                                                    invoiceModelList[index]
                                                            ['clientName']
                                                        .toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'Almarai',
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.right,
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      8),
                                              child: Text(
                                                "الضريبة:     " +
                                                    invoiceModelList[index]
                                                            ['clientName']
                                                        .toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'Almarai',
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.right,
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                            )
                                          ])
                                    ]))),
                          );
                        })
                  ],
                ))
              ]);
        });
  }
}
