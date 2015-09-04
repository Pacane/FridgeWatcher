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
import 'package:fridge_watcher/event_bus.dart' as fwEventBus;
import 'package:event_bus/event_bus.dart';
import 'package:fridge_watcher/events.dart';

@Injectable()
class FridgeService {
  AppConfig appConfig;
  EventBus eventBus = fwEventBus.eventBus;

  FridgeService(this.appConfig);

  http.Client client = new BrowserClient();

  Future<Iterable<FridgeItem>> getItems() async {
    var onError = () {
      var message = "Couldn't fetch items.";
      eventBus.fire(new CannotPerformActionEvent(message));
      throw new Exception(message);
    };

    bootstrapMapper();

    http.Response response = await client
        .get('${appConfig.apiBaseUrl}/items')
        .catchError((_) => onError());

    var decodedItems = JSON.decode(response.body);
    return decodedItems.map((Map m) => decode(m, FridgeItem));
  }

  Future<Iterable<FridgeItem>> getDoneItems() async {
    var onError = () {
      var message = "Couldn't fetch done items.";
      eventBus.fire(new CannotPerformActionEvent(message));
      throw new Exception(message);
    };

    bootstrapMapper();

    http.Response response = await client
        .get('${appConfig.apiBaseUrl}/items/done')
        .catchError((_) => onError());

    var decodedItems = JSON.decode(response.body);
    return decodedItems.map((Map m) => decode(m, FridgeItem));
  }

  Future deleteItem(String id) async {
    var onError = () {
      var message = "Couldn't delete the item.";
      eventBus.fire(new CannotPerformActionEvent(message));
      throw new Exception(message);
    };

    bootstrapMapper();

    http.Response response = await client
        .delete('${appConfig.apiBaseUrl}/items/$id')
        .catchError((_) => onError());

    if (response.statusCode != 200) {
      onError();
    }
  }

  Future<FridgeItem> addItem(FridgeItem fridgeItem) async {
    var onError = () {
      var message = "Couldn't add the item ${fridgeItem.name}.";
      eventBus.fire(new CannotPerformActionEvent(message));
      throw new Exception(message);
    };

    bootstrapMapper();

    fridgeItem.done = false;

    var encodedItem = encodeJson(fridgeItem);

    http.Response response = await client
        .post('${appConfig.apiBaseUrl}/items',
            headers: {'Content-type': 'application/json'}, body: encodedItem)
        .catchError((_) => onError());

    if (response.statusCode != 200) {
      onError();
    }

    FridgeItem result = decodeJson(response.body, FridgeItem);

    return result;
  }

  Future undeleteItem(String id) async {
    var onError = () {
      var message = "Couldn't restore the item.";
      eventBus.fire(new CannotPerformActionEvent(message));
      throw new Exception(message);
    };

    bootstrapMapper();

    http.Response response = await client
        .put('${appConfig.apiBaseUrl}/items/$id')
        .catchError((_) => onError());

    if (response.statusCode != 200) {
      onError();
    }
  }
}
