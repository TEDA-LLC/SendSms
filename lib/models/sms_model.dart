
import 'package:hive/hive.dart';
part 'sms_model.g.dart';

@HiveType(typeId: 2)
class SmsModel {
  @HiveField(0)
  String? message;
  @HiveField(1)
  bool? success;
  @HiveField(2)
  int? status;
  @HiveField(3)
  List<Datas>? data;

  SmsModel({this.message, this.success, this.status, this.data});

  SmsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Datas>[];
      json['data'].forEach((v) {
        data!.add(Datas.fromJson(v));
      });
    }
  }

 
}

@HiveType(typeId: 3)
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
