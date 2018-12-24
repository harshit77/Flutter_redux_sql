import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todolistreduxmiddleware/modal/modal.dart';
import 'package:todolistreduxmiddleware/redux/actions.dart';
import 'package:todolistreduxmiddleware/redux/reducer.dart';
import 'package:todolistreduxmiddleware/redux/middleware.dart';
import 'package:todolistreduxmiddleware/modal/database.dart';
//This App is a todo App Where we are using shared Preference API with Redux 
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final Store<AppState> store= Store<AppState>(
     appStateReducer,
      initialState: AppState.initialState(),
       middleware: [appStateMiddleWare]
  );
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: new MaterialApp(
        title: 'To do List App Using Redux MiddleWare',
          home: StoreBuilder<AppState>( 
             onInit: (store) =>store.dispatch(GetItemAction()),
            builder: (BuildContext context, Store<AppState> store) {
               return HomePage(store);
          }
          )
      ),
    );
  }
}
class HomePage extends StatefulWidget {  
    final Store<AppState> _store;
  HomePage(this._store);
  @override
  _HomePageState createState() => _HomePageState(_store);
}

class _HomePageState extends State<HomePage> {
  TodoDatabase tb;
 @override
 void initState() {
   super.initState();
   print('Initial State');
  tb=TodoDatabase();
  //tb.dbDelete();
  tb.initDb();
 }
 @override 
 void dispose() {
   super.dispose();
  tb.dbClose();
 }
  final Store<AppState> _store;
  _HomePageState(this._store);
  @override
  Widget build(BuildContext context) {
    return new SafeArea(
          child: new Scaffold(
              bottomNavigationBar: BottomAppBar(
                 clipBehavior: Clip.antiAlias,
                 notchMargin:4.0,
                 shape: CircularNotchedRectangle(),
                  color: Colors.white,
                  child: new Container(
                      color: Colors.teal,
                    padding: const EdgeInsets.all(20.0),
                    child: new Text(""),
                  ),
  ),
   floatingActionButtonLocation:    FloatingActionButtonLocation.centerDocked,
  floatingActionButton: FloatingActionButton( 
     child: new IconButton(
       icon: new Icon(Icons.add, color: Colors.white,),
        onPressed: (){},
     ),
      backgroundColor: Colors.amber,
       shape:const CircleBorder(),
    onPressed: null
    ),
         appBar:new AppBar(
            title:  new Text('To do List Redux MiddleWare'),
           ),
          drawer: new Drawer(
             child: ListView(
                children: <Widget>[
                  ListTile(title: new Text('Favorite'), 
                  onTap: () {
                    Navigator.of(context).pop();
                     Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new NewPage(_store);
                          }));
                  })
                ],
             ),
          ),
          body: new Column(
             children: <Widget>[
              AddItemWidget(_store),
              Expanded(child: ItemWidget(_store)),
             ],
          ),
      ),
    );
  }
}
class ItemWidget extends StatelessWidget {
   final Store<AppState> _store;
  ItemWidget(this._store);
  @override
  Widget build(BuildContext context) {
    return new Container(
       child: ListView(
          
          children: _store.state.items.map(
            (Item item)=>new ListTile(
               title: new Text(item.body),
               leading: new IconButton(
                  icon: new Icon(item.favorite==true ?  Icons.favorite : Icons.favorite_border),
                   color: item.favorite==true ? Colors.red: null,
                   onPressed: (){
                    _store.dispatch(FavoriteAction(item.id));
                   },
               ),
               trailing: new IconButton(
                  icon: new Icon(Icons.delete),
                   onPressed: (){
                     _store.dispatch(RemoveItemAction(item.body));
                   },
               ),
          )).toList() ,
          
       )
    );
  }
}
class AddItemWidget extends StatelessWidget {
  final Store<AppState> _store;
  AddItemWidget(this._store);
  final TextEditingController controller= new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new TextField(
       autofocus: true,
        controller: controller,
         decoration: new InputDecoration(
            hintText: 'Enter Your Todo Here',
         ),
          onSubmitted:  (String text) {
            print(text);
          _store.dispatch(AddItemAction(text));
          },
    );
  }
}

class NewPage extends StatelessWidget {
  final Store<AppState> _store;
  bool notNull(Object o) => o != null;
  NewPage(this._store);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
       child:  new Scaffold(
          appBar: new AppBar(
            title: new Text('New Page')
          ),
          body: new Container(
            child: new ListView(
               children:_store.state.items.map((Item item) {
                 return item.favorite==true ? new ListTile(
                     title:  new Text(item.body),
                    ):  null; 
               }).where(notNull).toList()
            )
          )
       ),
    );
  }
}