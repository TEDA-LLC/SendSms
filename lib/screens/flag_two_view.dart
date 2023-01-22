import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sendsms/models/sms_model.dart';
import 'package:telephony/telephony.dart';

class FlagTwoView extends StatefulWidget {
  const FlagTwoView({super.key});

  @override
  State<FlagTwoView> createState() => _FlagTwoViewState();
}

final telephony = Telephony.instance;
TextEditingController _urlControllerFlag1 = TextEditingController();
TextEditingController _urlControllerFlag2 = TextEditingController(text: "http://185.185.80.245:77/sms/status?status=2");
List<Data>? _smsDataFlag1;
int smsLength = 0;

class _FlagTwoViewState extends State<FlagTwoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yangi Smslar")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.r),
                child: TextFormField(
                  controller: _urlControllerFlag1,
                  decoration: InputDecoration(hintText: "Url for Flag1"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.r),
                child: TextFormField(
                  controller: _urlControllerFlag2,
                  decoration: InputDecoration(hintText: "Url for Flag2"),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                  "Number of sms ${_smsDataFlag1 == null ? 0 : _smsDataFlag1!.length}"),
              Container(
                height: 450.h,
                width: 380.w,
                color: Colors.blueAccent.shade100,
                child: ListView.builder(
                    itemCount:
                        _smsDataFlag1 == null ? 0 : _smsDataFlag1!.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(_smsDataFlag1![index].id.toString()),
                        ),
                        title: Text(_smsDataFlag1![index].tel.toString()),
                        subtitle: Text(_smsDataFlag1![index].rezult.toString()),
                      );
                    })),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if(_urlControllerFlag1.text.length > 3){
                          getData(_urlControllerFlag1.text).then((value) => setState(() {}));
                          }else{
                            showSnackBar(context, "No url", Colors.red);
                          }
                        },
                        child: const Text("Flag 1")),
                    ElevatedButton(
                        onPressed: () {
                          if(_urlControllerFlag2.text.length > 3){
                          getData(_urlControllerFlag2.text).then((value) => setState(() {}));
                          }else{
                            showSnackBar(context, "No url", Colors.red);
                          }
                        },
                        child: const Text("Flag 2")),
                    ElevatedButton(
                        onPressed: () async {
                          if (_smsDataFlag1 != null && _smsDataFlag1!.isNotEmpty) {
                            for (var i = 0; i < _smsDataFlag1!.length; i++) {
                              await telephony.sendSms(
                                  to: _smsDataFlag1![i].tel.toString(),
                                  message: _smsDataFlag1![i].rezult.toString());
                              print(i);
                               smsLength ++;
                             
                            }
                            if(_smsDataFlag1!=null){
                             _smsDataFlag1!.removeRange(0, smsLength);
                             smsLength =0;
                            setState(() {
                              
                            });
                          }
                           Response response = await Dio().put("http://185.185.80.245:77/sms",data: [1]);
                           print(response.data);
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, "SMS jo'natildi", Colors.green);
                          } else {
                            showSnackBar(context, "No data", Colors.red);
                          }
                           
      
                        },
                        child: const Text('Send sms')),
                  ],
                ),
              ),
              Center(),
            ],
          ),
        ),
      ),
     
    );
  }

  Future getData(String url) async {
    try {
      Response res =
          await Dio().get(url);
      // print(res.data.data[0].user.username);
      print(res.data);
      SmsModel smses = SmsModel.fromJson(res.data);
      _smsDataFlag1 = smses.data;
    } catch (e) {
      print("Errorr >> ${e.toString()}");
    }
  }

  showSnackBar(BuildContext context, String content, Color color) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: color,
      action: SnackBarAction(label: "Hide", onPressed: () {}),
    ));
  }
}
