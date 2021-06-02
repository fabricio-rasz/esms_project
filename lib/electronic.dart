// Objetivo: Classe p/ guardar eletrônicos
// Nome
// Cliente (outra classe)
// Descrição do problema
// Observações
// Data da Entrada
// Data da Saída
// Foto(s) do aparelho
import 'dbhandler.dart';

class Repair{
  int id;
  final int eq_id;
  final repair;
  Repair(this.eq_id,this.repair);

  final dbHandler dbh = dbHandler.instance;

  Map<String,dynamic> toJson() =>{
    'eq_id': eq_id,
    'repair': repair
  };

  Repair.fromJson(Map<String, dynamic> jsona)
  :
      eq_id = jsona['eq_id'],
      repair = jsona['repair'];

  int SaveToDB() {
    Future<int> t = dbh.insert(this.toJson(), "repair");
    t.then((int value) {
      this.id = value;
      return 0;
    }, onError: (value) {
      return 1;
    });
  }

  Future<Repair> LoadFromDB(int num) async {
    dbh.queryByID("repair", num).then((List<Map<String, dynamic>> value){
      return Repair.fromJson(value[0]);
    }
    );
  }

  Future UpdateDB(int num) async {
    return await dbh.update(this.toJson(), num, "repair");
  }

  Future RemoveDB(int num) async {
    return await dbh.delete(num, "repair");
  }
}

class Equipment {
  int id;
  final int client_id;
  final String name, problem, observation;
  final DateTime dateInput;
  DateTime dateExit;
  List<String> images = [];
  int isDelivered = 0;
  Equipment(this.client_id, this.name, this.problem, this.observation,
      this.dateInput);

  final dbHandler dbh = dbHandler.instance;

  Map<String, dynamic> toJson() => {
        'client_id': client_id,
        'name': name,
        'problem': problem,
        'observation': observation,
        'dateInput': dateInput.toString(),
        'dateExit': dateExit.toString(),
        'images': images.toString(),
        'isDelivered': isDelivered
      };

  Equipment.fromJson(Map<String, dynamic> jsona)
      : id = jsona['id'],
        client_id = jsona['client_id'],
        name = jsona['name'],
        problem = jsona['problem'],
        observation = jsona['observation'],
        dateInput = DateTime.tryParse(jsona['dateInput']),
        dateExit = DateTime.tryParse(jsona['dateExit']),
        images = jsona['images'].toString().substring(1,jsona['images'].length-1).split(',').toList(),
        isDelivered = int.tryParse(jsona['isDelivered'].toString());

  void AddImage(String image) {
    images.add(image);
  }

  void AddImageAsRange(List<String> imageL) {
    images.addAll(imageL);
  }

  void EquipmentLeave(DateTime time) {
    dateExit = time;
    isDelivered = 1;
  }

  int SaveToDB() {
    Future<int> t = dbh.insert(this.toJson(), "equipment");
    t.then((int value) {
      this.id = value;
      return 0;
    }, onError: (value) {
      return 1;
    });
  }

  Future<Equipment> LoadFromDB(int num) async {
    dbh.queryByID("equipment", num).then((List<Map<String, dynamic>> value){
       return Equipment.fromJson(value[0]);
    }
    );
  }

  Future UpdateDB(int num) async {
    return await dbh.update(this.toJson(), num, "equipment");
  }

  Future RemoveDB(int num) async {
    return await dbh.delete(num, "equipment");
  }
}
