library fridge_watcher.fridge_element;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_checkbox.dart';
import 'package:fridge_watcher/models.dart';
import 'package:intl/intl.dart';
import 'package:fridge_watcher/event_bus.dart';
import 'package:fridge_watcher/item_deleted_event.dart';
import 'package:fridge_watcher/di.dart';
import 'package:fridge_watcher/fridge_service.dart';

@CustomTag('fridge-element')
class FridgeElement extends LIElement with Polymer, Observable, DiConsumer {
  FridgeElement.created() : super.created() {
    polymerCreated();
  }

  void attached() {
    inject(this, [FridgeService]);
  }

  @observable FridgeItemViewModel viewModel;
  @observable DateFormat formatter = new DateFormat('dd-MM-yyyy');
  FridgeService fridgeService;

  void onCheckChanged() {
    bool checked = ($['delete-item'] as PaperCheckbox).checked;
    if (checked) {
      eventBus.fire(new ItemDeletedEvent(viewModel));
    }

    print(viewModel);
  }

  @override
  void initDiContext(Map<Type, dynamic> context) {
    fridgeService = context[FridgeService];
    print("Initialized Di context");
    print(fridgeService);
  }
}
