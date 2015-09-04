// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library tracker.watcher_app;

import 'package:polymer/polymer.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fridge_watcher/event_bus.dart' as fwEventBus;
import 'package:fridge_watcher/events.dart';
import 'package:paper_elements/paper_toast.dart';

@CustomTag('watcher-app')
class WatcherApp extends PolymerElement {
  EventBus eventBus = fwEventBus.eventBus;
  PaperToast messageToast;

  WatcherApp.created() : super.created() {}

  void attached() {
    messageToast = shadowRoot.querySelector("#messageToast");

    eventBus
        .on(CannotPerformActionEvent)
        .listen((CannotPerformActionEvent event) {
      messageToast.text = event.message;
      messageToast.show();
    });
  }
}
