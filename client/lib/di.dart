library fridge_watcher.di;

import 'package:di/di.dart';
import 'package:fridge_watcher/event_bus.dart';

class DiContext {
  DiContext() {
    eventBus.on(DiRequestEvent).listen((DiRequestEvent event) {
      Map<Type, dynamic> resolvedBindings = {};
      event.types
          .forEach((Type type) => resolvedBindings[type] = injector.get(type));

      event.host.initDiContext(resolvedBindings);
    });
  }

  Injector injector;

  void installModules(List<Module> modules) {
    injector = new ModuleInjector(modules);
  }
}

abstract class DiConsumer {
  void inject(DiConsumer host, [List<Type> types]) {
    eventBus.fire(new DiRequestEvent(host, types));
  }

  void initDiContext(Map<Type, dynamic> context);
}

class DiRequestEvent {
  DiConsumer host;
  List<Type> types;

  DiRequestEvent(this.host, this.types);
}
