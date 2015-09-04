@TestOn("browser")
import 'package:fridge_watcher_shared/fridge_item.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import "package:test/test.dart";
import 'package:fridge_watcher/fridge_service.dart';
import 'package:fridge_watcher/app_config.dart';

void main() {
  AppConfig config = new AppConfig();
  config.apiBaseUrl = 'http://localhost:8080/api';

  test('add item should return the added item with an ID', () async {
    bootstrapMapper();

    FridgeService service = new FridgeService(config);

    FridgeItem result = await service.addItem(new FridgeItem()
      ..name = 'banane'
      ..expiresOn = new DateTime.now().add(new Duration(days: 2)));

    expect(result.id, isNotNull);
    expect(result.name, equals('banane'));
    expect(result.expiresOn, isNotNull);
    expect(result.addedOn, isNotNull);
  });
}
