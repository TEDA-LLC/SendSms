
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sendsms/models/sms_model.dart';

class SmsService{
  static Box<Datas>? box;
  
  static Future<List<Datas>?> getSmsFlag1(String url)async{
    try {
    Response res = await Dio().get('http://$url:77/sms/status?status=1');
    List<Datas> d = (res.data as List).map((e) => Datas.fromJson(e)).toList();
    await putData(d);
    return d;
    } catch (e) {
      print(e);
    }
  }


  static openBox()async{
    box = await Hive.openBox('sms_new');
    
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
  }

  static putData(List<Datas> data)async{

    await box!.clear();
    for(var item in data){
      await box!.add(item);
    }
  }
  
   static boxClear()async{
    await box!.clear();
   }


}