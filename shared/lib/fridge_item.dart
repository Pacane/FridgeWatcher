library models;

import 'package:redstone_mapper_mongo/metadata.dart';
import 'package:redstone_mapper/mapper.dart';

class FridgeItem {
  @Id()
  String id;
  @Field()
  String name;
  @Field()
  DateTime addedOn;
  @Field()
  DateTime expiresOn;
}
