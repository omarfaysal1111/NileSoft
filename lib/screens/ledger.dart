import 'dart:convert';

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:nilesoft_app/apiModels/LedgerRepPara.dart';
import 'package:http/http.dart' as http;
import 'package:nilesoft_app/apiModels/ledgerPage.dart';
import 'package:nilesoft_app/apiModels/ledgerfirstrep.dart';

import '../CustomersToShow.dart';
import '../DatabaseHelper.dart';
import '../apiModels/Login.dart';
import '../main.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({Key? key}) : super(key: key);

  @override
  State<LedgerScreen> createState() => _MyWidgetState();
}

TextEditingController dateInput = TextEditingController();
TextEditingController todateInput = TextEditingController();

class _MyWidgetState extends State<LedgerScreen> {
  var scroll = ScrollController();
  var preventCall = false;

  @override
  void dispose() {
    scroll.removeListener(onScroll);
    super.dispose();
  }

  Future yourFuture() async {
    await getPage();
  }

  void onScroll() {
    var position = scroll.position.pixels;
    if (position >= scroll.position.maxScrollExtent - 10) {
      if (!preventCall) {
        yourFuture().then((_) => preventCall = false);
        preventCall = true;
      }
    }
  }

  late DatabaseHelper dbHelper;
  Login _login = Login();
  LedgerFirstRep ledgerFirstRep = LedgerFirstRep(
      checks: 0, currentBalance: 0, openbal: 0, totalCridet: 0, totalDebit: 0);
  List<LedgerPage> ledgerPage = [];
  String? accId = "";
  DateTime? pickedfromDate;
  List page = [];
  DateTime? pickedtoDate;
  int noOfRows = 0;
  LedgerRepPara _ledgerRepPara = LedgerRepPara();
  CustomersToShow customersModel = CustomersToShow([".."], [""]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DatabaseHelper();
    dbHelper.initDB().whenComplete(() async {
      setState(() {
        // print("x");
        // print(dbHelper.retrieveUsers().toString());
        // print(dbHelper.retrieveUsers2());
      });
    });
    getCustomer();
    scroll.addListener(onScroll);
    dateInput.text = "";
    todateInput.text = "";
    super.initState();
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
      // backgroundColor: Colors.blueGrey[50],
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "تقرير كشف حساب العميل",
          style: TextStyle(
            color: Color.fromRGBO(34, 112, 120, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          // height: height,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      width: width * (.5),
                      child: TextField(
                        controller: todateInput,
                        //editing controller of this TextField
                        decoration: InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "الى" //label text of field
                            ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          pickedtoDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100));

                          if (pickedtoDate != null) {
                            print(
                                pickedtoDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate = intl.DateFormat('yyyy-MM-dd')
                                .format(pickedtoDate!);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            setState(() {
                              todateInput.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      )),
                  SizedBox(
                      width: width * (.5),
                      child: TextField(
                        controller: dateInput,
                        //editing controller of this TextField
                        decoration: InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText: "من" //label text of field
                            ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          pickedfromDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100));

                          if (pickedfromDate != null) {
                            print(
                                pickedfromDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate = intl.DateFormat('yyyy-MM-dd')
                                .format(pickedfromDate!);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            setState(() {
                              dateInput.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ))
                ],
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.05,
                  child: EasyAutocomplete(
                      suggestions: customersModel.name,
                      decoration:
                          const InputDecoration(hintText: "اختر العميل"),
                      suggestionTextStyle: const TextStyle(fontSize: 18),
                      onChanged: (value) =>
                          // ignore: avoid_print
                          print('onChanged value: $value'),
                      onSubmitted: (value) {
                        print('onSubmitted value: $value');
                        setState(() {
                          accId = (customersModel
                              .id[customersModel.name.indexOf(value)]);
                          print(accId);
                        });
                      }),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 20,
                child: MaterialButton(
                    color: Color.fromRGBO(34, 112, 120, 1),
                    onPressed: () async {
                      if (accId == '') {
                        final snackBar = SnackBar(
                          content: const Text('رجاء اختيار العميل'),
                          backgroundColor: (Colors.red),
                          action: SnackBarAction(
                            label: 'الغاء',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        setState(() {
                          page = [];
                          // editOrAdd = 0;
                          // itemTextField.text = "";
                        });

                        await getLedger();
                        await getPage();
                        //  dbHelper.retrieveUsers2();
                      }
                      // _displayDialog(context);
                    },
                    child: const Text(
                      "موافق",
                      style: TextStyle(fontSize: 12),
                    )),
              ),
              SizedBox(
                width: width * (350 / 375),
                height: MediaQuery.of(context).size.height * (140 / 812),
                child: Card(
                  elevation: 2,
                  color: const Color.fromRGBO(245, 245, 245, 1),
                  shadowColor: Color.fromRGBO(0, 0, 0, 1),
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(
                          color: Color.fromRGBO(139, 139, 139, .5), width: 1),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.0),
                        bottom: Radius.circular(15.0),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,

                            width:
                                MediaQuery.of(context).size.width * (51 / 375),

                            // width: MediaQuery.of(context).size.width / 2.5,
                            child: Column(
                              children: [
                                Text("اجمالي المدين "),
                                Text(ledgerFirstRep.totalDebit.toString()),
                              ],
                            ),
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * (191 / 375),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width:
                                MediaQuery.of(context).size.width * (51 / 375),
                            child: Column(
                              children: [
                                Text(" الافتتاحي"),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 200,
                                ),
                                Text(ledgerFirstRep.openbal.toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width:
                                MediaQuery.of(context).size.width * (51 / 375),

                            // width: MediaQuery.of(context).size.width / 2.1,
                            child: Column(
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("الرصيد الحالي ")),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 200,
                                ),
                                Text(ledgerFirstRep.currentBalance.toString()),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width:
                                MediaQuery.of(context).size.width * (51 / 375),
                            child: Column(
                              children: [
                                Text("اجمالي الدائن "),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 200,
                                ),
                                Text(ledgerFirstRep.totalCridet.toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  color: Colors.blueGrey[50],
                  height: MediaQuery.of(context).size.height / 2,
                  child: myWidget(context)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getLedger() async {
    _ledgerRepPara.accid = accId;
    _ledgerRepPara.openbal = 0;
    _ledgerRepPara.firstrow = 0;
    _ledgerRepPara.type = "3";
    _ledgerRepPara.fromdate = pickedfromDate.toString().substring(0, 10);
    _ledgerRepPara.todate = pickedtoDate.toString().substring(0, 10);
    String jsonString;
    String t = await _login.tocken();

    var headers = {
      'Authorization': 'Bearer ' + t,
      'Content-Type': 'application/json'
    };

    var request =
        http.Request('POST', Uri.parse(MyApp.apiUrl + 'ledger/getNoofRows'));
    request.body = (jsonEncode(_ledgerRepPara.toMap()));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      jsonString = await response.stream.bytesToString();
      Map<String, dynamic> mydata = jsonDecode(jsonString);
      setState(() {
        ledgerFirstRep = LedgerFirstRep.fromMap(jsonDecode(jsonString));
        _ledgerRepPara.accid = accId;
        _ledgerRepPara.openbal = ledgerFirstRep.openbal;
        _ledgerRepPara.firstrow = 0;
        _ledgerRepPara.type = "3";
        _ledgerRepPara.fromdate = pickedfromDate.toString().substring(0, 10);
        _ledgerRepPara.todate = pickedtoDate.toString().substring(0, 10);
      });
    }
  }

  Future<void> getPage() async {
    if (page.length < int.parse(ledgerFirstRep.noofrows.toString())) {
      if (page.isNotEmpty) {
        _ledgerRepPara.openbal = page[page.length - 1]['balance'];
        _ledgerRepPara.firstrow = page.length;
      }
      String jsonString;
      String t = await _login.tocken();

      var headers = {
        'Authorization': 'Bearer ' + t,
        'Content-Type': 'application/json'
      };

      var request =
          http.Request('POST', Uri.parse(MyApp.apiUrl + 'ledger/getpage'));
      request.body = (jsonEncode(_ledgerRepPara.toMap()));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        jsonString = await response.stream.bytesToString();
        Map<String, dynamic> mydata = jsonDecode(jsonString);
        for (int i = 0; i < mydata['data'].length; i++) {
          setState(() {
            page.add(mydata['data'][i]);
          });
        }
      }
    }
  }

  Widget myWidget(BuildContext context) {
    return ListView.builder(
      controller: scroll,
      itemCount: page.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 5,
          child: Card(
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text("نوع المستند"),
                        Text(page[index]['doctype']),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    Column(
                      children: [
                        Text("رقم المستند"),
                        Text(page[index]['docno']),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    Column(
                      children: [
                        Text("التاريخ"),
                        Text(page[index]['docdate']),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 80,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 80,
                            ),
                          ],
                        ),
                        Container(child: Text("البيان")),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 12,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: Text(page[index]['descr'])),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 12,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text("الرصيد"),
                        Text(page[index]['balance'].toString()),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    Column(
                      children: [
                        Text("الدائن"),
                        Text(page[index]['credit'].toString()),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.6,
                    ),
                    Column(
                      children: [
                        Text("المدين"),
                        Text(page[index]['debit'].toString()),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
