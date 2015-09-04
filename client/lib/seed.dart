// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library fridge_watcher.seed;

import 'models.dart';
import 'package:fridge_watcher_shared/fridge_item.dart';

List<FridgeItemViewModel> data = [
  new FridgeItemViewModel(new FridgeItem()
    ..id = "12389120"
    ..name = 'Lait'),
  new FridgeItemViewModel(new FridgeItem()
    ..id = "859034859"
    ..name = 'Oeufs'
    ..expiresOn = new DateTime.now().add(new Duration(days: 21))),
  new FridgeItemViewModel(new FridgeItem()
    ..id = "482930"
    ..name = "Crème sure"
    ..expiresOn = new DateTime.now().add(new Duration(days: 21))),
  new FridgeItemViewModel(new FridgeItem()
    ..id = "45902-592-0"
    ..name = "Jus"
    ..expiresOn = new DateTime.now().add(new Duration(days: 14))),
  new FridgeItemViewModel(new FridgeItem()
    ..id = "3509 8093"
    ..name = 'Sauce Soya'
    ..expiresOn = new DateTime.now().add(new Duration(days: 365))),
  new FridgeItemViewModel(new FridgeItem()
    ..id = "38904582309"
    ..name = "Brocolli"
    ..addedOn = new DateTime.now().subtract(new Duration(days: 21))
    ..expiresOn = new DateTime.now().subtract(new Duration(days: 5)))
];
