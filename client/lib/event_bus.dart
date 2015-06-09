library fridge_watcher.event_bus;

import 'package:event_bus/event_bus.dart';

EventBus get eventBus {
  if (_eventBus == null) {
    _eventBus = new EventBus();
  }

  return _eventBus;
}

EventBus _eventBus;
