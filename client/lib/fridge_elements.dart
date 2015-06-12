// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library fridge_watcher.fridge_elements;

import 'package:polymer/polymer.dart';
import 'package:fridge_watcher/models.dart';
import 'package:fridge_watcher/event_bus.dart';
import 'package:fridge_watcher/events.dart';
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
  @observable final ObservableList<FridgeItemViewModel> doneFridgeItems =
      toObservable([]);
  @observable Watcher app;

  FridgeService fridgeService;

  FridgeElements.created() : super.created() {
    appModel.fridgeItems = fridgeItems;
    appModel.doneFridgeItems = doneFridgeItems;
  }

  Future fetchFridgeItems() async {
    Iterable<FridgeItem> items = await fridgeService.getItems();

    Iterable viewModels =
        items.map((FridgeItem fi) => new FridgeItemViewModel(fi));

    sortFridgeItems(viewModels, fridgeItems);
  }

  void sortFridgeItems(Iterable<FridgeItemViewModel> newItems,
      ObservableList<FridgeItemViewModel> viewModel) {
    viewModel.clear();
    viewModel
      ..addAll(newItems)
      ..sort(sortByExpirationDate)
      ..reversed;
  }

  sortByExpirationDate(FridgeItemViewModel a, FridgeItemViewModel b) {
    if (a.expiresOn.isBefore(b.expiresOn)) return -1;
    else if (a.expiresOn.isAfter(b.expiresOn)) return 1;
    else return 0;
  }

  Future fetchDoneFridgeItems() async {
    Iterable<FridgeItem> items = await fridgeService.getDoneItems();

    Iterable viewModels =
        items.map((FridgeItem fi) => new FridgeItemViewModel(fi));

    sortFridgeItems(viewModels, doneFridgeItems);
  }

  void attached() {
    super.attached();

    eventBus
        .on(ItemDeletedEvent)
        .listen((ItemDeletedEvent event) => deleteItem(event.item));

    eventBus
        .on(ItemUndeletedEvent)
        .listen((ItemUndeletedEvent event) => undeleteItem(event.item));

    inject(this, [FridgeService]);
  }

  void deleteItem(FridgeItemViewModel item) {
    item.done = true;
    fridgeItems.remove(item);
    doneFridgeItems.add(item);
    sortItemsByExpirationDate(fridgeItems);
    sortItemsByExpirationDate(doneFridgeItems);
  }

  void undeleteItem(FridgeItemViewModel item) {
    item.done = false;
    fridgeItems.add(item);
    doneFridgeItems.remove(item);
    sortItemsByExpirationDate(fridgeItems);
    sortItemsByExpirationDate(doneFridgeItems);
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

    fridgeItems.add(new FridgeItemViewModel(addedItem));

    sortItemsByExpirationDate(fridgeItems);
  }

  Iterable<FridgeItemViewModel> sortItemsByExpirationDate(
      List<FridgeItemViewModel> items) {
    return items
      ..sort(sortByExpirationDate)
      ..reversed;
  }

  @override
  void initDiContext(Map<Type, dynamic> context) {
    fridgeService = context[FridgeService];

    fetchFridgeItems();
    fetchDoneFridgeItems();
  }
}
