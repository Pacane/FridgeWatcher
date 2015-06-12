// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library fridge_watcher.models;

import 'package:polymer/polymer.dart';
import 'package:fridge_watcher_shared/fridge_item.dart';

final appModel = new Watcher();

/**
 * A model for the tracker app.
 *
 * [tasks] contains all tasks used in this app.
 */
class Watcher extends Observable {
  @observable List<FridgeItemViewModel> items;
  @observable List<FridgeItemViewModel> doneFridgeItems;
}

/**
 * A model for creating a single task.
 *
 * A task can be saved or unsaved. Only a saved task has a taskID.
 *
 * This model defines validation rules for a Task. It is the responsibility of
 * the view layer to validate a task before assigning a taskID to the task. A
 * task with a taskID is considered saved.
 */
class FridgeItemViewModel extends Observable {
  @observable String id;
  @observable String name = '';
  @observable DateTime addedOn;
  @observable DateTime expiresOn;
  @observable bool done;

  FridgeItemViewModel.unsaved();

  FridgeItemViewModel(FridgeItem fridgeItem) {
    id = fridgeItem.id;
    name = fridgeItem.name;
    addedOn = fridgeItem.addedOn;
    expiresOn = fridgeItem.expiresOn;
    done = fridgeItem.done;
  }

  bool get isExpired => new DateTime.now().isAfter(expiresOn);
  bool get saved => id != null;

  String toString() {
    return "$name : $addedOn : $expiresOn";
  }
}
