library fridge_watcher.fridge_service;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http/browser_client.dart';
import 'package:fridge_watcher_shared/fridge_item.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'dart:convert';
import 'package:di/di.dart';
import 'package:fridge_watcher/app_config.dart';

@Injectable()
class FridgeService {
  AppConfig appConfig;

  FridgeService(this.appConfig);

  http.Client client = new BrowserClient();
  Future<Iterable<FridgeItem>> getItems() async {
    bootstrapMapper();

    http.Response response =
        await client.get('${appConfig.apiBaseUrl}/items');

    var decodedItems = JSON.decode(response.body);
    return decodedItems.map((Map m) => decode(m, FridgeItem));
  }

  Future deleteItem(String id) async {
    bootstrapMapper();

    http.Response response =
        await client.delete('${appConfig.apiBaseUrl}/items/$id');

    if (response.statusCode != 200) {
      throw new Exception("Couldn't delete item with id : $id");
    }
  }

  Future<FridgeItem> addItem(FridgeItem fridgeItem) async {
    bootstrapMapper();

    var bob = encodeJson(fridgeItem);

    http.Response response = await client.post(
        '${appConfig.apiBaseUrl}/items',
        headers: {'Content-type': 'application/json'}, body: bob);

    if (response.statusCode != 200) {
      throw new Exception("Couldn't add item : ${fridgeItem.name}");
    }

    FridgeItem result = decodeJson(response.body, FridgeItem);

    return result;
  }
}
