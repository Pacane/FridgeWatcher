// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library fridge_wacter.seed;

import 'models.dart';

List<FridgeItem> data = [
  new FridgeItem('Lait'),
  new FridgeItem('Oeufs',
      expiresOn: new DateTime.now().add(new Duration(days: 21))),
  new FridgeItem('Crème sure',
      expiresOn: new DateTime.now().add(new Duration(days: 21))),
  new FridgeItem('Jus',
      expiresOn: new DateTime.now().add(new Duration(days: 14))),
  new FridgeItem('Sauce Soya',
      expiresOn: new DateTime.now().add(new Duration(days: 365))),
  new FridgeItem('Brocolli',
      addedOn: new DateTime.now().subtract(new Duration(days: 21)),
      expiresOn: new DateTime.now().subtract(new Duration(days: 5))),
];
