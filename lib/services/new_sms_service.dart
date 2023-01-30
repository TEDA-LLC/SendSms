
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sendsms/models/sms_model.dart';
import 'package:sendsms/screens/main/cubit/main_cubit.dart';


class SmsService{
  static Box<Datas>? box;
  static Box<Datas>? boxDataModel;
  static Future<List<Datas>?> getSmsFlag1(String url,BuildContext context)async{
    try {
    Response res = await Dio().get('http://$url:8081/application/json/sms/?del_flag=1');
    var d = res.data;
    List<Datas> f = (d["data"] as List ).map((e) => Datas.fromJson(e)).toList();
    print(d);
    int newSmsNum = f.length;
    if(f.isNotEmpty){
    await putLocalData(f);
    // await putData(f);
    
    debugPrint("Flag 1 data added");
    // ignore: use_build_context_synchronously
    showSnackBar(context, "$newSmsNum ta sms qo'shildi", Colors.green);
    // context.read<MainCubit>().changeSmsView(false);
    }
    else{
     debugPrint("Flag 1 data empty");
  
    // ignore: use_build_context_synchronously
    showSnackBar(context, "Yuklash uchun ma'lumot yo'q", Colors.amber);

    }
    return f;
    } catch (e) {
     debugPrint("flag 1 catch >> $e");

    // ignore: use_build_context_synchronously
    showSnackBar(context, "Yuklashda xatolik yuz berdi", Colors.red);
    }

  }

  
  static openBox()async{
    box = await Hive.openBox('sms_new');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
  }

  static openBoxDataModel()async{
    boxDataModel = await Hive.openBox('data_model');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
  }

  static putData(List<Datas> data)async{
    await box!.clear();
    for(var item in data){
      await box!.add(item);
    }
  }

  static putLocalData(List<Datas> data)async{
    for(var item in data){
      await boxDataModel!.add(item);
    }
  }
  
  static boxClear()async{
    await box!.clear();
  }

  static boxLocalClear() async{
    await boxDataModel!.clear();
  }
  
  
  
  static showSnackBar(BuildContext context, String content, Color color) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: color,
      action: SnackBarAction(label: "Hide", onPressed: () {}),
    ));
  }
}