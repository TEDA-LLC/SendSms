import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sendsms/boxes/boxes.dart';
import 'package:sendsms/models/sms_model.dart';
import 'package:sendsms/screens/main/cubit/main_cubit.dart';
import 'package:sendsms/services/new_sms_service.dart';
import 'package:telephony/telephony.dart';

class SmsView extends StatefulWidget {
  const SmsView({super.key});

  @override
  State<SmsView> createState() => _SmsViewState();
}

final telephony = Telephony.instance;
var urlBox = GetStorage();
List<Datas>? _smsData;
int smsLength = 0;
String url = "";
var box;
Box<Datas>? smsBox;
dynamic smsDataVariable;
bool serLoc = true;

class _SmsViewState extends State<SmsView> {
  @override
  void initState() {
    url = urlBox.read("url_index").toString();
    // box = Hive.box("data_model");
    if (box != null) {
      smsDataVariable = box.get("data_model");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    serLoc = context.watch<MainCubit>().serLoc;
    return Scaffold(
      appBar: AppBar(title: Text("New IP > $url")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                  "Number of sms ${smsDataVariable == null ? 0 : smsDataVariable!.length}"),
              
              ValueListenableBuilder<Box<Datas>>(
                  valueListenable: SmsBoxes.getSmsDataList().listenable(),
                  builder: ((context, box, _) {
                    final datas = box.values.toList().cast<Datas>();
                    return buildContent(datas);
                  })),
              
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (url.isNotEmpty) {
                            getDataFlag1(url,context).then((value) => setState(() {}));
                          } else {
                            showSnackBar(
                                context, "Ip manzil kiriting", Colors.red);
                          }
                        },
                        child: const Text("Server")),
                    ElevatedButton(
                        onPressed: () {
                          //agar bazada flag 4 bo'lsa ularni serverga jo'natib obnavit qilish kerak
                          if (url.length > 3) {
                            getDataFlag2(url).then((value) => setState(() {}));
                          } else {
                            showSnackBar(context, "No url", Colors.red);
                          }print(serLoc);

                        },
                        child: const Text("Local")),
                    //yuklangan smslar uchun knopk
                    //a

                    ElevatedButton(
                        onPressed: () async {
                          if (smsDataVariable != null &&
                              smsDataVariable.isNotEmpty) {
                            for (var i = 0; i < smsDataVariable.length; i++) {
                              await telephony.sendSms(
                                  to: smsDataVariable[i].tel.toString(),
                                  message:
                                      smsDataVariable[i].zapros.toString());
                              print(i);
                              smsLength++;
                              // har bir yarilgan smsni holati 4 bo'lishi garak
                            }
                            if (smsDataVariable != null) {
                              smsDataVariable.removeRange(0, smsLength);
                              smsLength = 0;
                              setState(() {});
                            }
                            //agar list of id jo'natilsa, true qaytmasa telefon bazasiga yozish

                            //  Response response = await Dio().put("http://185.185.80.245:77/sms",data: [1]);

                            //  print(response.data);

                            // ignore: use_build_context_synchronously
                            showSnackBar(
                                context, "SMS jo'natildi", Colors.green);
                          } else {
                            showSnackBar(context, "No data", Colors.red);
                          }
                        },
                        child: const Text("Sms jo'natish")),
                  ],
                ),
              ),
              Center(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){ 
        SmsService.boxLocalClear();
      },
      child: Icon(Icons.clear),
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
            'Smslarni yuklang',
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
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(data.id.toString()),
      ),
      title: Text(data.tel.toString()),
      subtitle: Text(data.zapros.toString()),
    );
  }

  Future getDataFlag1(String url,BuildContext context) async {
    try {
      SmsService.getSmsFlag1(url,context).
      then((value){return setState(() {});});

    } catch (e) {
      print("Errorr >> ${e.toString()}");
    }
  }

  Future getDataFlag2(String url) async {
    try {
      Response res = await Dio().get("http://$url:8081/application/json/sms/?del_flag=2");
      // print(res.data.data[0].user.username);
      print(res.data);
      SmsModel smses = SmsModel.fromJson(res.data);
      _smsData = smses.data;

      if (_smsData != null && _smsData!.isNotEmpty) {
       await SmsService.boxLocalClear();
        for (var i = 0; i < _smsData!.length; i++) {
          addSmsData(
              _smsData![i].id,
              _smsData![i].zapros,
              _smsData![i].rezult,
              _smsData![i].platforma,
              _smsData![i].tel,
              _smsData![i].flag,
              _smsData![i].sana);
        }
        debugPrint("Hive writened");
      }
    } catch (e) {
      print("Errorr >> ${e.toString()}");
    }

    context.read<MainCubit>().changeSmsView(true);
    
     
  }

  Future addSmsData(int? id, String? zapros, String? rezult, String? platforma,
      String? tel, int? flag, String? sana) async {
    final smsData = Datas()
      ..id = id ?? 0
      ..zapros = zapros ?? "no data"
      ..rezult = rezult ?? "no data"
      ..platforma = platforma ?? "no data"
      ..tel = tel ?? "no data"
      ..flag = flag ?? 0
      ..sana = sana ?? "no data";
    final box = SmsBoxes.getSmsDataList();
    box.add(smsData);
  }

  Future addNewSmsData(int? id, String? zapros, String? rezult,
      String? platforma, String? tel, int? flag, String? sana) async {
    final smsData = Datas()
      ..id = id ?? 0
      ..zapros = zapros ?? "no data"
      ..rezult = rezult ?? "no data"
      ..platforma = platforma ?? "no data"
      ..tel = tel ?? "no data"
      ..flag = flag ?? 0
      ..sana = sana ?? "no data";
    final box = NewSmsBoxes.getNewSmsDataList();
    box.add(smsData);
  }

  showSnackBar(BuildContext context, String content, Color color) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: color,
      action: SnackBarAction(label: "Hide", onPressed: () {}),
    ));
  }

  @override
  void dispose() {

    super.dispose();
  }
}
