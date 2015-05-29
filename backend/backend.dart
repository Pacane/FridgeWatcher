import 'dart:async';
import 'package:redstone/redstone.dart' as app;
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:redstone_mapper_mongo/service.dart';
import 'package:logging/logging.dart';
import 'package:fridge_watcher_shared/fridge_item.dart';
import 'package:fridge_watcher_backend/interceptors.dart';
import 'package:di/di.dart';

Logger logger = Logger.root;

main() {
  var dbManager = new MongoDbManager(
      "mongodb://pacane:dbpassword!@ds031902.mongolab.com:31902/fridge_watcher",
      poolSize: 1);

  app.addPlugin(getMapperPlugin(dbManager));
  app.setupConsoleLog(Level.INFO);
  app.addModule(new Module()..bind(Interceptors));
  app.start(port: 8082);
}

MongoDb get mongoDb => app.request.attributes.dbConn;
MongoDbService<FridgeItem> itemService = new MongoDbService<FridgeItem>('items');
@app.Route("/api/items")
@Encode()
listItems() {
  return itemService.find();
}

@app.Route("/api/items", methods: const [app.POST], responseType: 'application/json')
Future<shelf.Response> addItem(@Decode() FridgeItem item) async {
  if (item.addedOn == null) {
    item.addedOn = new DateTime.now();
  }

  if (item.expiresOn == null) {
    item.expiresOn = new DateTime.now().add(new Duration(days: 14));
  }

  await itemService.insert(item);

  logger.info("Added item");

  return new shelf.Response.ok("");
}

