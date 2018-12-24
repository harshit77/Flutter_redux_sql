import 'package:todolistreduxmiddleware/modal/modal.dart';
import 'package:todolistreduxmiddleware/redux/actions.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(items: itemReducer(state.items, action));
}
List<Item> itemReducer (List<Item> state,action) {
  if(action is AddItemAction) {
    print(action.favorite);
    return []..addAll(state)..add(Item(id: action.id, body: action.item,favorite:action.favorite));
  }
  if(action is GetItemAction) {
    print("cdscdscs");
    return List.unmodifiable([]);
  }
  if(action is FavoriteAction) {
    state.forEach((Item item){
      if(item.id==action.id) {
        item.favorite=item.favorite==true ? false :true;
      }
    });

  return []..addAll(state);
  }
  if (action  is RemoveItemAction)
  { 
    return  []..addAll(state)..removeWhere((state)=>action.item== state.body);
  }
  if(action is LoadedItemAction) {
    return action.item;
  }
  return state;
}