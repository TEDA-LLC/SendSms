import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sendsms/boxes/boxes.dart';
import 'package:sendsms/models/sms_model.dart';
import 'package:sendsms/services/new_sms_service.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:workmanager/workmanager.dart';

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class SendSms extends StatefulWidget {
  const SendSms({super.key});

  @override
  _SendSmsState createState() => _SendSmsState();
}

class _SendSmsState extends State<SendSms> with WidgetsBindingObserver{
  String _message = "";
  final telephony = Telephony.instance;

  var urlBox = GetStorage();
  var index = GetStorage();
  bool index0=false;
  String? url;
    int? _IndecatorArxivsms;
  @override
  void initState() {
    print(urlBox.read('url_index'));
    url = urlBox.read("url_index").toString();
     
    WidgetsBinding.instance.addObserver(this);
    Workmanager().cancelAll();
    index0 = index.read("index0") ?? false;
  
    super.initState();
  }
   
    @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      print("true");
      if(index0){
        // await SmsService.getSmsFlag1(url, context);
        // ignore: use_build_context_synchronously
        // await SmsService.sendingSms(context, url);
        await Workmanager().registerOneOffTask(
                "taskName",
                "Smslar avtomatik jo'natiliyabdi",
              );
        print("index 0  true");
      }
    } else {
     print("false");
    Workmanager().cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arxiv.  Ip > ${urlBox.read("url_index")}'),
        elevation: 0,
        
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
            ),
            // Text("Number of sms ${smsData == null ? 0 : smsData!.length}"),
            ValueListenableBuilder<Box<Datas>>(
                valueListenable: SmsBoxes.getSmsDataList().listenable(),
                builder: ((context, box, _) {

                  final datas = box.values.toList().cast<Datas>();
                  final List<Datas> data = [];
                  for (var i = 0; i < datas.length; i++) {
                    if(datas[i].flag == 4){
                     data.add(datas[i]);
                    }
                  }
                  return buildContent(data);
                })),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                       await SmsService.renewServer(context, url);
                      }, child: Text("Serverni yangilash"))
                ],
              ),
            ),
        
            const Center(),
          ],
        ),
      ),
    );
  }

  Widget buildContent(List<Datas> data) {
    if (data.isEmpty) {
      return Container(
        height: 550.h,
        width: 380.w,
        color: Colors.blueAccent.shade100,
        child: const Center(
          child: Text(
            "Arxiv bo'sh",
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    } else {
      return Container(
        height: 550.h,
        width: 380.w,
        color: Colors.blueAccent.shade100,
        child: ListView.builder(
          padding: EdgeInsets.all(8.r),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final dataIndex = data[index];
            return buildUrlList(context, dataIndex);
          },
        ),
      );
    }
  }

  Widget buildUrlList(
    BuildContext context,
    Datas data,
  ) {
  
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
            child: AnimatedContainer(
             decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.shade400,
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset:const Offset(-2, -2)

                ),
              const   BoxShadow(
                  color: Colors.white,
                  blurRadius: 2,
                  spreadRadius: 4,
                  offset: Offset(2, 2)

                )
              ]
             ),
                 duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutBack,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(data.id.toString()),
                    ),
                    title: Text(data.flag.toString()),
                    trailing: GestureDetector(
                        onTap: () {
                        
                          setState(() {
                           // ignore: unrelated_type_equality_checks
                           if( _IndecatorArxivsms==index)
                        { _IndecatorArxivsms=null;}
                         else
                          {_IndecatorArxivsms=index as int?;}
                         
                          });
                        },
                        // ignore: unrelated_type_equality_checks
                        child: _IndecatorArxivsms==index
                            ? const Icon(Icons.arrow_upward)
                            : const Icon(Icons.arrow_downward)),
                    subtitle: Text(
                     data.zapros.toString(),
                      // ignore: unrelated_type_equality_checks
                      maxLines:_IndecatorArxivsms==index? debugFocusChanges.hashCode:3,
                      style: const TextStyle(),
                    ),
                  ),
                ),
          );
  }

  showSnackBar(String content, Color color) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: color,
      action: SnackBarAction(label: "Hide", onPressed: () {}),
    ));
  }
}
