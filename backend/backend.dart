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
import 'package:mongo_dart/mongo_dart.dart';
import 'package:dart_config/default_server.dart';

Logger logger = Logger.root;

main() async {
  Map config = await loadConfig();

  var dbManager = new MongoDbManager(config['connectionString'], poolSize: 1);

  app.addPlugin(getMapperPlugin(dbManager));
  app.setupConsoleLog(Level.FINE);
  app.addModule(new Module()..bind(Interceptors));
  app.start(port: config['apiPort']);
}

MongoDb get mongoDb => app.request.attributes.dbConn;

MongoDbService<FridgeItem> itemService =
    new MongoDbService<FridgeItem>('items');

@app.Route("/api/items")
@Encode()
listItems() {
  return itemService.find(where.eq('done', false));
}

@app.Route('/api/items/done')
@Encode()
listDoneItems() {
  return itemService.find(where.eq('done', true));
}

@app.Route("/api/items",
    methods: const [app.POST], responseType: 'application/json')
@Encode()
Future<FridgeItem> addItem(@Decode() FridgeItem item) async {
  if (item.addedOn == null) {
    item.addedOn = new DateTime.now();
  }

  if (item.expiresOn == null) {
    item.expiresOn = new DateTime.now().add(new Duration(days: 14));
  }

  item.id = new ObjectId().toHexString();

  await itemService.insert(item);

  return itemService.find(item).then((items) => items[0]);
}

@app.Route("/api/items/:id", methods: const [app.DELETE])
Future<shelf.Response> deleteItem(String id) async {
  ObjectId oid = new ObjectId.fromHexString(id);
  FridgeItem item = await itemService.findOne(where.id(oid));
  await itemService.update(where.id(oid), item..done = true);

  logger.info("Deleted item id: $id");

  return new shelf.Response.ok("");
}

@app.Route("/api/items/:id", methods: const [app.PUT])
Future<shelf.Response> undeleteItem(String id) async {
  ObjectId oid = new ObjectId.fromHexString(id);
  FridgeItem item = await itemService.findOne(where.id(oid));
  await itemService.update(where.id(oid), item..done = false);

  logger.info("Undeleted item id: $id");

  return new shelf.Response.ok("");
}
