import 'package:todolistreduxmiddleware/modal/modal.dart';


class AddItemAction  {
static int _id=0;
final String item;
bool favorite=false;
AddItemAction(this.item) {
_id++;
}
int get id=>_id;
}
class RemoveItemAction {
  final String item;
  RemoveItemAction (this.item);
}
class FavoriteAction {
  int id;
 FavoriteAction(this.id);
}

class RemoveItemsAction {

}
class GetItemAction {
}
class LoadedItemAction{
  final List<Item> item;
  LoadedItemAction(this.item);
}