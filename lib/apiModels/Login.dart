import 'dart:convert';
import 'dart:io';

import 'package:nilesoft_app/Databasemodels/settings.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import 'package:http/http.dart' as http;

class Login {
  String _content = "";
  String t = "";
  Future<String> tocken() async {
    await _readData();
    var headers = {'Content-Type': 'application/json'};

    var request =
        http.Request('POST', Uri.parse(MyApp.apiUrl + 'users/authenticate'));
    request.body = (_content.toString());
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonString = await response.stream.bytesToString();
      // print(jsonString);
      Map<String, dynamic> userMap = jsonDecode(jsonString);

      //      mobileUserId TEXT ALLOW NULL,
      // cashaccId TEXT ALLOW NULL,
      // coinPrice TEXT ALLOW NULL,
      // invPrice TEXT ALLOW NULL,
      // visaId TEXT ALLOW NULL
      mobileUserId = userMap["mobileinvoiceid"].toString();
      coinPrice = "1";
      //invPrice = userMap["invprice"];
      visaId = userMap["visaid"];
      invoiceSerial = userMap["invoivrserial"];
      invid = userMap["invenid"];
      cashaccId = userMap["cashid"];

      SettingsModel settingsModel = SettingsModel(
        cashaccId: cashaccId,
        coinPrice: coinPrice,
        invId: invid,
        mobileUserId: mobileUserId,
        invoiceSerial: invoiceSerial,
        visaId: visaId,
      );
      dbHelper.deleteSettings();
      dbHelper.insertSettings(settingsModel);
      return userMap['jwtToken'];
    } else {
      return "Error";
    }
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
      _content = _data;
    } catch (e) {}
  }
}
