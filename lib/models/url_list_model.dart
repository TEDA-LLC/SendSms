import 'package:hive/hive.dart';

part 'url_list_model.g.dart';

@HiveType(typeId: 0)
class UrllList extends HiveObject {
  @HiveField(0)
  late String url;
}
