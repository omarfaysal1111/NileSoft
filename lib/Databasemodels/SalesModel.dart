// ignore_for_file: file_names
import 'package:nilesoft_app/main.dart';

class SalesModel {
  SalesHeadModel? salesHeadModel;
  List<SalesDtlModel> salesdtlModel = [];
  SalesModel({this.salesHeadModel, salesdtlModel});
  SalesModel.fromMap(Map<String, dynamic> res) {
    salesHeadModel = res["salesHeadModel"];
  }
  Map toJson() {
    List salesdtlModel = this.salesdtlModel.map((i) => i.toMap()).toList();

    return {
      "accid": salesHeadModel!.accid,
      //    "clientName": salesHeadModel!.clientName,
      "descr": salesHeadModel!.descr,
      // "invtime": salesHeadModel!.invTime,
      // "docdate": salesHeadModel!.docdate,
      // "invtype": salesHeadModel!.invType,
      // "cashaccid": salesHeadModel!.cashaccid,
      // "coinprice": salesHeadModel!.coinPrice,
      "invoiceno": salesHeadModel!.invoiceno,
      "total": salesHeadModel!.total,
      "dis1": salesHeadModel!.dis1,
      "visaid": salesHeadModel!.visaid,
      "invenid": salesHeadModel!.invenid,
      "cashaccid": salesHeadModel!.cashaccid,
      "tax": salesHeadModel!.tax,
      "invtype": "1",
      "net": salesHeadModel!.net,
      // "sent": salesHeadModel!.sent,
      // "visaid": salesHeadModel!.visaId,
      "dtl": salesdtlModel
    };
  }
}

class SalesHeadModel {
  String? accid;
  String? clientName;
  String? descr;
  String? invoiceno;
  String? cashaccid;
  String? visaid;
  String? invenid;
  // String? invTime;
  // String? docdate;
  // String? invType;
  // String? cashaccid;
  // int? coinPrice = 1;
  double? total;
  double? dis1;

  double? tax;
  double? net;
  // String? visaId;
  int? sent;

  SalesHeadModel(
      {this.accid,
      this.clientName,
      this.descr,
      this.sent,
      // this.coinPrice,
//this.docdate,
      this.tax,
      this.dis1,
      // this.invType,
      this.cashaccid,
      this.visaid,
      this.invenid,
      this.net,
      this.total,
      this.invoiceno
      // this.visaId,
      // this.cashaccid
      });
  SalesHeadModel.fromMap(Map<String, dynamic> res)
      : accid = res["accid"],
        descr = res["descr"],
        sent = res["sent"];

  Map<String, Object?> toMap() {
    return {
      "accid": accid,
      "clientName": clientName,
      "descr": descr,
      // "invtime": invTime,
      "sent": sent,
      //  "docdate": docdate,
      // "invtype": invType,
      // "cashaccid": cashaccid,
      // "coinprice": coinPrice,
      "total": total,
      "dis1": dis1,
      "invoiceno": invoiceno,
      "tax": tax,
      "net": net,
      // "visaid": visaId,
      // "sent": sent
    };
  }
}

class SalesDtlModel {
  String? id;
  String? itemId;
  String? itemName;
  double? qty;
  double? price;
  double? tax;
  double? disratio;
  double? disam;
  // double? discount;
  int? sent;
  SalesDtlModel({
    this.id,
    this.itemId,
    this.itemName,
    // this.discount,
    this.price,
    this.disam,
    this.disratio,
    this.qty,
    this.tax,
  });
  SalesDtlModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        itemId = res["itemId"],
        itemName = res["itemName"],
        qty = res["qty"],
        price = res["price"],
        // discount = res["discount"],
        tax = res["tax"],
        sent = res["sent"];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "itemId": itemId,
      // "itemName": itemName,
      "qty": qty,
      "disam": disam,
      "disratio": disratio,
      "price": price,
      "tax": tax,
    };
  }
}
