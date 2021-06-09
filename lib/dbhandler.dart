import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class dbHandler{
  static final _dbname = "elec.db";
  static final _dbver = 1;

  dbHandler._privateConstructor();
  static final dbHandler instance = dbHandler._privateConstructor();

  static Database _db;

  Future<Database> get database async{
    if(_db != null) return _db;
    _db = await _initDB();
    return _db;
  }

  _initDB() async{
    Directory docsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docsDirectory.path,_dbname);
    return await openDatabase(path,
      version: _dbver,
      onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async{
    Batch batch = db.batch();
    batch.execute(
        "CREATE TABLE IF NOT EXISTS client ( "
        "id INTEGER PRIMARY KEY, "
        "name TEXT NOT NULL, "
        "cellular TEXT, "
        "telephone TEXT, "
        "observations TEXT);"
    );
    batch.execute(
        "CREATE TABLE IF NOT EXISTS equipment ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "client_id INTEGER NOT NULL,"
            "name TEXT NOT NULL,"
            "problem TEXT NOT NULL,"
            "observation TEXT NOT NULL,"
            "images TEXT,"
            "dateInput TEXT NOT NULL,"
            "dateExit TEXT,"
            "isDelivered BOOLEAN NOT NULL); "
    );
    batch.execute("CREATE TABLE IF NOT EXISTS repair("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "eq_id INTEGER NOT NULL,"
        "repair TEXT NOT NULL);"
    );
    batch.execute(
      "CREATE VIEW v_repair "
          "AS SELECT r.id as repair_id, "
          "eq.id as id, "
          "eq.name as name,"
          "r.repair as repair "
          "FROM repair r INNER JOIN equipment eq "
          "WHERE eq.id = r.eq_id"
    );
    batch.execute("CREATE VIEW v_equipment "
        "AS SELECT cli.id as client_id, "
                    "cli.name as name, "
                    "eq.id as id, "
                    "eq.name as equipment, "
                    "eq.problem as problem, "
                    "eq.observation as observation, "
                    "eq.images as images, "
                    "eq.dateInput as dateInput, "
                    "eq.dateExit as dateExit, "
                    "eq.isDelivered as isDelivered "
        "FROM client cli INNER JOIN equipment eq "
        "WHERE cli.id = eq.client_id");
    List<dynamic> res = await batch.commit();
  }

  Future<int> insert(Map<String,dynamic> row, String table) async
  {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String,dynamic>>> queryAllRows(String table) async{
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String,dynamic>>> queryOrdered(String table, String order, String val) async{
    Database db = await instance.database;
    return await db.query(table, orderBy: val+' '+order);
  }

  Future<List<Map<String,dynamic>>> queryAllEquipment() async{
    Database db = await instance.database;
    return await db.query("v_equipment", orderBy: 'equipment ASC', where: 'isDelivered = 0');
  }

  Future<List<Map<String,dynamic>>> queryAllEquipmentDelivered() async{
    Database db = await instance.database;
    return await db.query("v_equipment", orderBy: 'equipment ASC', where: 'isDelivered = 1');
  }

  Future<List<Map<String,dynamic>>> queryRepair(String name) async{
    Database db = await instance.database;
    return await db.query("v_repair", where: 'name LIKE ?', whereArgs: ['%$name%'], orderBy: 'name ASC');
  }

  Future<List<Map<String,dynamic>>> queryEquipment(String equipment) async{
    Database db = await instance.database;
    return await db.query("v_equipment", where: 'equipment LIKE ?', whereArgs: ['%$equipment%'], orderBy: 'equipment ASC');
  }

  Future<List<Map<String,dynamic>>> queryClient(String name) async{
    Database db = await instance.database;
    return await db.query("client", where: 'name LIKE ?', whereArgs: ['%$name%'], orderBy: 'name ASC');
  }

  Future<List<Map<String,dynamic>>> queryEquipmentClient(int client_id) async{
    Database db = await instance.database;
    return await db.query("v_equipment", where: 'client_id = ?', whereArgs: [client_id]);
  }

  Future<List<Map<String,dynamic>>> queryByID(String table, int id) async {
    Database db = await instance.database;
    return await db.query(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String,dynamic>>> queryByName(String table, String name) async {
    Database db = await instance.database;
    return await db.query(table, where: 'name LIKE ?', whereArgs: ['%$name%']);
  }

  Future<int> update(Map<String,dynamic> row, int id, String table) async{
    Database db = await instance.database;
    return await db.update(table,row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id, String table) async{
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}