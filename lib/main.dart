import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nilesoft_app/DatabaseHelper.dart';
import 'package:nilesoft_app/Databasemodels/settings.dart';
import 'package:path_provider/path_provider.dart';

import 'screens/home.dart';

//  mobileUserId TEXT ALLOW NULL,
//   cashaccId TEXT ALLOW NULL,
//   coinPrice TEXT ALLOW NULL,
//   invPrice TEXT ALLOW NULL,
//   visaId TEXT ALLOW NULL

String? mobileUserId;
String? cashaccId;
String? coinPrice;
String? invid;
String? visaId;
int? invoiceSerial;
late DatabaseHelper dbHelper;
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Almarai',
    ),
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the HomeScreen widget.
      '/': (context) => const MyApp(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/second': (context) => const MyApp1(),
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static String apiUrl = "http://api.alfaysalerp.com/";
  //static String apiUrl = "http://192.168.1.27:7000/";
  static String? mytocken;

  @override
  State<MyApp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  final idTextField = TextEditingController();
  final passwordTextField = TextEditingController();
  String _content = "";
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
    start();
  }

  @override
  Widget build(BuildContext context) {
    //double x = MediaQuery.of(context).size.width / 10;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        Stack(
          children: [
            Container(
              width: width,
              height: MediaQuery.of(context).size.height * 0.37,
              color: Color.fromRGBO(58, 127, 134, 1),
            ),
            SizedBox(
              width: width,
              height: MediaQuery.of(context).size.height * 0.40,
              // color: Color.fromRGBO(58, 127, 134, 1),
              child: FittedBox(
                child: Image.asset('assets/Union6.png'),
                fit: BoxFit.fill,
              ),
            ),
            const Positioned(
                left: -151,
                top: 1,
                child: Image(image: AssetImage("assets/Untitled-1.png"))),
          ],
        ),
        // Container(
        //   height: MediaQuery.of(context).size.height * 0.31,
        //   width: width,
        //   decoration: const BoxDecoration(
        //     color: Color(0x3A7F86),
        //     image: DecorationImage(
        //         image: AssetImage("assets/Union6.png"),
        //         repeat: ImageRepeat.repeat,
        //         fit: BoxFit.fill),
        //   ),
        // ),
        SizedBox(
          height: MediaQuery.of(context).size.height * (100 / 812),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 40.0),
              child: TextFormField(
                style: const TextStyle(
                  fontStyle: FontStyle.normal,
                ),
                controller: idTextField,
                enableSuggestions: true,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'id',
                  icon: Icon(Icons.person_outline),
                  labelText: 'id',
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 40.0),
              child: TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordTextField,
                decoration: const InputDecoration(
                    icon: Icon(Icons.lock_outline),
                    hintText: 'Password',
                    labelText: 'Password'),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (50 / 812),
            ),
            MaterialButton(
                color: Color.fromRGBO(78, 187, 197, 1),
                minWidth: MediaQuery.of(context).size.width * (300 / 375),
                height: MediaQuery.of(context).size.height * (52 / 812),
                //Color.fromRGBO(78, 187, 197, 1)
                onPressed: () async {
                  var headers = {'Content-Type': 'application/json'};

                  var request = http.Request(
                      'POST', Uri.parse(MyApp.apiUrl + 'users/authenticate'));
                  request.body = json.encode({
                    "Username": idTextField.text.toString(),
                    "Password": passwordTextField.text.toString()
                  });
                  request.headers.addAll(headers);

                  http.StreamedResponse response = await request.send();
                  if (response.statusCode == 200) {
                    String jsonString = await response.stream.bytesToString();
                    // print(jsonString);
                    Map<String, dynamic> userMap = jsonDecode(jsonString);
                    MyApp.mytocken = userMap['jwtToken'];
                    mobileUserId = userMap["mobileinvoiceid"].toString();
                    coinPrice = "1";
                    invid = userMap["invenid"];
                    visaId = userMap["visaid"];
                    cashaccId = userMap["cashid"];
                    SettingsModel settingsModel = SettingsModel(
                        cashaccId: cashaccId,
                        coinPrice: coinPrice,
                        invId: invid,
                        mobileUserId: mobileUserId,
                        visaId: visaId);
                    dbHelper.deleteSettings();
                    dbHelper.insertSettings(settingsModel);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyApp1()));

                    await _writeData(idTextField.text, passwordTextField.text);
                  }
                },
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ]),
    ));
  }

  Future<String> get getDirPath async {
    final _dir = await getApplicationDocumentsDirectory();
    return _dir.path;
  }

  Future<void> _readData() async {
    try {
      final _dirPath = await getDirPath;
      final _myFile = File('$_dirPath/data.txt');
      final _data = await _myFile.readAsString(encoding: utf8);
      setState(() {
        _content = _data;
        print(_content);
      });
    } catch (e) {}
  }

  login() {}
  Future<void> deleteFile() async {
    final _dirPath = await getDirPath;

    final _myFile = File('$_dirPath/data.txt');
    _myFile.delete();
  }

  Future<void> _writeData(String user, String pass) async {
    final _dirPath = await getDirPath;

    final _myFile = File('$_dirPath/data.txt');
    // If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString("""{
      "Username":"$user",
      "password":"$pass"
    }""");
  }

  Future<void> start() async {
    try {
      await _readData();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    if (_content == "") {
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyApp1()));
    }
  }
}

class LoginModel {
  String? userName;
  String? password;
  LoginModel({this.userName, this.password});
}
