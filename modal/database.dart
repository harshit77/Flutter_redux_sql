import 'package:todolistreduxmiddleware/modal/modal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';



class TodoDatabase {

  static Database _db;
  static final TodoDatabase _instance=new TodoDatabase._internal();
   factory TodoDatabase() => _instance;

Future<Database> get db async {
 if(_db!=null){
 return _db;
 }
 _db= await initDb();
 return _db;
}

Future<Database> initDb() async{
 var documentDirectory= await getApplicationDocumentsDirectory();
 String path=join(documentDirectory.path,"main.db");
 var thedb=openDatabase(path,version: 1,onCreate: _onCreate);
 return thedb;
}

void _onCreate(Database db, int version) async {
await db.execute('CREATE TABLE Todo(id STRING PRIMARY KEY,body TEXT,favorite BIT)');
print("Database is UP");
}


Future<int> toDoItemAdd(Item item) async{
 var dbclient=await db;
int res= await dbclient.insert("Todo", item.toMap());
print("Database Updated ${item.favorite}");
return res;
}
Future<List> getAllTheRecordes() async {
  var dbClient=await db;
 List<Map> list=await dbClient.rawQuery("SELECT * FROM Todo");
 print("Calling All the Recordes ${list}");
 return list;
}
Future dbClose() async{
  var dbClient=await db;
  dbClient.close();
}

Future<int> dbDelete() async {
  var dbClient= await db;
  var res =await dbClient.delete("Todo");
  print("Deleting Database");
  return res;
}

 
 
  TodoDatabase._internal();

}