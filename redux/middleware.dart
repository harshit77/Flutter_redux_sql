import 'package:todolistreduxmiddleware/modal/modal.dart';
import 'package:todolistreduxmiddleware/redux/actions.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux/redux.dart';
import 'package:todolistreduxmiddleware/modal/database.dart';


Future<int> saveToDatabase(Item item) async {
TodoDatabase tb=  TodoDatabase();
int res= await tb.toDoItemAdd(item);
print("Calling toDoItemAdd ${item.favorite}");
  return res;
}

void savedToPref(AppState state) async {
SharedPreferences preferences= await SharedPreferences.getInstance();
var string=json.encode(state.toJson());
print(string);
await preferences.setString('itemState', string);
}


Future<AppState> loadDataFromDatabase() async {
TodoDatabase tb=TodoDatabase();
List<Map> list= await tb.getAllTheRecordes();
//Map <String,dynamic>  map= new Map.fromIterable(list,key: (item)=>item.toString(), value: (item) =>item);
return AppState.fromextractedJson(list);
}
Future<AppState> loadPreference() async {
  SharedPreferences preferences=await SharedPreferences.getInstance();
var string=preferences.getString('itemState');
if(string != null) {
 Map map=json.decode(string);
 return AppState.fromJson(map);
}
return AppState.initialState(); 
}


void appStateMiddleWare(Store<AppState> store,action,NextDispatcher next) async{
  next(action);

if(action is AddItemAction) {
  print('MiddleWare');
  // savedToPref(store.state);
  saveToDatabase(Item(id: action.id, body: action.item, favorite: action.favorite));
}
if(action is RemoveItemAction) {
  print("action is RemoveItemAction");
}

if(action is GetItemAction ) {
  print("GetMiddleWARE");
 await loadDataFromDatabase().then((state)=>store.dispatch(LoadedItemAction(state.items)));
}
}

