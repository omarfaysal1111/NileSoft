// ignore_for_file: file_names

class CashinModel {
  int? clientId;
  String? clientName;
  String? notes;
  double? price;

  CashinModel({
    this.clientId,
    this.clientName,
    this.notes,
    this.price,
  });
  CashinModel.fromMap(Map<String, dynamic> res)
      : clientId = res["clientId"],
        clientName = res["clientName"],
        notes = res["notes"],
        price = res["price"];

  Map<String, Object?> toMap() {
    return {
      "clientId": clientId,
      "clientName": clientName,
      "notes": notes,
      "price": price
    };
  }
}
