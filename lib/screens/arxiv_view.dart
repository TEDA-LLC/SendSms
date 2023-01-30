import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sendsms/models/sms_model.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class SendSms extends StatefulWidget {
  const SendSms({super.key});

  @override
  _SendSmsState createState() => _SendSmsState();
}

class _SendSmsState extends State<SendSms> {
  String _message = "";
  final telephony = Telephony.instance;

  var urlBox = GetStorage();
  
  @override
  void initState() {
    print(urlBox.read('url_index'));

    super.initState();
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  List<Datas>? smsData;

  // Platform messages
  //are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  Future getData() async {
    try {
      Response res = await Dio().get("http://${urlBox.read("url_index")}:77/sms/status?status=3");
      // print(res.data.data[0].user.username);
      print(res.data);
      SmsModel smses = SmsModel.fromJson(res.data);
      smsData = smses.data;
    } catch (e) {
      print("Errorr >> ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flag 3.  Ip > ${urlBox.read("url_index")}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h,),
            Text("Number of sms ${smsData == null ? 0 : smsData!.length}"),
            Container(
              height: MediaQuery.of(context).size.height * 0.57,
              width: MediaQuery.of(context).size.width * 0.8,
              color: Colors.blueAccent.shade100,
              child: ListView.builder(
                  itemCount: smsData == null ? 0 : smsData!.length,
                  itemBuilder: ((context, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(smsData![index].id.toString()),
                          ),
                          title: Text(smsData![index].tel.toString()),
                          subtitle: Text(smsData![index].rezult.toString()),
                        ),
                        Divider(color: Colors.black,height: 2.h,)
                      ],
                    );
                  })),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        getData().then((value) => setState(() {}));
                 
                      },
                      child: const Text("Yuborilgan smslar")),
                  ElevatedButton(
                      onPressed: () async {
                        if (smsData != null) {
                          for (var i = 0; i < smsData!.length; i++) {
                            await telephony.sendSms(
                                to: smsData![i].tel.toString(),
                                message: smsData![i].rezult.toString());
                            print(i);
                          }
                          
                          showSnackBar("Text", Colors.green);
                        } else {
                          showSnackBar("No data", Colors.red);
                        }
                      },
                      child: Text("Smslarni tozalash"))
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(
                child: ElevatedButton(
                  onPressed: (){},
                  child:const Text("Serverni yangilash")),),
            ),
            const Center(),
          ],
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
