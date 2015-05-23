import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_checkbox.dart';
import 'package:fridge_watcher/models.dart';
import 'package:intl/intl.dart';
import 'package:fridge_watcher/event_bus.dart';
import 'package:fridge_watcher/item_deleted_event.dart';

@CustomTag('fridge-element')
class FridgeElement extends LIElement with Polymer, Observable {
  FridgeElement.created() : super.created() {
    polymerCreated();
  }

  @observable String name = "bobby";
  @observable FridgeItem item;
  @observable DateFormat formatter = new DateFormat('dd-MM-yyyy');

  void onCheckChanged() {
    bool checked = ($['delete-item'] as PaperCheckbox).checked;
    if (checked) {
      eventBus.fire(new ItemDeletedEvent(item));
    }
  }
}
