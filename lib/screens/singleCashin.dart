import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nilesoft_app/Databasemodels/SalesModel.dart';
import 'package:nilesoft_app/Databasemodels/cashinModel.dart';
import 'package:nilesoft_app/ItemstoShow.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import '../CustomersToShow.dart';
import '../DatabaseHelper.dart';
import 'home.dart';
import 'package:intl/intl.dart' as intl;

class SingleCashin extends StatefulWidget {
  final String? clientName;
  final String? notes;
  final double? price;
  const SingleCashin({Key? key, this.clientName, this.notes, this.price})
      : super(key: key);

  @override
  State<SingleCashin> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SingleCashin> {
  CustomersToShow customersModel = CustomersToShow([".."], [""]);
  ItemsToShow itemsModel = ItemsToShow([".."], [""], [], [], []);
  int id = -1;
  int globalIndex = 0;
  int editOrAdd = -1;
  SalesHeadModel? salesHeadModel;
  List<CashinModel> cashInModel = [];
  int? itemId;
  final itemTextField = TextEditingController();
  late DatabaseHelper dbHelper;
  String formattedDate = "";
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
    itemTextField.text = widget.clientName.toString();
    byanTextField.text = widget.notes.toString();
    cost.text = widget.price.toString();
    getCustomer();
    var now = new DateTime.now();
    var formatter = new intl.DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
  }

  String? clientName;
  String? clientid;
  String dropdownvalue = 'اختر اسم العميل';

  final byanTextField = TextEditingController();

  final cost = TextEditingController();

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
        title: const Text("سند قبض نقدي"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
          child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.2,
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          Column(children: [
            Text("$formattedDate"),
            Container(
              width: MediaQuery.of(context).size.width * 0.87,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: EasyAutocomplete(
                    suggestions: customersModel.name,
                    controller: itemTextField,
                    suggestionTextStyle: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      hintText: "اختر العميل",
                      icon: Icon(Icons.arrow_drop_down_sharp),
                    ),
                    //controller: itemsControllers[index],
                    // autofocus: true,
                    onChanged: (value) {
                      itemTextField.text = "";
                      if (editOrAdd == 0) {
                        if (kDebugMode) {
                          print('onChanged value: $value');
                        }
                        id = -1;
                      } else {
                        value = clientName.toString();
                      }
                    },
                    onSubmitted: (value) {
                      if (kDebugMode) {
                        print('onSubmitted value: $value');
                      }
                      id = 1;
                      //id = int.parse(itemsModel.id[index]);
                      s = customersModel.id[customersModel.name.indexOf(value)];
                      clientName = value;
                      itemTextField.text = value;
                    }),
              ),
            ),
            SingleChildScrollView(
                child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .9,
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

              // ignore: deprecated_member_use
            ])),
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  style: const TextStyle(
                      fontFamily: 'Almarai', fontStyle: FontStyle.normal),
                  controller: cost,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'المبلغ',
                    labelText: 'المبلغ',
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.height / 20,
                    child: ElevatedButton(
                        onPressed: () async {
                          cashInModel.add(CashinModel(
                              price: double.parse(cost.text),
                              notes: byanTextField.text,
                              clientId: int.parse(s),
                              clientName: clientName));
                          for (var i = 0; i < cashInModel.length; i++) {
                            await dbHelper.insertCashIn(cashInModel[i]);
                          }
                          setState(() {
                            cost.text = "";
                            byanTextField.text = "";
                          });
                          cashInModel = [];

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyApp1()));
                        },
                        child: const Text(
                          "انهاء سند القبض",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )),
                  ),

                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 2.5,
                  //   height: MediaQuery.of(context).size.height / 20,
                  //   child: ElevatedButton(
                  //       onPressed: () async {
                  //         await dbHelper.retrieveUsers2();
                  //         setState(() {
                  //           editOrAdd = 0;
                  //           itemTextField.text = "";
                  //         });
                  //
                  //         _displayDialog(context);
                  //       },
                  //       child: const Text(
                  //         "إضافة عميل جديد",
                  //         style: TextStyle(
                  //           fontSize: 12,
                  //         ),
                  //       )),
                  // ),
                ],
              ),
            ),
          )
        ]),
      )),
    );
  }

  Widget myWidget(BuildContext context) {
    return ListView.builder(
        itemCount: cashInModel.length,
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
                    "اسم العميل:     " +
                        cashInModel[index].clientName.toString(),
                    style: const TextStyle(
                      fontFamily: 'Almarai',
                      fontStyle: FontStyle.normal,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 80),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "المبلغ:     " + cashInModel[index].price.toString(),
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
                  SizedBox(height: MediaQuery.of(context).size.height / 80),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "البيان:     " + cashInModel[index].notes.toString(),
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
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 7),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                cashInModel.removeAt(index);
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

                                cost.text = cashInModel[index].price.toString();
                                byanTextField.text =
                                    cashInModel[index].notes.toString();
                                clientName =
                                    cashInModel[index].clientName.toString();
                                globalIndex = index;
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            )),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        });
  }

  String s = '';
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "اضافة جديد",
              textDirection: TextDirection.rtl,
            ),
            actions: <Widget>[
              Directionality(
                textDirection: TextDirection.rtl,
                child: EasyAutocomplete(
                    suggestions: customersModel.name,
                    controller: itemTextField,
                    suggestionTextStyle: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      hintText: "اختر العميل",
                      icon: Icon(Icons.arrow_drop_down_sharp),
                    ),
                    //controller: itemsControllers[index],
                    // autofocus: true,
                    onChanged: (value) {
                      itemTextField.text = "";
                      if (editOrAdd == 0) {
                        if (kDebugMode) {
                          print('onChanged value: $value');
                        }
                        id = -1;
                      } else {
                        value = clientName!;
                      }
                    },
                    onSubmitted: (value) {
                      if (kDebugMode) {
                        print('onSubmitted value: $value');
                      }
                      id = 1;
                      //id = int.parse(itemsModel.id[index]);
                      s = customersModel.id[customersModel.name.indexOf(value)];
                      clientName = value;
                      itemTextField.text = value;
                    }),
              ),
              SingleChildScrollView(
                  child: Column(children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.4,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          style: const TextStyle(
                              fontFamily: 'Almarai',
                              fontStyle: FontStyle.normal),
                          controller: cost,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'المبلغ',
                            labelText: 'المبلغ',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                    ),
                  ],
                ),

                // ignore: deprecated_member_use
                ElevatedButton(
                  child: const Text('حفظ',
                      style: TextStyle(
                          fontFamily: 'Almarai', fontStyle: FontStyle.normal)),
                  onPressed: () {
                    if (editOrAdd == 0) {
                      cashInModel.add(CashinModel(
                          price: double.parse(cost.text),
                          notes: byanTextField.text,
                          clientId: int.parse(s),
                          clientName: clientName));
                    } else {
                      setState(() {
                        cashInModel[globalIndex] = CashinModel(
                            price: double.parse(cost.text),
                            notes: byanTextField.text,
                            clientId: int.parse(s),
                            clientName: clientName);
                      });
                    }

                    if (kDebugMode) {
                      print(cashInModel.length);
                    }
                    itemTextField.clear();
                    Navigator.pop(context);
                  },
                )
              ])),
            ],
          );
        });
  }
}
