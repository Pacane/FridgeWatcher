// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library tracker.web.tracker_app;

import 'package:polymer/polymer.dart';
import 'package:fridge_watcher/models.dart';
import 'package:fridge_watcher/seed.dart' as seed;
import 'package:fridge_watcher/event_bus.dart';
import 'package:fridge_watcher/item_deleted_event.dart';
import 'package:core_elements/core_input.dart';
import 'package:intl/intl.dart';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';
import 'package:fridge_watcher_shared/fridge_item.dart';
import 'dart:async';

@CustomTag('fridge-elements')
class FridgeElements extends PolymerElement {
  @observable final ObservableList<FridgeItemViewModel> tasks = toObservable([]);
  @observable Watcher app;

  FridgeElements.created() : super.created() {
    appModel.tasks = tasks;

    _addSeedData();
  }

  Future fetchFridgeItems() async {
    FridgeItemsService fridgeItemsService = new FridgeItemService();
  }

  void attached() {
    eventBus.on(ItemDeletedEvent).listen((ItemDeletedEvent event) => deleteItem(event.item));

    fetchFridgeItems();
  }

  void deleteItem(FridgeItemViewModel item) {
    tasks.remove(item);
  }

  _addSeedData() {
    tasks.addAll(sortItemsByExpirationDate(seed.data));
  }

  void addItem() {
    String itemName = ($['item-name'] as CoreInput).value;
    String expirationDateString = ($['expiration-date'] as InputElement).value;

    var formatter = new DateFormat('yyyy-MM-dd');

    DateTime expirationDate = formatter.parse(expirationDateString);

    tasks.add(new FridgeItemViewModel(itemName, expiresOn: expirationDate));

    sortItemsByExpirationDate(tasks);
  }

  Iterable<FridgeItemViewModel> sortItemsByExpirationDate(List<FridgeItemViewModel> items) {
    return items
      ..sort((FridgeItemViewModel a, FridgeItemViewModel b) {
        if (a.expiresOn.isBefore(b.expiresOn)) return -1;
        else if (a.expiresOn.isAfter(b.expiresOn)) return 1;
        else return 0;
      })
      ..reversed;
  }
}