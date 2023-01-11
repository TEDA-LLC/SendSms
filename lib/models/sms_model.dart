class SmsModel {
  String? message;
  bool? success;
  int? status;
  List<Data>? data;

  SmsModel({this.message, this.success, this.status, this.data});

  SmsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

 
}

class Data {
  int? id;
  String? zapros;
  String? rezult;
  String? platforma;
  String? tel;
  int? flag;
  String? sana;

  Data(
      {this.id,
      this.zapros,
      this.rezult,
      this.platforma,
      this.tel,
      this.flag,
      this.sana});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zapros = json['zapros'];
    rezult = json['rezult'];
    platforma = json['platforma'];
    tel = json['tel'];
    flag = json['flag'];
    sana = json['sana'];
  }

}
