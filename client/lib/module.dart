library fridge_watcher.di_module;

import 'package:di/di.dart';
import 'package:fridge_watcher/fridge_service.dart';

Module getModule() {
  return new Module()..bind(FridgeService);
}
