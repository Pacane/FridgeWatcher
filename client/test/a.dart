@TestOn("content-shell")

import 'package:fridge_watcher_shared/fridge_item.dart';
import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'package:redstone_mapper/mapper.dart';

import "package:test/test.dart";
import 'dart:convert';

void main() {
  test('test getItems with http', () async {
    bootstrapMapper();

    http.Client client = new BrowserClient();
    http.Response response = await client.get('http://localhost:8082/api/items');
    print("Body: " + response.body);
    var decodedItems = JSON.decode(response.body);
    print("decoded : $decodedItems");
    var b = decodedItems.map((Map m) => decode(m, FridgeItem));
    print(b.toList()[0].name);
  });
}

