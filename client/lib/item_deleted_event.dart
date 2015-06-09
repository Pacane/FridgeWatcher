library fridge_watcher.events;

import 'package:fridge_watcher/models.dart';

class ItemDeletedEvent {
  FridgeItemViewModel item;

  ItemDeletedEvent(this.item);
}
