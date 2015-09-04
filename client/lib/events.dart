library fridge_watcher.events;

import 'package:fridge_watcher/models.dart';

class ItemDeletedEvent {
  FridgeItemViewModel item;

  ItemDeletedEvent(this.item);
}

class ItemUndeletedEvent {
  FridgeItemViewModel item;

  ItemUndeletedEvent(this.item);
}

class CannotPerformActionEvent {
  String message;

  CannotPerformActionEvent(this.message);
}
