library fridge_watcher.di;

import 'package:di/di.dart';
import 'package:fridge_watcher/event_bus.dart';

class DiContext {
  DiContext() {
    print("Registered di request listener");
    eventBus.on(DiRequestEvent).listen((DiRequestEvent event) {
      print("handling di request");
      Map<Type, dynamic> resolvedBindings = {};
      event.types
          .forEach((Type type) => resolvedBindings[type] = _injector.get(type));

      event.host.initDiContext(resolvedBindings);
    });
  }

  Injector _injector;

  Injector get injector => _injector;

  void installModules(List<Module> modules) {
    _injector = new ModuleInjector(modules);
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

  DiRequestEvent(this.host, this.types) {
    print("Di requested");
  }
}
