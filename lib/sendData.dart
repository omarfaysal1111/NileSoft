// ignore_for_file: file_names

import 'dart:convert';

import 'package:nilesoft_app/DatabaseHelper.dart';
import 'package:nilesoft_app/Databasemodels/SalesModel.dart';
import 'package:nilesoft_app/Databasemodels/serialstoSend.dart';
import 'package:nilesoft_app/Databasemodels/settings.dart';
import 'package:nilesoft_app/apiModels/Login.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

late DatabaseHelper databaseHelper;
Login _login = Login();

class SendDate {
  static String message = "";
  Future<void> sendInvoices() async {
    SalesHeadModel salesHeadModel = SalesHeadModel();
    SalesDtlModel salesDtlModel = SalesDtlModel();

    List temp = [];
    databaseHelper = DatabaseHelper();
    databaseHelper.initDB().whenComplete(() async {});
    String s1 = "select * from salesInvoiceHead where sent = 0";

    final List<Map<String, Object?>> invoiceHead =
        await databaseHelper.db.rawQuery(s1);
    String s0 = "select cashaccid,invid,visaid from settings";
    final List<Map<String, Object?>> settings =
        await databaseHelper.db.rawQuery(s0);
    SalesModel invoiceModel = SalesModel();
    for (int i = 0; i < invoiceHead.length; i++) {
      List invoiceModelList = [];
      salesHeadModel.accid = (invoiceHead[i]["accid"].toString());
      // salesHeadModel.coinPrice = 1;
      // salesHeadModel.cashaccid = invoiceHead[i]["cashaccid"].toString();
      salesHeadModel.dis1 = double.parse(invoiceHead[i]["dis1"].toString());
      salesHeadModel.invoiceno = invoiceHead[i]["invoiceno"].toString();
      salesHeadModel.cashaccid = settings[0]["cashaccId"].toString();
      salesHeadModel.visaid = settings[0]["visaId"].toString();
      salesHeadModel.invenid = settings[0]["invid"].toString();

      // salesHeadModel.invTime = invoiceHead[i]["invtime"].toString();
      // salesHeadModel.docdate = invoiceHead[i]["docdate"].toString();
      salesHeadModel.net = double.parse(invoiceHead[i]["net"].toString());
      // salesHeadModel.invType = invoiceHead[i]["invType"].toString();
      salesHeadModel.tax = double.parse(invoiceHead[i]["tax"].toString());
      salesHeadModel.total = double.parse(invoiceHead[i]["total"].toString());
      // salesHeadModel.visaId = invoiceHead[i]["visaid"].toString();

      //  salesHeadModel.clientName = invoiceHead[i]["acc"].toString();
      salesHeadModel.descr = invoiceHead[i]["descr"].toString();

      String s2 = "select * from salesInvoiceDtl where id=" +
          invoiceHead[i]["id"].toString();
      final List<Map<String, Object?>> invoicDtl =
          await databaseHelper.db.rawQuery(s2);
      // databaseHelper.db.rawUpdate(
      //     "UPDATE salesInvoiceDtl SET sent = 1 where id=" +
      //         invoiceHead[i]["id"].toString());
      for (int j = 0; j < invoicDtl.length; j++) {
        salesDtlModel.id = "0";
        salesDtlModel.itemId = invoicDtl[j]["itemId"].toString();
        //s salesDtlModel.itemName = invoicDtl[j]["itemName"].toString();
        salesDtlModel.price = double.parse(invoicDtl[j]["price"].toString());
        salesDtlModel.disam = double.parse(invoicDtl[j]["disam"].toString());
        salesDtlModel.disratio =
            double.parse(invoicDtl[j]["disratio"].toString());
        salesDtlModel.tax = double.parse(invoicDtl[j]["tax"].toString());
        salesDtlModel.qty = double.parse(invoicDtl[j]["qty"].toString());
        invoiceModel.salesdtlModel.add(salesDtlModel);
      }
      invoiceModel.salesHeadModel = salesHeadModel;
      invoiceModelList.add(invoiceModel.toJson());

      var s = jsonEncode(invoiceModelList[0]);
      String jsonString;
      String t = await _login.tocken();

      var headers = {
        'Authorization': 'Bearer ' + t,
        'Content-Type': 'application/json'
      };

      var request =
          http.Request('POST', Uri.parse(MyApp.apiUrl + 'salesinvoice/addnew'));
      request.body = ((s));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      print(response.reasonPhrase);
      if (response.statusCode == 200) {
        jsonString = await response.stream.bytesToString();
        Map<String, dynamic> mydata = jsonDecode(jsonString);
        if (mydata["message"] == 0) {
          String s1 = "select serialNumber from serials where invid='" +
              invoiceHead[i]["id"].toString() +
              "'";

          final List<Map<String, Object?>> myserials =
              await databaseHelper.db.rawQuery(s1);
          if (myserials.isNotEmpty) {
            await sendSerials(
                mydata["docno"], int.parse(invoiceHead[i]["id"].toString()));
          } else {
            databaseHelper.db.rawUpdate(
                "UPDATE salesInvoiceHead SET sent = 1 where id='" +
                    invoiceHead[i]["id"].toString() +
                    "'");
          }
        } else {
          if (mydata["myerrorlist"].length > 0) {
            message = mydata["myerrorlist"][0]["errCode"];
          }
        }
      }
    }
  }

  // SendingSerials sendingSerials = SendingSerials();

  // List<SerialNumbers> serialsno = [];

  Future<void> sendSerials(int docNumber, int id) async {
    List serials33 = [];
    SerialNumbersHead serialNumbersHead = SerialNumbersHead();
    SendingSerials sendingSerials = SendingSerials();
    String s1 =
        "select serialNumber from serials where invid='" + id.toString() + "'";

    final List<Map<String, Object?>> serials =
        await databaseHelper.db.rawQuery(s1);
    serialNumbersHead.invoiceid = docNumber;

    for (var i = 0; i < serials.length; i++) {
      SerialNumbers serialNumbers = SerialNumbers();

      serialNumbers.serialNumber = serials[i]["serialNumber"].toString();
      sendingSerials.serialnumber.add(serialNumbers);
    }
    sendingSerials.serialNumbersHead = serialNumbersHead;
    serials33.add(sendingSerials.toJson());

    var s = jsonEncode(serials33[0]);
    String jsonString;
    String t = await _login.tocken();

    var headers = {
      'Authorization': 'Bearer ' + t,
      'Content-Type': 'application/json'
    };

    var request = http.Request(
        'POST', Uri.parse(MyApp.apiUrl + 'salesinvoice/salesserial'));
    request.body = ((s));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print(response.reasonPhrase);
    if (response.statusCode == 200) {
      jsonString = await response.stream.bytesToString();
      Map<String, dynamic> mydata = jsonDecode(jsonString);
      if (mydata["message"] == 0) {
        databaseHelper.db.rawUpdate(
            "UPDATE salesInvoiceHead SET sent = 1 where id='" +
                id.toString() +
                "'");
      } else {}
    }
    print(s);
  }
}
