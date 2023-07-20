import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nilesoft_app/Databasemodels/SalesModel.dart';
import 'package:nilesoft_app/Databasemodels/orderModel.dart';
import 'package:nilesoft_app/ItemstoShow.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:nilesoft_app/sendData.dart';
import '../CustomersToShow.dart';
import 'package:intl/intl.dart' as c;

import '../DatabaseHelper.dart';
import 'home.dart';

class MyApp3 extends StatefulWidget {
  const MyApp3({Key? key}) : super(key: key);

  @override
  State<MyApp3> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp3> {
  CustomersToShow customersModel = CustomersToShow([".."], [""]);
  ItemsToShow itemsModel = ItemsToShow([".."], [""], [], [], []);
  int myid = 0;
  SendDate sendDate = SendDate();
  int globalIndex = 0;
  int editOrAdd = -1;
  double total = 0;
  double totalDiscount = 0;
  String formattedDate = "";

  double subtotal = 0;
  double totalTax = 0;
  double disEGP = 0;
  double disPrecent = 0;
  OrderHeadModel? salesHeadModel;
  List<OrderDtlModel> salesDtlModel = [];
  String? itemId;
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
    var now = new DateTime.now();
    var formatter = c.DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    getCustomer();
    getItems();
    getLatestID();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? clientName;
  String? clientId;
  String? itemName;
  Future<void> getLatestID() async {
    final List<Map<String, Object?>> queryResult = await dbHelper.db
        .rawQuery('select max(id) as id from salesInvoiceHead');
    if (queryResult.length > 0) {
      if (queryResult[0]['id'] != null) {
        myid = int.parse(queryResult[0]['id'].toString());
      }
    }
    setState(() {
      myid = myid + 1;
    });
  }

  String dropdownvalue = 'اختر اسم العميل';
  String dropdownvalue2 = 'اختر اسم المنتج';
  final byanTextField = TextEditingController();

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: BackButton(color: Color.fromRGBO(34, 112, 120, 1)),
          title: const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "انشاء طلبية",
              // textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,

              style: TextStyle(
                color: Color.fromRGBO(34, 112, 120, 1),
              ),
            ),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height / 1,
          child: Column(children: [
            Container(
              color: Colors.white,
              width: width,
              height: height * (160 / 812),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.05,
                          child: EasyAutocomplete(
                              suggestions: customersModel.name,
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
                                  clientId = (customersModel
                                      .id[customersModel.name.indexOf(value)]);
                                });
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 100,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      child: Text(
                        "$formattedDate",
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    SizedBox(
                      width: width * (2 / 3),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextFormField(
                            style: const TextStyle(fontStyle: FontStyle.normal),
                            controller: byanTextField,
                            decoration: const InputDecoration(
                              hintText: 'البيان',
                              labelText: 'البيان',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 50,
                // ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width / 2,
                //   child: ElevatedButton(
                //       onPressed: () {
                //         setState(() {
                //           salesHeadModel = SalesHeadModel(
                //               clientId: 1,
                //               clientName: clientName,
                //               notes: byanTextField.text);
                //           absorb = false;
                //           absorb2 = true;
                //         });
                //       },
                //       child: const Text("تأكيد")),
                // )
              ]),
            ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width / 2,
            // ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 50,
            // ),
            SizedBox(
              width: width * (350 / 375),
              height: MediaQuery.of(context).size.height * (135 / 812),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * (51 / 375),
                          child: Column(children: [
                            Text("الصافي"),
                            Text(calcTotal().toString()),
                          ]),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width * (191 / 375),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(children: [
                            Text("الضريبة"),
                            Text(calcTax().toString()),
                          ]),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width / 15,
                    // ),
                    Divider(
                      color: Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * (51 / 375),
                          child: Column(
                            children: [
                              Text("الخصم "),
                              Text(calcDiscount().toString()),
                            ],
                          ),
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width * (205 / 375),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * (51 / 375),
                          child: Column(children: [
                            Text("الفاتورة"),
                            Text(calcSubTotal().toString()),
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Column(children: [
                  SingleChildScrollView(
                    child: Container(
                      color: Color.fromRGBO(245, 245, 245, 1),
                      height: MediaQuery.of(context).size.height / 2.32,
                      child: myWidget(context),
                    ),
                  ),
                ]),
              ],
            ),

            Container(
                alignment: Alignment.bottomCenter,
                color: Color.fromRGBO(245, 245, 245, 1),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.0045),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (clientName != null &&
                                customersModel.name.contains(clientName)) {
                              salesHeadModel = OrderHeadModel(
                                  clientId: clientId,
                                  clientName: clientName,
                                  notes: byanTextField.text);

                              await dbHelper.insertOrderHead(salesHeadModel!);
                              for (var i = 0; i < salesDtlModel.length; i++) {
                                await dbHelper.insertOrderDtl(salesDtlModel[i]);
                              }
                              setState(() {
                                qty.text = "";
                                priceTextField.text = "";
                                taxTextField.text = "";
                                discountTextField.text = "";
                              });
                              salesDtlModel = [];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyApp1()));
                            } else {}
                          },
                          child: Icon(Icons.save_outlined,
                              color: Colors.white), // icon of the button
                          style: ElevatedButton.styleFrom(
                            // styling the button
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(10),
                            backgroundColor: Colors.green, // Button color
                            foregroundColor: Colors.cyan, // Splash color
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 10,
                      ),
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            //  dbHelper.retrieveUsers2();
                            setState(() {
                              editOrAdd = 0;
                              itemTextField.text = "";
                              qty.text = "0";
                              discountTextField.text = "0";
                              discount2TextField.text = "0";
                              taxTextField.text = "0";
                            });

                            _displayDialog(context);
                          },
                          child: Icon(Icons.add,
                              color: Colors.white), // icon of the button
                          style: ElevatedButton.styleFrom(
                            // styling the button
                            shape: CircleBorder(),

                            padding: EdgeInsets.all(10),
                            backgroundColor: Colors.green, // Button color
                            foregroundColor: Colors.cyan, // Splash color
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ]),
        ));
  }

  Widget myWidget(BuildContext context) {
    return ListView.builder(
        itemCount: salesDtlModel.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            controller: ScrollController(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 5.5,
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
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "اسم الصنف:" +
                                  salesDtlModel[index].itemName.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Almarai',
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 80),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Column(
                              children: [
                                const Text(
                                  "الضريبة",
                                  style: TextStyle(
                                      fontFamily: 'Almarai',
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  salesDtlModel[index].tax.toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Almarai',
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Column(
                              children: [
                                const Text(
                                  "الكمية ",
                                  style: TextStyle(
                                      fontFamily: 'Almarai',
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  salesDtlModel[index].qty.toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Almarai',
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Column(
                              children: [
                                Text(
                                  "الخصم",
                                  style: const TextStyle(
                                      fontFamily: 'Almarai',
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  salesDtlModel[index].discount.toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Almarai',
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Column(
                              children: [
                                const Text(
                                  "السعر",
                                  style: TextStyle(
                                      fontFamily: 'Almarai',
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  salesDtlModel[index].price.toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Almarai',
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0,
                          ),
                        ],
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  salesDtlModel.removeAt(index);
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
                                  editOrAdd = 1;
                                  itemTextField.text = itemName!;
                                  qty.text =
                                      salesDtlModel[index].qty.toString();
                                  priceTextField.text =
                                      salesDtlModel[index].price.toString();
                                  taxTextField.text =
                                      salesDtlModel[index].tax.toString();
                                  discountTextField.text =
                                      salesDtlModel[index].discount.toString();

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
                                ((salesDtlModel[index].price)! *
                                        (salesDtlModel[index].qty!))
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
                  ],
                ),
              ),
            ),
          );
        });
  }

  double calcDiscount() {
    totalDiscount = 0;
    for (var i = 0; i < salesDtlModel.length; i++) {
      setState(() {
        totalDiscount =
            totalDiscount + salesDtlModel[i].discount! * salesDtlModel[i].qty!;
        totalDiscount = double.parse(totalDiscount.toStringAsFixed(2));
      });
    }

    return totalDiscount;
  }

  double calcTax() {
    totalTax = 0;
    for (var i = 0; i < salesDtlModel.length; i++) {
      setState(() {
        totalTax = totalTax +
            (salesDtlModel[i].tax! *
                (salesDtlModel[i].qty! *
                    (salesDtlModel[i].price! - salesDtlModel[i].discount!)) /
                100);
        totalTax = double.parse(totalTax.toStringAsFixed(2));
      });
    }

    return totalTax;
  }

  double calcSubTotal() {
    subtotal = 0;
    for (var i = 0; i < salesDtlModel.length; i++) {
      setState(() {
        subtotal =
            subtotal + ((salesDtlModel[i].price)! * (salesDtlModel[i].qty!));
        subtotal = double.parse(subtotal.toStringAsFixed(2));
      });
    }
    return subtotal;
  }

  double calcTotal() {
    total = 0;
    for (var i = 0; i < salesDtlModel.length; i++) {
      setState(() {
        total = total +
            ((salesDtlModel[i].price)! * (salesDtlModel[i].qty!) -
                salesDtlModel[i].discount!) +
            ((salesDtlModel[i].tax! / 100) *
                (salesDtlModel[i].price)! *
                (salesDtlModel[i].qty!));
        total = double.parse(total.toStringAsFixed(2));
      });
    }
    return total;
  }

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
                      child: GestureDetector(
                        onTap: () {
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

                                onChanged: (value) {
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
                                            itemsModel.name.indexOf(itemName!)]
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
                              salesDtlModel.add(OrderDtlModel(
                                itemId: itemId,
                                itemName: itemName,
                                discount: double.parse(discountTextField.text),
                                price: double.parse(priceTextField.text),
                                qty: double.parse(qty.text),
                                tax: double.parse(taxTextField.text),
                              ));
                            } else {
                              setState(() {
                                salesDtlModel[globalIndex] = OrderDtlModel(
                                  itemId: itemId,
                                  itemName: itemName,
                                  discount:
                                      double.parse(discountTextField.text),
                                  price: double.parse(priceTextField.text),
                                  qty: double.parse(qty.text),
                                  tax: double.parse(taxTextField.text),
                                );
                              });
                            }
                            itemTextField.clear();
                            discountTextField.clear();
                            priceTextField.clear();
                            qty.clear();
                            discount2TextField.clear();
                            taxTextField.clear();
                            if (kDebugMode) {
                              print(salesDtlModel.length);
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
}
