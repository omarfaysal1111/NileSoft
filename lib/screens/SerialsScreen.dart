import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nilesoft_app/Databasemodels/serials.dart';
import 'package:nilesoft_app/Databasemodels/serialstoSend.dart';
import 'package:nilesoft_app/apiModels/ItemsSerials.dart';
import 'package:nilesoft_app/sendData.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../DatabaseHelper.dart';
import 'home.dart';

class SerialsScreen extends StatefulWidget {
  final String id;
  final int numOfSerials;
  const SerialsScreen({Key? key, required this.id, required this.numOfSerials})
      : super(key: key);

  @override
  State<SerialsScreen> createState() => _MyWidgetState();
}

List<SerialsModel> serialNumbers = [];
final serialTextField = TextEditingController();
String? result;
int Serials = 0;
int ok = 0;
ItemsSerialsModel _itemsSerialsModel = ItemsSerialsModel("", "", "");
late DatabaseHelper dbHelper;

class _MyWidgetState extends State<SerialsScreen> {
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
    getserials();
    serialTextField.clear();
    serialNumbers = [];
    Serials = 0;
  }

  Future<List> getserials() async {
    String s = "select * from serials where invid= '" + widget.id + "'";
    final List<Map<String, Object?>> queryResult =
        await dbHelper.db.rawQuery(s);
    if (queryResult.isNotEmpty) {
      for (var i = 0; i < queryResult.length; i++) {
        SerialsModel _serialNumbers = SerialsModel();
        _serialNumbers.serialNumber = queryResult[i]["serialNumber"].toString();
        _serialNumbers.invId = queryResult[i]["invid"].toString();
        setState(() {
          serialNumbers.add(_serialNumbers);
        });
      }
    }

    print(queryResult);
    return queryResult;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(color: Color.fromRGBO(34, 112, 120, 1)),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "ادخال الارقام المسلسله",
            // textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,

            style: TextStyle(
              color: Color.fromRGBO(34, 112, 120, 1),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ));
                  setState(() {
                    if (res is String) {
                      result = res;

                      serialTextField.text = res;
                    }
                  });
                },
                child: const Icon(Icons.qr_code),
              ),
              SizedBox(
                width: width * (2 / 3),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      style: const TextStyle(fontStyle: FontStyle.normal),
                      controller: serialTextField,
                      decoration: const InputDecoration(
                        hintText: 'الرقم  المسلسل',
                        labelText: 'الرقم المسلسل',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          MaterialButton(
            color: const Color.fromRGBO(51, 168, 180, 1),
            onPressed: () {
              dbHelper.deleteSerial(widget.id, serialTextField.text.toString());
              Serials = serialNumbers.length;
              if (Serials < widget.numOfSerials) {
                if (serialNumbers.isNotEmpty) {
                  for (var i = 0; i < serialNumbers.length; i++) {
                    if (serialTextField.text != serialNumbers[i].serialNumber) {
                      ok = 1;
                    }
                  }
                  if (ok == 1) {
                    setState(() {
                      serialNumbers.add(SerialsModel(
                          invId: widget.id,
                          serialNumber: serialTextField.text));
                      Serials++;
                    });
                  }
                } else {
                  setState(() {
                    serialNumbers.add(SerialsModel(
                        invId: widget.id, serialNumber: serialTextField.text));
                    Serials++;
                  });
                  Serials = Serials;
                }
              } else if (Serials == serialNumbers.length) {
                for (var i = 0; i < serialNumbers.length; i++) {
                  dbHelper.deleteSerial(serialNumbers[i].invId.toString(),
                      serialNumbers[i].serialNumber.toString());
                  dbHelper.insertSerials(serialNumbers[i]);
                }
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const MyApp1()));
              }

              if (Serials == widget.numOfSerials) {
                for (var i = 0; i < serialNumbers.length; i++) {
                  dbHelper.deleteSerial(serialNumbers[i].invId.toString(),
                      serialNumbers[i].serialNumber.toString());
                  dbHelper.insertSerials(serialNumbers[i]);
                }
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const MyApp1()));
              }
              // if (Serials < widget.numOfSerials) {
              //   if (serialNumbers.isNotEmpty) {
              //     for (var i = 0; i < serialNumbers.length; i++) {
              //       if (serialTextField.text != serialNumbers[i].serialNumber) {
              //         setState(() {
              //           serialNumbers.add(SerialsModel(
              //               invId: widget.id,
              //               serialNumber: serialTextField.text));
              //         });
              //       }
              //       Serials++;
              //     }
              //   } else {
              //     setState(() {
              //       serialNumbers.add(SerialsModel(
              //           invId: widget.id, serialNumber: serialTextField.text));
              //     });
              //     Serials++;
              //   }
              // } else {
              //   for (var i = 0; i < serialNumbers.length; i++) {
              //     dbHelper.insertSerials(serialNumbers[i]);
              //   }
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => const MyApp1()));
              // }
              // serialTextField.clear();
              // if (Serials == widget.numOfSerials) {
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => const MyApp1()));
              // }
              serialTextField.clear();
            },
            child: Text(
              "اضافة سيريال",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "الارقام المسلسلة",
              ),
              Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: serialList(context)),
            ],
          ),
          MaterialButton(
            color: const Color.fromRGBO(51, 168, 180, 1),
            onPressed: () {
              Serials = serialNumbers.length;

              if (Serials == widget.numOfSerials) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyApp1()));
              } else {
                final snackBar1 = SnackBar(
                  backgroundColor: Color.fromRGBO(51, 168, 180, 1),
                  content: const Text(
                    ' لم يتم ادخال جميع الارقام المطلوب ادخالها',
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
              }
            },
            child: Text(
              "موافق",
              style: TextStyle(color: Colors.white),
            ),
          ),
          // MaterialButton(
          //   onPressed: () {
          //     // SendDate sendDate = SendDate();
          //     // sendDate.sendSerials();
          //     for (var i = 0; i < serialNumbers.length; i++) {
          //       dbHelper.insertSerials(serialNumbers[i]);
          //     }
          //     // Navigator.push(context,
          //     //     MaterialPageRoute(builder: (context) => const MyApp1()));
          //   },
          //   child: Text("حفظ"),
          // )
        ]),
      ),
    );
  }

  Widget serialList(BuildContext context) {
    return ListView.builder(
      itemCount: serialNumbers.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 40,
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Text(
                                serialNumbers[index].serialNumber.toString()),
                          ),
                          GestureDetector(
                              onTap: () {
                                dbHelper.deleteSerial(
                                    serialNumbers[index].invId.toString(),
                                    serialNumbers[index]
                                        .serialNumber
                                        .toString());
                                setState(() {
                                  serialNumbers.removeAt(index);
                                });
                              },
                              child: Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 163, 21, 10),
                              )),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
