class Item {
 final int id;
 final String body;
 bool favorite;
 Item({this.id,this.body,this.favorite});
 Item.fromJson(Map json)
 :id=json['id'],
  body=json['body'];


 Map toJson() => {
   'id': id,
   'body': body,
   'favorite':favorite
 }; 

Map<String,dynamic> toMap() {
var map= new Map<String,dynamic>();
map['id']=id;
map['body']=body;
map['favorite']=favorite;
return map;
} 
}


class AppState {
   List<Item> items;
  AppState({this.items});



AppState.fromJson(Map json)
: items=(json['item'] as List).map((i) =>Item.fromJson(i)).toList();

  Map toJson() => {'items':items};
  AppState.initialState() : items=List.unmodifiable([]);

AppState.fromextractedJson(List recivedList):items=recivedList.map((i)=>Item.fromJson(i)).toList() {
  print("RecievedList : ${items}");
}


//Not
//   Map<String,dynamic> toMap() {
// var map= new Map<String,dynamic>();
// map['items']=items;
// return map;
// } 
}