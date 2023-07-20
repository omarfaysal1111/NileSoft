SerialNumbersHead serialNumbersHead = SerialNumbersHead();

class SendingSerials {
  SerialNumbersHead? serialNumbersHead;

  List<SerialNumbers> serialnumber = [];
  SendingSerials({this.serialNumbersHead, serialnumber});
  SendingSerials.fromMap(Map<String, dynamic> res)
      : serialNumbersHead = res["s"],
        serialnumber = res["serialnumber"];

  Map toJson() {
    List s = serialnumber.map((i) => i.toMap()).toList();

    return {"invoiceid": serialNumbersHead!.invoiceid, "dtl": s};
  }
}

class SerialNumbersHead {
  int? invoiceid;
  SerialNumbersHead({this.invoiceid});
  SerialNumbersHead.fromMap(Map<String, dynamic> res)
      : invoiceid = res["invoiceid"];

  Map<String, Object?> toMap() {
    return {"invoiceid": invoiceid};
  }
}

class SerialNumbers {
  String? serialNumber;
  SerialNumbers({this.serialNumber});
  SerialNumbers.fromMap(Map<String, dynamic> res)
      : serialNumber = res["serialNumber"];

  Map<String, Object?> toMap() {
    return {"serialnumber": serialNumber};
  }
}
