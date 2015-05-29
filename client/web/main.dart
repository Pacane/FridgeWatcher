// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'package:polymer/polymer.dart';
import 'package:redstone_mapper/mapper_factory.dart';

import 'package:fridge_watcher/di.dart';
import 'package:fridge_watcher/module.dart';

main() {
  DiContext diContext = new DiContext();
  diContext.installModules([getModule()]);

  bootstrapMapper();
  initPolymer();
}

@initMethod init() {
  Polymer.onReady.then((_) {});
}
