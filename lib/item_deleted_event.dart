import 'package:fridge_watcher/models.dart';

class ItemDeletedEvent {
  FridgeItem item;

  ItemDeletedEvent(this.item);
}
