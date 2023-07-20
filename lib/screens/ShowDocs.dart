import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nilesoft_app/apiModels/Login.dart';
import 'package:nilesoft_app/screens/SalesPreview.dart';
import 'package:nilesoft_app/screens/cashinPreview.dart';
import 'package:nilesoft_app/screens/ordersPreview.dart';
import 'package:nilesoft_app/screens/sales.dart';
import 'package:nilesoft_app/sendData.dart';

import '../DatabaseHelper.dart';
import '../apiModels/CustomersModel.dart';
import '../apiModels/ItemsModel.dart';
import '../main.dart';
import 'cashin.dart';
import 'order.dart';
import 'package:http/http.dart' as http;

class MyApp5 extends StatefulWidget {
  const MyApp5({Key? key}) : super(key: key);

  // const MyApp1({Key? key, required this.title}) : super(key: key);

  // final String title;

  @override
  State<MyApp5> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp5> {
  List<CustomersModel> customersModel = [];
  List<ItemsModel> itemsModel = [];
  SendDate sendDate = SendDate();
  Login _login = Login();
  String dropdownvalue = 'اختر العميل';
  String dropdownvalue2 = 'اختر المنتج';
  final byanTextField = TextEditingController();
  // List of items in our dropdown menu

  late DatabaseHelper dbHelper;

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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            "استعراض  البيانات",
            style: TextStyle(
              color: Color.fromRGBO(34, 112, 120, 1),
            ),
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
                        height: MediaQuery.of(context).size.height / 6,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyApp6()));
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
                                          9),
                                  child: const Text("استعراض فواتير المبيعات"),
                                ),
                                Image.asset(
                                  "assets/invoice.png",
                                  fit: BoxFit.fill,
                                  alignment: Alignment.centerRight,
                                ),
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
              //           height: MediaQuery.of(context).size.height / 6,
              //           child: GestureDetector(
              //             onTap: () {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) =>
              //                           const CashinPreview()));
              //             },
              //             child: Card(
              //               elevation: 2,
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
              //                             9),
              //                     child: const Text("استعراض سندات الفبض"),
              //                   ),
              //                   Image.asset(
              //                     "assets/cashin.png",
              //                     fit: BoxFit.fill,
              //                     alignment: Alignment.centerRight,
              //                   ),
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
              //           height: MediaQuery.of(context).size.height / 6,
              //           child: GestureDetector(
              //             onTap: () {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) =>
              //                           const OrdersPreview()));
              //             },
              //             child: Card(
              //               elevation: 2,
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
              //                             9),
              //                     child: const Text("استعراض الطلبيات"),
              //                   ),
              //                   Image.asset(
              //                     "assets/order.png",
              //                     fit: BoxFit.fill,
              //                     alignment: Alignment.centerRight,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ]),
          ],
        )),
      ),
    );
  }

  Future<void> save() async {
    for (int i = 0; i < itemsModel.length; i++) {
      dbHelper.insertItems(itemsModel[i]);
    }
    for (int i = 0; i < customersModel.length; i++) {
      dbHelper.insertCustomer(customersModel[i]);
    }
  }

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
            int.parse(mydata["data"][i]["hasserial"].toString())));
      }
    }
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
