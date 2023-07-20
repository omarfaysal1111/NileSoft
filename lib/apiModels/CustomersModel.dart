// ignore_for_file: file_names

class CustomersModel {
  String? id;
  String? name;

  CustomersModel(this.id, this.name);
  CustomersModel.fromMap(Map<String, dynamic> res) {
    id = res['id'];
    name = res['name'];
  }
  Map<String, Object?> toMap() {
    return {"id": id, "name": name};
  }
}
