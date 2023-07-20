class LedgerRepPara {
  String? accid;
  String? type;
  String? fromdate;
  String? todate;
  int? firstrow;
  double? openbal;
  LedgerRepPara(
      {this.accid,
      this.firstrow,
      this.fromdate,
      this.openbal,
      this.todate,
      this.type});
  LedgerRepPara.fromMap(Map<String, dynamic> res) {
    accid = res['accid'];
    firstrow = res['firstrow'];
    fromdate = res['fromdate'];
    todate = res['todate'];
    openbal = res['openbal'];
  }
  Map<String, Object?> toMap() {
    return {
      "accid": accid,
      "type": type,
      "fromdate": fromdate,
      "todate": todate,
      "firstrow": firstrow,
      "openbal": openbal
    };
  }
}
