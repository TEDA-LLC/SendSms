import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sendsms/models/sms_model.dart';
import 'package:telephony/telephony.dart';

class SmsService {
  static Box<Datas>? box;
  static Box<Datas>? boxDataModel;
  static Box<Datas>? boxArxivModel;
  static List<Datas> list = [];
  static List<Datas> list1 = [];
  static Future<List<Datas>?> getSmsFlag1(
      String url, BuildContext context) async {
    try {
      Response res =
          await Dio().get('http://$url:8081/application/json/sms/?del_flag=1');
      var d = res.data;
      List<Datas> f =
          (d["data"] as List).map((e) => Datas.fromJson(e)).toList();
      print(d);
      int newSmsNum = f.length;
      if (f.isNotEmpty) {
        await putLocalData(f);
        // await putData(f);

        debugPrint("Flag 1 data added");
        // ignore: use_build_context_synchronously
        showSnackBar(context, "$newSmsNum ta sms qo'shildi", Colors.green);
        // context.read<MainCubit>().changeSmsView(false);
      } else {
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

  static openBox() async {
    box = await Hive.openBox('sms_new');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
  }

  static openBoxDataModel() async {
    boxDataModel = await Hive.openBox('data_model');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
  }

  static openBoxArxivModel() async {
    boxArxivModel = await Hive.openBox('arxiv_model');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
  }

  static putData(List<Datas> data) async {
    await box!.clear();
    for (var item in data) {
      await box!.add(item);
    }
  }

  static putLocalData(List<Datas> data) async {
    for (var item in data) {
      await boxDataModel!.add(item);
    }
  }

  static putArxivData(List<Datas> data) async {
    for (var item in data) {
      await boxArxivModel!.add(item);
    }
  }

  static boxClear() async {
    await box!.clear();
  }

  static boxLocalClear() async {
    await boxDataModel!.clear();
  }

  static boxArxivClear() async {
    await boxArxivModel!.clear();
  }

  static var telephony = Telephony.instance;
  static sendingSms(BuildContext context, String url) async {
    List dataId = [];
    int spy = 0;
    if (boxDataModel != null && boxDataModel!.isNotEmpty) {
      for (var i = 0; i < boxDataModel!.length; i++) {
        if (boxDataModel!.getAt(i)!.flag == 2) {
          await telephony.sendSms(
              to: boxDataModel!.getAt(i)!.tel.toString(),
              message: boxDataModel!.getAt(i)!.zapros.toString());
          boxDataModel!.getAt(i)!.flag = 4;
        }
        debugPrint(i.toString());

        debugPrint(boxDataModel!.getAt(i)!.flag.toString());
        dataId.add(boxDataModel!.getAt(i)!.id);
        spy++;
      }
      //agar list of id jo'natilsa, true qaytmasa telefon bazasiga yozish
      try {
        Response response = await Dio()
            .put("http://$url:8081/application/json/sms", data: dataId);
        print(response.data);

        // ignore: use_build_context_synchronously
        showSnackBar(context, "Malumotlar yangilandi", Colors.green);
        for (var i = 0; i < boxDataModel!.length; i++) {
          list.add(boxDataModel!.getAt(i) ?? Datas());
        }
        debugPrint("Arxiv >>>> ${list.toString()}");
        await putArxivData(list);
        boxLocalClear();
      } catch (e) {
        debugPrint("Server yangilanmadi ERROR >>> $e");
        // ignore: use_build_context_synchronously
        showSnackBar(context, "Server yangilanmadi", Colors.red);
      }
      // ignore: use_build_context_synchronously
      showSnackBar(context, "$spy SMS jo'natildi", Colors.green);
      spy = 0;
    } else {
      showSnackBar(context, "No data", Colors.red);
    }
  }

  static renewServer(BuildContext context, url) async {
    List dataId = [];
    if (boxDataModel != null && boxDataModel!.isNotEmpty) {
      for (var i = 0; i < boxDataModel!.length; i++) {
        if (boxDataModel!.getAt(i)!.flag == 4) {
          dataId.add(boxDataModel!.getAt(i)!.id);
        }
      }
      try {
        Response response = await Dio()
            .put("http://$url:8081/application/json/sms", data: dataId);
        print(response.data);
        for (var i = 0; i < boxDataModel!.length; i++) {
          if (boxDataModel!.getAt(i)!.flag == 4) {
            boxDataModel!.getAt(i)!.flag = 3;
            list1.add(boxDataModel!.getAt(i) ?? Datas());
          }
        }
        putArxivData(list1);

        // ignore: use_build_context_synchronously
        showSnackBar(context, "Malumotlar yangilandi", Colors.green);
      } catch (e) {
        debugPrint("Server yangilanmadi ERROR >>> $e");
        // ignore: use_build_context_synchronously
        showSnackBar(context, "Server yangilanmadi", Colors.red);
      }
    } else {
      showSnackBar(context, "Sms yo'q", Colors.amber);
    }
  }

  static showSnackBar(BuildContext context, String content, Color color) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: color,
      action: SnackBarAction(label: "Hide", onPressed: () {}),
    ));
  }
}
