import 'dbhandler.dart';

class Client{
  final String name,
      telephone,
      cellular,
      observations;
  int id, status;
  Client(this.name, this.telephone, this.cellular, this.observations);

  final dbHandler dbh = dbHandler.instance;

  Client.fromJson(Map<String,dynamic> jsona)
      :id= int.tryParse(jsona['id'].toString()),
        name = jsona['name'],
        cellular = jsona['cellular'],
        telephone = jsona['telephone'],
        observations = jsona['observations'];

  Map<String, dynamic> toJson() =>
      {
        'name':name,
        'cellular':cellular,
        'telephone':telephone,
        'observations':observations
      };

  void SaveToDB() async
  {
    Future<int> t = dbh.insert(this.toJson(),"client");
    t.then((int value){
      this.id = value;
      return value;
    });
  }

  Future<Client> LoadFromDB(int num) async{
    List<Map<String, dynamic>> eq = await dbh.queryByID("client", num);
    return Client.fromJson(eq[0]);
  }
  UpdateDB(int num)
  {
    dbh.update(this.toJson(), num, "client").then((value){
      status = value;
    },onError: (object){
      status = 0;
    });
  }
  Future RemoveDB(int num) async
  {
    return await dbh.delete(num, "client");
  }
}