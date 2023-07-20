// ignore_for_file: file_names

import 'package:nilesoft_app/Databasemodels/SalesModel.dart';
import 'package:nilesoft_app/Databasemodels/cashinModel.dart';
import 'package:nilesoft_app/Databasemodels/orderModel.dart';
import 'package:nilesoft_app/Databasemodels/serials.dart';
import 'package:nilesoft_app/apiModels/CustomersModel.dart';
import 'package:nilesoft_app/apiModels/ItemsModel.dart';
import 'package:nilesoft_app/apiModels/ItemsSerials.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Databasemodels/settings.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  late Database db;

  factory DatabaseHelper() {
    return _databaseHelper;
  }
  Future<void> initDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(join(path, 'OmarDB000.db'),
        onCreate: (database, version) async {
      await database.execute(
        """
            CREATE TABLE salesInvoiceHead (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              accid TEXT ALLOW NULL,
              clientName TEXT ALLOW NULL,
              descr TEXT ALLOW NULL,
              invoiceno TEXT ALLOW NULL,
              total REAL ALLOW NULL,
              tax REAL ALLOW NULL,
              dis1 REAL ALLOW NULL, 
              net REAL ALLOW NULL,

              sent INTEGER ALLOW NULL
            )
          """,
      );
      await database.execute("""
            CREATE TABLE salesInvoiceDtl (
              id TEXT ALLOW NULL,
              itemId TEXT ALLOW NULL,
              itemName TEXT ALLOW NULL,
              qty REAL ALLOW NULL,
              price REAL ALLOW NULL,
              discount REAL ALLOW NULL,
              tax REAL ALLOW NULL,
              disam REAL ALLOW NULL,
              disratio REAL ALLOW NULL,
              sent INTEGER ALLOW NULL
            )
          """);
      await database.execute("""
           CREATE TABLE orderHead (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              clientId INTEGER ALLOW NULL,
              clientName TEXT ALLOW NULL,
              notes TEXT ALLOW NULL,
              sent INTEGER ALLOW NULL

           )
        """);
      await database.execute("""
           CREATE TABLE orderDtl (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              itemId INTEGER ALLOW NULL,
              itemName TEXT ALLOW NULL,
              qty REAL ALLOW NULL,
              price REAL ALLOW NULL,
              tax REAL ALLOW NULL,
              discount REAL ALLOW NULL,
              sent INTEGER ALLOW NULL
           )
        """);
      await database.execute("""
           CREATE TABLE cashIn (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              clientId INTEGER ALLOW NULL,
              clientName TEXT ALLOW NULL,
              notes TEXT ALLOW NULL,
              price REAL ALLOW NULL,
              sent INTEGER ALLOW NULL
           )
        """);
      await database.execute("""
CREATE TABLE Customers (
  id INT ALLOW NULL,
  name TEXT ALLOW NULL
)
""");
      await database.execute("""
CREATE TABLE items (
  itemid TEXT ALLOW NULL,
  name TEXT ALLOW NULL,
  price REAL ALLOW NULL,
  qty REAL ALLOW NULL,
  barcode TEXT ALLOW NULL,
  hasSerial REAL ALLOW NULL
)
""");
      await database.execute("""
CREATE TABLE itemsserials (
  itemid TEXT ALLOW NULL,
  name TEXT ALLOW NULL,
  serialNumber TEXT ALLOW NULL
)
""");

      await database.execute("""
CREATE TABLE serials (
  invid TEXT ALLOW NULL,
  serialNumber TEXT ALLOW NULL
)
""");
      await database.execute("""
CREATE TABLE settings (
  mobileUserId TEXT ALLOW NULL,
  cashaccId TEXT ALLOW NULL,
  coinPrice TEXT ALLOW NULL,
  invid TEXT ALLOW NULL,
  visaId TEXT ALLOW NULL,
  invoiceserial ALLOW NULL
)
""");
    }, version: 1);
  }

  Future<int> insertInvoiceHead(SalesHeadModel salesModel) async {
    int result = await db.insert('salesInvoiceHead', salesModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertSettings(SettingsModel settingsModel) async {
    int result = await db.insert('settings', settingsModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertitemsserials(ItemsSerialsModel salesModel) async {
    int result = await db.insert('itemsserials', salesModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertInvoiceDtl(SalesDtlModel salesModel) async {
    int result = await db.insert('salesInvoiceDtl', salesModel.toMap());

    return result;
  }

  Future<void> deleteDtl(String id) async {
    await db.delete(
      'salesInvoiceDtl',
      where: "id =" + id,
      //whereArgs: [id],
    );
  }

  Future<void> deleteSerial(String id, String serialNumber) async {
    await db.delete(
      'serials',
      where: "invid ='" + id + "' and serialNumber= '" + serialNumber + "'",
      //whereArgs: [id],
    );
  }

  Future<int> insertOrderHead(OrderHeadModel orderModel) async {
    int result = await db.insert('orderHead', orderModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertOrderDtl(OrderDtlModel orderDtlModel) async {
    int result = await db.insert('orderDtl', orderDtlModel.toMap());

    return result;
  }

  Future<int> insertItems(ItemsModel itemsModel) async {
    int result = await db.insert('items', itemsModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertCustomer(CustomersModel customersModel) async {
    int result = await db.insert('Customers', customersModel.toMap());

    // print(result);
    return result;
  }

  Future<void> deleteSettings() async {
    await db.delete(
      'settings',
      where: "1 = 1",
      //whereArgs: [id],
    );
  }

  Future<int> insertCashIn(CashinModel cashinModel) async {
    int result = await db.insert('cashIn', cashinModel.toMap());

    return result;
  }

  Future<int> insertSerials(SerialsModel serialsModel) async {
    int result = await db.insert('serials', serialsModel.toMap());

    return result;
  }

  Future<void> deleteCustomers() async {
    await db.delete(
      'Customers',
      where: "1 = 1",
      //whereArgs: [id],
    );
  }

  Future<void> deleteitems() async {
    await db.delete(
      'items',
      where: "1 = 1",
      //whereArgs: [id],
    );
  }

  Future<List<SalesHeadModel>> retrieveUsers() async {
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('select * from salesInvoiceDtl');
    print(queryResult);
    return queryResult.map((i) => SalesHeadModel.fromMap(i)).toList();
  }

  Future<List<CashinModel>> retrieveUsers2() async {
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('select * from cashIn');
    print(queryResult);
    return queryResult.map((i) => CashinModel.fromMap(i)).toList();
  }
}
