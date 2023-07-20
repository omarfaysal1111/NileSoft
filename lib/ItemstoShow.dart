// ignore_for_file: file_names

class ItemsToShow {
  List<String> name = [];
  List<String> id = [];
  List<double> price = [];
  List<double> qty = [];
  List<double> hasserialno = [];
  ItemsToShow(this.id, this.name, this.price, this.qty, this.hasserialno);
  ItemsToShow.fromMap(Map<String, dynamic> res) {
    id = res["id"];
    name = res["name"];
    price = res["price"];
    qty = res["qty"];
    hasserialno = res["hasserialno"];
  }
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "qty": qty,
      "hasserialno": hasserialno
    };
  }
}
