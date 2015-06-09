// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library fridge_watcher;

import 'package:polymer/polymer.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'package:fridge_watcher/di.dart';
import 'package:fridge_watcher/module.dart';
import 'package:dart_config/default_browser.dart';
import 'package:fridge_watcher/app_config.dart';

main() async {
  Map config = await loadConfig();

  AppConfig appConfig = new AppConfig()..apiBaseUrl = config['apiBaseUrl'];

  DiContext diContext = new DiContext();
  diContext.installModules([getModule()..bind(AppConfig, toValue: appConfig)]);

  bootstrapMapper();
  initPolymer();
}

@initMethod init() {
  Polymer.onReady.then((_) {});
}
