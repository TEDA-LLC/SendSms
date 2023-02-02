import 'package:hive/hive.dart';

part 'datas_model.g.dart';

@HiveType(typeId: 4)
class Datas {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? zapros;
  @HiveField(2)
  String? rezult;
  @HiveField(3)
  String? platforma;
  @HiveField(4)
  String? tel;
  @HiveField(5)
  int? flag;
  @HiveField(6)
  String? sana;

  Datas(
      {this.id,
      this.zapros,
      this.rezult,
      this.platforma,
      this.tel,
      this.flag,
      this.sana});

  Datas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zapros = json['zapros'];
    rezult = json['rezult'];
    platforma = json['platforma'];
    tel = json['tel'];
    flag = json['flag'];
    sana = json['sana'];
  }

}
