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
import 'package:workmanager/workmanager.dart';

class SmsView extends StatefulWidget {
  const SmsView({super.key});

  @override
  State<SmsView> createState() => _SmsViewState();
}

var index = GetStorage();
bool index0 = false;
final telephony = Telephony.instance;
var urlBox = GetStorage();
List<Datas>? _smsData;
int smsLength = 0;
String url = "";
var box;
Box<Datas>? smsBox;
dynamic smsDataVariable;
bool serLoc = true;

class _SmsViewState extends State<SmsView> with WidgetsBindingObserver {
  @override
  void initState() {
    url = urlBox.read("url_index").toString();
    WidgetsBinding.instance.addObserver(this);
    Workmanager().cancelAll();
    index0 = index.read("index0") ?? false;
    url = urlBox.read("url_index").toString();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      print("true");
      if (index0) {
        // await SmsService.getSmsFlag1(url, context);
        // ignore: use_build_context_synchronously
        // await SmsService.sendingSms(context, url);
        await Workmanager().registerOneOffTask(
          'taskName',
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
              // Text(
              //     "Number of sms ${smsDataVariable == null ? 0 : smsDataVariable!.length}"),
              ValueListenableBuilder<Box<Datas>>(
                  valueListenable: SmsBoxes.getSmsDataList().listenable(),
                  builder: ((context, box, _) {
                    final datas = box.values.toList().cast<Datas>();
                    final List<Datas> data = [];
                    for (var i = 0; i < datas.length; i++) {
                      if (datas[i].flag == 2) {
                        data.add(datas[i]);
                      }
                    }
                    return buildContent(data);
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
                            getDataFlag1(url, context)
                                .then((value) => setState(() {}));
                          } else {
                            showSnackBar(
                                context, "Ip manzil kiriting", Colors.red);
                          }
                        },
                        child: const Text("Yangi Smslar")),
                    ElevatedButton(
                        onPressed: () async {
                          await SmsService.sendingSms(context, url);
                          setState(() {});
                        },
                        child: const Text("Smslarni jo'natish")),
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

  Widget buildContent(List<Datas> data) {
    if (data.isEmpty) {
      return Container(
        height: 620.h,
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
        height: 620.h,
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

  Future getDataFlag1(String url, BuildContext context) async {
    try {
      SmsService.getSmsFlag1(url, context: context).then((value) {
        return setState(() {});
      });
    } catch (e) {
      print("Errorr >> ${e.toString()}");
    }
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
