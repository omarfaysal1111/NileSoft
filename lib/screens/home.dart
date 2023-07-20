import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nilesoft_app/apiModels/Login.dart';
import 'package:nilesoft_app/screens/sales.dart';
import 'package:nilesoft_app/sendData.dart';
import 'package:path_provider/path_provider.dart';

import '../DatabaseHelper.dart';
import '../apiModels/CustomersModel.dart';
import '../apiModels/ItemsModel.dart';
import '../main.dart';
import 'ShowDocs.dart';
import 'cashin.dart';
import 'ledger.dart';
import 'order.dart';
import 'package:http/http.dart' as http;

class MyApp1 extends StatefulWidget {
  const MyApp1({Key? key}) : super(key: key);

  // const MyApp1({Key? key, required this.title}) : super(key: key);

  // final String title;

  @override
  State<MyApp1> createState() => _MyHomePageState();
}

late AnimationController controller;

class _MyHomePageState extends State<MyApp1> with TickerProviderStateMixin {
  late DatabaseHelper dbHelper;
  var _isLoading = false;

  void _onSubmit() {
    setState(() => _isLoading = true);
  }

  var _isLoading1 = false;

  void _onSubmit1() {
    setState(() => _isLoading1 = true);
    // Future.delayed(

    // );
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    dbHelper.initDB().whenComplete(() async {
      setState(() {
        print("x");
        // print(dbHelper.retrieveUsers().toString());
        // print(dbHelper.retrieveUsers2());
      });
    });

    notSent();

    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    controller.duration = Duration(seconds: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<CustomersModel> customersModel = [];
  List<ItemsModel> itemsModel = [];
  int count = 0;
  SendDate sendDate = SendDate();
  Login _login = Login();
  String dropdownvalue = 'اختر العميل';
  List<Map<String, Object?>>? Usentinvoices;
  String dropdownvalue2 = 'اختر المنتج';
  final byanTextField = TextEditingController();
  // List of items in our dropdown menu

  void notSent() async {
    String s1 = "select * from salesInvoiceHead where sent = 0";
    Usentinvoices = await dbHelper.db.rawQuery(s1);
    setState(() {
      count = Usentinvoices!.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          centerTitle: false,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            "ALFAYSAL APP",
            style: TextStyle(
                color: Color.fromRGBO(34, 112, 120, 1),
                fontFamily: "Montserrat"),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyApp2()));
                          },
                          child: Card(
                            elevation: 0,
                            semanticContainer: true,
                            // clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color.fromRGBO(255, 255, 255, 0),
                                    width: 1),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10.0),
                                  bottom: Radius.circular(10.0),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width /
                                          60),
                                  child: const Text(" فاتورة مبيعات "),
                                ),
                                Image.asset(
                                  "assets/invoice.png",
                                  fit: BoxFit.fill,
                                  alignment: Alignment.centerRight,
                                ),
                                SizedBox(
                                  width: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Column(
              //       children: [
              //         SizedBox(
              //           width: MediaQuery.of(context).size.width,
              //           height: MediaQuery.of(context).size.height / 10,
              //           child: GestureDetector(
              //             onTap: () {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => const MyApp4()));
              //             },
              //             child: Card(
              //               elevation: 0,
              //               semanticContainer: true,
              //               clipBehavior: Clip.antiAliasWithSaveLayer,
              //               shape: const RoundedRectangleBorder(
              //                   side: BorderSide(
              //                       color: Color.fromRGBO(255, 255, 255, 0),
              //                       width: 1),
              //                   borderRadius: BorderRadius.vertical(
              //                     top: Radius.circular(10.0),
              //                     bottom: Radius.circular(10.0),
              //                   )),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.end,
              //                 children: [
              //                   Padding(
              //                     padding: EdgeInsets.only(
              //                         right: MediaQuery.of(context).size.width /
              //                             6),
              //                     child: const Text(" سند قبض نقدي"),
              //                   ),
              //                   Image.asset(
              //                     "assets/cashin.png",
              //                     fit: BoxFit.fill,
              //                     alignment: Alignment.centerRight,
              //                   ),
              //                   SizedBox(
              //                     width: 16,
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Column(
              //       children: [
              //         SizedBox(
              //           width: MediaQuery.of(context).size.width,
              //           height: MediaQuery.of(context).size.height / 10,
              //           child: GestureDetector(
              //             onTap: () {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => const MyApp3()));
              //             },
              //             child: Card(
              //               elevation: 0,
              //               semanticContainer: true,
              //               clipBehavior: Clip.antiAliasWithSaveLayer,
              //               shape: const RoundedRectangleBorder(
              //                   side: BorderSide(
              //                       color: Color.fromRGBO(255, 255, 255, 0),
              //                       width: 1),
              //                   borderRadius: BorderRadius.vertical(
              //                     top: Radius.circular(10.0),
              //                     bottom: Radius.circular(10.0),
              //                   )),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.end,
              //                 children: [
              //                   Padding(
              //                     padding: EdgeInsets.only(
              //                         right: MediaQuery.of(context).size.width /
              //                             5),
              //                     child: const Text("انشاء طلبية"),
              //                   ),
              //                   Image.asset(
              //                     "assets/order.png",
              //                     fit: BoxFit.fill,
              //                     alignment: Alignment.centerRight,
              //                   ),
              //                   SizedBox(
              //                     width: 16,
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyApp5()));
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width /
                                          60),
                                  child: const Text("استعراض المستندات"),
                                ),
                                Image.asset(
                                  "assets/doc.png",
                                  fit: BoxFit.fill,
                                  alignment: Alignment.centerRight,
                                ),
                                SizedBox(
                                  width: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LedgerScreen()));
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width /
                                          60),
                                  child: const Text("تقرير كشف حساب عميل"),
                                ),
                                Image.asset(
                                  "assets/file.png",
                                  fit: BoxFit.fill,
                                  alignment: Alignment.centerRight,
                                ),
                                SizedBox(
                                  width: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (120 / 812),
              ),
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.width * 300 / 375,
              height: MediaQuery.of(context).size.height * (52 / 812),
              child: ElevatedButton.icon(
                onPressed: () async {
                  setState(() {});
                  _isLoading ? null : _onSubmit();

                  final snackBar = SnackBar(
                    duration: Duration(days: 1),
                    backgroundColor: Colors.blue,
                    content: const Text(
                      'جاري تجديث البيانات',
                      textAlign: TextAlign.center,
                    ),
                    action: SnackBarAction(
                      label: 'dimiss',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );
                  // Find the ScaffoldMessenger in the widget tree
                  // and use it to show a SnackBar.
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  await delete();

                  await getItems();
                  await getCustomer();

                  await save();
                  print("done");
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  final snackBar1 = SnackBar(
                    backgroundColor: Color.fromRGBO(51, 168, 180, 1),
                    content: const Text(
                      ' تم تحديث البيانات',
                      textAlign: TextAlign.center,
                    ),
                    action: SnackBarAction(
                      label: 'dimiss',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar1);
                  setState(() {
                    _isLoading = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: const Color.fromRGBO(51, 168, 180, 1),
                ),
                icon: _isLoading
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: const Text('تحديث البيانات'),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 25 / 812,
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 300 / 375,
              height: MediaQuery.of(context).size.height * (52 / 812),
              child: ElevatedButton.icon(
                onPressed: () async {
                  setState(() {});
                  _isLoading1 ? null : _onSubmit1();

                  await sendDate.sendInvoices();
                  if (SendDate.message == "") {
                    final snackBar = SnackBar(
                      backgroundColor: Color.fromRGBO(51, 168, 180, 1),
                      content: const Text(
                        ' تم ارسال البيانات',
                        textAlign: TextAlign.center,
                      ),
                      action: SnackBarAction(
                        label: 'dimiss',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      _isLoading1 = false;
                    });
                  } else {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red[700],
                      content: Text(
                        SendDate.message,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      action: SnackBarAction(
                        label: 'dimiss',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.

                    setState(() {
                      _isLoading1 = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  setState(() {
                    _isLoading1 = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: const Color.fromRGBO(51, 168, 180, 1),
                ),
                icon: _isLoading1
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.send),
                label: const Text('ارسال البيانات'),
              ),
            ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 300 / 375,
            //   height: MediaQuery.of(context).size.height * (52 / 812),
            //   child: MaterialButton(
            //       color: const Color.fromRGBO(51, 168, 180, 1),
            //       onPressed: () async {
            //         await sendDate.sendInvoices();

            //         final snackBar = SnackBar(
            //           backgroundColor: Color.fromRGBO(51, 168, 180, 1),
            //           content: const Text(
            //             ' تم ارسال البيانات',
            //             textAlign: TextAlign.center,
            //           ),
            //           action: SnackBarAction(
            //             label: 'dimiss',
            //             onPressed: () {
            //               // Some code to undo the change.
            //             },
            //           ),
            //         );

            //         // Find the ScaffoldMessenger in the widget tree
            //         // and use it to show a SnackBar.
            //         ScaffoldMessenger.of(context).showSnackBar(snackBar);

            //         // await dbHelper.retrieveUsers();
            //       },
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           const Text(
            //             "ارسال البيانات",
            //             style: TextStyle(fontSize: 12, color: Colors.white),
            //           ),
            //           SizedBox(
            //             width: 5,
            //           ),
            //           Padding(
            //             padding: EdgeInsets.only(
            //                 right: MediaQuery.of(context).size.width * 0.0),
            //             child: const Icon(
            //               Icons.send,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ],
            //       )),
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 300 / 375,
              height: MediaQuery.of(context).size.height * (52 / 812),
              child: MaterialButton(
                  color: const Color.fromRGBO(51, 168, 180, 1),
                  onPressed: () async {
                    await deleteFile();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "تسجيل الخروج",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.0),
                        child: const Icon(
                          Icons.exit_to_app_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
            ),
            Text("عدد الفواتير الغير مرسله :" + count.toString())
          ],
        )),
      ),
    );
  }

  Future<void> save() async {
    for (int i = 0; i < itemsModel.length; i++) {
      await dbHelper.insertItems(itemsModel[i]);
    }
    for (int i = 0; i < customersModel.length; i++) {
      await dbHelper.insertCustomer(customersModel[i]);
    }
  }

// Future<void> save2() async {
//     for (int i = 0; i < itemsModel.length; i++) {
//       await dbHelper.db.
//     }
//     for (int i = 0; i < customersModel.length; i++) {
//       await dbHelper.insertCustomer(customersModel[i]);
//     }
//   }

  Future<void> delete() async {
    await dbHelper.deleteCustomers();
    await dbHelper.deleteitems();
  }

  Future<void> getItems() async {
    String jsonString;
    String t = await _login.tocken();

    var headers = {'Authorization': 'Bearer ' + t};

    var request =
        http.Request('GET', Uri.parse(MyApp.apiUrl + 'nsbase/getinvenitembal'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      jsonString = await response.stream.bytesToString();
      Map<String, dynamic> mydata = jsonDecode(jsonString);
      for (int i = 0; i < mydata["data"].length; i++) {
        itemsModel.add(ItemsModel(
            mydata["data"][i]["id"].toString(),
            mydata["data"][i]["name"].toString(),
            double.parse(mydata["data"][i]["price"].toString()),
            double.parse(mydata["data"][i]["qty"].toString()),
            mydata["data"][i]["barcode"].toString(),
            int.parse(mydata["data"][i]["hasserialno"].toString())));
      }
    }
  }

  void display() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            value: controller.value,
            semanticsLabel: 'Circular progress indicator',
          ),
        );
      },
    );
  }

  Future<String> get getDirPath async {
    final _dir = await getApplicationDocumentsDirectory();
    return _dir.path;
  }

  Future<void> deleteFile() async {
    final _dirPath = await getDirPath;

    final _myFile = File('$_dirPath/data.txt');
    await _myFile.delete();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyApp()));
  }

  Future<void> getCustomer() async {
    String jsonString;
    String t = await _login.tocken();
    var headers = {'Authorization': 'Bearer ' + t};

    var request =
        http.Request('GET', Uri.parse(MyApp.apiUrl + 'nsbase/getcustomers'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      jsonString = await response.stream.bytesToString();
      Map<String, dynamic> mydata = jsonDecode(jsonString);
      for (int i = 0; i < mydata["data"].length; i++) {
        customersModel.add(CustomersModel(mydata["data"][i]["id"].toString(),
            mydata["data"][i]["name"].toString()));
      }
    }
  }
}
