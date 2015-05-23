// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library fridge_watcher.models;

import 'package:polymer/polymer.dart';

final appModel = new Watcher();

/**
 * A model for the tracker app.
 *
 * [tasks] contains all tasks used in this app.
 */
class Watcher extends Observable {
  @observable List<FridgeItem> tasks;
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
class FridgeItem extends Observable {
  @observable int itemID;
  @observable String name = '';
  @observable DateTime addedOn;
  @observable DateTime expiresOn;

  FridgeItem.unsaved();

  FridgeItem(this.name, {this.addedOn: null, this.expiresOn: null}) {
    if (addedOn == null) {
      this.addedOn = new DateTime.now();
    }

    if (expiresOn == null) {
      this.expiresOn = this.addedOn.add(new Duration(days: 14));
    }
  }

  bool get isExpired => new DateTime.now().isAfter(expiresOn);
  bool get saved => itemID != null;
}