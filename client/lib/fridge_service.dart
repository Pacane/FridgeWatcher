library fridge_watcher.fridge_service;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http/browser_client.dart';
import 'package:fridge_watcher_shared/fridge_item.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'dart:convert';

class FridgeService {
  http.Client client = new BrowserClient();
  Future<Iterable<FridgeItem>> getItems() async {
    bootstrapMapper();

    http.Response response =
        await client.get('http://localhost:8082/api/items');

    var decodedItems = JSON.decode(response.body);
    return decodedItems.map((Map m) => decode(m, FridgeItem));
  }
}
