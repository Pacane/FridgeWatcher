import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';
import 'dart:convert';
import 'package:redstone/redstone.dart' as app;
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:redstone_mapper_mongo/service.dart';
import 'package:redstone_mapper_mongo/metadata.dart';
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
  app.setupConsoleLog(Level.FINER);
  app.addModule(new Module()..bind(Interceptors));
  app.start(port: 8082);
}

MongoDb get mongoDb => app.request.attributes.dbConn;
//DbCollection itemService = mongoDb.collection("items");
MongoDbService<FridgeItem> itemService = new MongoDbService<FridgeItem>('items');
@app.Route("/api/items")
@Encode()
listItems() {
  return itemService.find();
}

@app.Route("/api/items", methods: const [app.POST], responseType: 'application/json')
Future<shelf.Response> addItem(@Decode() FridgeItem item) async {
//  FridgeItem item = new FridgeItem.fromMap(json);
  await itemService.insert(item);

  logger.info("Added item");

  return new shelf.Response.ok("");
}

mongo() async {
  Db db = new Db(
      "mongodb://pacane:dbpassword!@ds031902.mongolab.com:31902/fridge_watcher");

  DbCollection items = db.collection('items');

  await db.open();

//  items.save({"item1": "banana"});
//  items.save({"item2": "apple"});

  var retrieved = items.find();

  retrieved.forEach((Map item) => print(item));
}
