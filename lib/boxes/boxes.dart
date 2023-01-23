import 'package:hive/hive.dart';
import 'package:sendsms/models/url_list_model.dart';

class Boxes {
  static Box<UrllList> getUrllList(){
    return Hive.box<UrllList>("urls");
  }
}