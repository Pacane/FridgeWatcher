// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library fridge_watcher.fridge_elements;

import 'package:polymer/polymer.dart';
import 'package:fridge_watcher/models.dart';
import 'package:fridge_watcher/event_bus.dart';
import 'package:fridge_watcher/item_deleted_event.dart';
import 'package:core_elements/core_input.dart';
import 'package:intl/intl.dart';
import 'dart:html';
import 'package:fridge_watcher_shared/fridge_item.dart';
import 'dart:async';
import 'package:fridge_watcher/fridge_service.dart';
import 'package:fridge_watcher/di.dart';

@CustomTag('fridge-elements')
class FridgeElements extends PolymerElement with DiConsumer {
  @observable final ObservableList<FridgeItemViewModel> fridgeItems =
      toObservable([]);
  @observable Watcher app;

  FridgeService fridgeService;

  FridgeElements.created() : super.created() {
    appModel.tasks = fridgeItems;
  }

  Future fetchFridgeItems() async {
    Iterable<FridgeItem> items = await fridgeService.getItems();

    Iterable viewModels = items.map((FridgeItem fi) {
      return new FridgeItemViewModel(fi.name,
          addedOn: fi.addedOn, expiresOn: fi.expiresOn, id: fi.id);
    });

    fridgeItems.clear();
    fridgeItems
      ..addAll(viewModels)
      ..sort((FridgeItemViewModel a, FridgeItemViewModel b) {
        if (a.expiresOn.isBefore(b.expiresOn)) return -1;
        else if (a.expiresOn.isAfter(b.expiresOn)) return 1;
        else return 0;
      })
      ..reversed;
  }

  void attached() {
    super.attached();

    eventBus
        .on(ItemDeletedEvent)
        .listen((ItemDeletedEvent event) => deleteItem(event.item));

    inject(this, [FridgeService]);
  }

  void deleteItem(FridgeItemViewModel item) {
    fridgeItems.remove(item);
  }

  Future addItem() async {
    String itemName = ($['item-name'] as CoreInput).value;
    String expirationDateString = ($['expiration-date'] as InputElement).value;
    DateTime expirationDate = null;

    if (expirationDateString != "") {
      var formatter = new DateFormat('yyyy-MM-dd');

      expirationDate = formatter.parse(expirationDateString);
    }

    FridgeItem addedItem = await fridgeService.addItem(new FridgeItem()
      ..name = itemName
      ..expiresOn = expirationDate);

    fridgeItems
        .add(new FridgeItemViewModel(itemName, expiresOn: expirationDate));

    sortItemsByExpirationDate(fridgeItems);
  }

  Iterable<FridgeItemViewModel> sortItemsByExpirationDate(
      List<FridgeItemViewModel> items) {
    return items
      ..sort((FridgeItemViewModel a, FridgeItemViewModel b) {
        if (a.expiresOn.isBefore(b.expiresOn)) return -1;
        else if (a.expiresOn.isAfter(b.expiresOn)) return 1;
        else return 0;
      })
      ..reversed;
  }

  @override
  void initDiContext(Map<Type, dynamic> context) {
    fridgeService = context[FridgeService];

    fetchFridgeItems();
  }
}
