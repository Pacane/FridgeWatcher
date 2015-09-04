library fridge_watcher.fridge_element;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_checkbox.dart';
import 'package:fridge_watcher/models.dart';
import 'package:intl/intl.dart';
import 'package:fridge_watcher/event_bus.dart';
import 'package:fridge_watcher/events.dart';
import 'package:fridge_watcher/di.dart';
import 'package:fridge_watcher/fridge_service.dart';
import 'dart:async';

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

  Future onCheckChanged() async {
    bool checked = ($['delete-item'] as PaperCheckbox).checked;
    if (checked) {
      await fridgeService.deleteItem(viewModel.id);
      eventBus.fire(new ItemDeletedEvent(viewModel));
    } else {
      await fridgeService.undeleteItem(viewModel.id);
      eventBus.fire(new ItemUndeletedEvent(viewModel));
    }
  }

  @override
  void initDiContext(Map<Type, dynamic> context) {
    fridgeService = context[FridgeService];

    if (viewModel.done) {
      ($['delete-item'] as PaperCheckbox).checked = true;
    }
  }
}
