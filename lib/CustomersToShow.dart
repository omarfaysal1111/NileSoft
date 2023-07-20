// ignore_for_file: file_names

class CustomersToShow {
  List<String> name = [];
  List<String> id = [];
  CustomersToShow(this.id, this.name);
  CustomersToShow.fromMap(Map<String, dynamic> res) {
    id = res["id"];
    name = res["name"];
  }
  Map<String, Object?> toMap() {
    return {"id": id, "name": name};
  }
}
