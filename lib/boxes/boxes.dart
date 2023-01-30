import 'package:hive/hive.dart';
import 'package:sendsms/models/sms_model.dart';
import 'package:sendsms/models/url_list_model.dart';

class Boxes {
  static Box<UrllList> getUrllList(){
    return Hive.box<UrllList>("urlss");
  }
}

class SmsBoxes {
  static Box<Datas> getSmsDataList(){
    return Hive.box<Datas>("data_model");
  }
}

// class SmsNewBoxes {
//   static Box<Datas> getSmsDataList(){
//     return Hive.box<Datas>("data_model");
//   }
// }

class NewSmsBoxes {
  static Box<Datas> getNewSmsDataList(){
    return Hive.box<Datas>("new_sms");
  }
}


class ArxivBoxes {
  static Box<Datas> getSmsDataList(){
    return Hive.box<Datas>("arxiv_model");
  }
}