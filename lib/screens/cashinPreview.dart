import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nilesoft_app/screens/singleCashin.dart';

import '../DatabaseHelper.dart';

class CashinPreview extends StatefulWidget {
  const CashinPreview({Key? key}) : super(key: key);

  @override
  State<CashinPreview> createState() => _MyWidgetState();
}

late DatabaseHelper databaseHelper;
List<Map<String, Object?>> cashin = [];

class _MyWidgetState extends State<CashinPreview> {
  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    databaseHelper.initDB().whenComplete(() async {
      setState(() {
        // print("x");
        // print(dbHelper.retrieveUsers().toString());
        // print(dbHelper.retrieveUsers2());
      });
    });
    getCashins();
  }

  Future<void> getCashins() async {
    String s1 = "select * from cashin";
    cashin = await databaseHelper.db.rawQuery(s1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("استعراض سندات القبض"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
            height: MediaQuery.of(context).size.height, child: _widget()),
      ),
    );
  }
}

Widget _widget() {
  return ListView.builder(
    itemCount: cashin.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleCashin(
                        clientName: cashin[index]['clientName'].toString(),
                        notes: cashin[index]['notes'].toString(),
                        price: double.parse(cashin[index]['price'].toString()),
                      )));
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 6,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text("القيمة"),
                          Text(cashin[index]['price'].toString()),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                      ),
                      Column(
                        children: [
                          Text("العميل"),
                          Text(cashin[index]['clientName'].toString()),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("غير مرسلة"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 7,
                      ),
                      Column(
                        children: [
                          Text("البيان"),
                          Text(cashin[index]['notes'].toString()),
                        ],
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ),
      );
    },
  );
}
