import 'package:mongo_dart/mongo_dart.dart';
import 'package:dart_config/default_server.dart';
import 'dart:async';
import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

void setupConsoleLog([Level level = Level.INFO]) {
  Logger.root.level = level;
  Logger.root.onRecord.listen((LogRecord rec) {
    if (rec.level >= Level.SEVERE) {
      var stack =
          rec.stackTrace != null ? "\n${Trace.format(rec.stackTrace)}" : "";
      print(
          '${rec.level.name}: ${rec.time}: ${rec.message} - ${rec.error}${stack}');
    } else {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    }
  });
}

Logger logger = Logger.root;

Db db;
DbCollection itemsCollection;

enum MigrationDirection { UP, DOWN }

MigrationDirection directionFromString(String value) {
  if (value.toLowerCase() == 'up') {
    return MigrationDirection.UP;
  } else {
    return MigrationDirection.DOWN;
  }
}

MigrationDirection migrationDirection;

List<Future> migrations = [addField_done_allItems];

main(List<String> arguments) async {
  setupConsoleLog();

  new ArgParser()
    ..addOption('direction',
        abbr: 'd',
        help: 'select direction -- options: up/down',
        callback: (String direction) =>
            migrationDirection = directionFromString(direction))
    ..parse(arguments);

  Map config = await loadConfig();

  db = new Db(config['connectionString']);
  await db.open();

  itemsCollection = db.collection("items");

  for (var function in migrations) {
    await function();
  }

  await db.close();
}

Future addField_done_allItems() async {
  logger.info("Running addField_done_allItems: $migrationDirection");
  if (migrationDirection == MigrationDirection.UP) {
    await itemsCollection.update({}, modify.set('done', false),
        multiUpdate: true);
  } else {
    await itemsCollection.update({}, modify.unset('done'), multiUpdate: true);
  }
}
