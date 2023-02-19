import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sendsms/boxes/boxes.dart';
import 'package:sendsms/constants/colors_const.dart';
import 'package:sendsms/models/url_list_model.dart';
import 'package:workmanager/workmanager.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with WidgetsBindingObserver {
  var index = GetStorage();
  bool index0 = false;
  bool index1 = false;
  bool index2 = false;
  String url = "";
  int? _selectSwitch;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    Workmanager().cancelAll();
    index0 = index.read("index0") ?? false;
    url = urlIndexBox.read("url_index").toString();

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
      if (index.read("index0") == true) {
        // await SmsService.getSmsFlag1(url, context);
        // ignore: use_build_context_synchronously
        // await SmsService.sendingSms(context, url);
        await Workmanager().registerPeriodicTask(
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

  var urlIndexBox = GetStorage();

  TextEditingController urlController = TextEditingController();
  TextEditingController smsLimtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("Ip address > ${urlIndexBox.read("url_index")}"),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white24,
                    blurRadius: 2,
                    spreadRadius: 4,
                  )
                ]),
            height: 40.h,
            width: 70.w,

            child: Center(
              child: Text("${urlIndexBox.read("sms_limt")??"0"}"),
            ),
            // child: TextFormField(),
          ),
          onTap: () {
            showDialog(
              
              context: context,
              builder: ((context) => AlertDialog(
                
                    // title: Text("Sms limitingizni kiriting"),
                    title: Column(
                      children: [
                        Text("Sms limitingiz: ${urlIndexBox.read("sms_limt")??"0"}"),
                        SizedBox(
                          height: 10.h,
                        ),
                        const Text("Sms limitingizni kiriting"),
                      ],
                    ),
                    content: SizedBox(
                      height: 100.h,
                      width: 100.w,
                      //textfild hint getstorage sms limit and input type number
                      child: TextFormField(
                        controller: smsLimtController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: urlIndexBox.read("sms_limt")==null ? "0" : urlIndexBox.read("sms_limt").toString(),
                          border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: ColorConst.kPrimaryColor,
                            borderRadius: BorderRadius.circular(5).w,
                          ),
                          child: const Center(
                            child:  Text(
                              'Cancel',
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        onPressed: () {
                          smsLimtController.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: Container(
                          height: 40,
                          width: 60,
                          decoration: BoxDecoration(
                            color: ColorConst.kPrimaryColor,
                            borderRadius: BorderRadius.circular(5).w,
                          ),
                          child: const Center(
                              child: Text(
                            "Ok",
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                        onPressed: () {
                          if (smsLimtController.text.isNotEmpty &&
                              smsLimtController.text.length < 6) {
                            urlIndexBox.write(
                                "sms_limt", smsLimtController.text);
                            smsLimtController.clear();
                            Navigator.of(context).pop();
                          } else {
                            showSnackBar("son keriting yoki miqdor juda ko`p",
                                Colors.red);
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  )),
            );
          },
        )
      ])),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(28.0.r),
          child: Column(
            children: [
              Row(children: [
                Padding(
                  padding: EdgeInsets.only(right: 11.0.r),
                  child: SizedBox(
                    height: 60.h,
                    width: 300.w,
                    child: TextFormField(
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        hintText: "write url",
                        border: OutlineInputBorder(),
                      ),
                      controller: urlController,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5).w,
                      color: ColorConst.kPrimaryColor,
                    ),
                    height: 58.h,
                    width: 58.h,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 45.r,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    addUrl(urlController.text);
                    setState(() {});
                  },
                ),
              ]),
              ValueListenableBuilder<Box<UrllList>>(
                  valueListenable: Boxes.getUrllList().listenable(),
                  builder: ((context, box, _) {
                    final urls = box.values.toList().cast<UrllList>();
                    return buildContent(urls);
                  })),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 100.h,
                width: 400.w,
                decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.teal.shade200,
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: const Offset(-2, -2)),
                      const BoxShadow(
                          color: Colors.white,
                          blurRadius: 2,
                          spreadRadius: 4,
                          offset: Offset(2, 2))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: Container(
                          height: 90.h,
                          width: 150.w,
                          // color: Colors.red,
                          child: Column(
                            children: [
                              Switch.adaptive(
                                  value: index0,
                                  onChanged: ((bool value) async {
                                    index0 = value;
                                    await index.write("index0", value);
                                    print(index.read("index0"));
                                    if (index0 == true) {
                                      showSnackBar("Smslar avtomatik",
                                          Colors.purpleAccent);
                                    }
                                    setState(() {});
                                  })),
                              const Text("Avtomatik ishlash")
                            ],
                          )),
                    ),
                    // Container(
                    //     height: 90.h,
                    //     width: 150.w,
                    // color: Colors.red,
                    //     child: Column(
                    //       children: [
                    //         Switch(
                    //             value: index1,
                    //             onChanged: ((bool value) => setState(() {
                    //                   index1 = value;
                    //                 }))),
                    //         Text("Birinchi"),
                    //       ],
                    //     )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent(List<UrllList> urls) {
    if (urls.isEmpty) {
      return Center(
        child: Text(
          'Add url',
          style: GoogleFonts.abel(
              textStyle: Theme.of(context).textTheme.displayMedium,
              fontSize: 30),
        ),
      );
    } else {
      return SizedBox(
        height: 450.h,
        width: 400.w,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 1.r),
          itemCount: urls.length,
          itemBuilder: (BuildContext context, int index) {
            final url = urls[index];
            return buildUrlList(context, url, index);
          },
        ),
      );
    }
  }

  Widget buildUrlList(BuildContext context, UrllList url, int index) {
    return GestureDetector(
      // onDoubleTap: () {
      //   urlIndexBox.write("url_index", url.url.toString());
      //   showSnackBar(
      //       "Ip changes ${urlIndexBox.read("url_index")}", Colors.green);
      //   setState(() {});
      // },
      child: Container(
        decoration: BoxDecoration(
            color: ColorConst.urlColor,
            borderRadius: BorderRadius.circular(5.w)),
        margin: EdgeInsets.only(bottom: 10.r),
        padding: const EdgeInsets.only(left: 12, bottom: 2),
        height: 60.h,
        width: 350.w,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
              height: 20.h,
              child: Text(
                url.url,
                style: GoogleFonts.abel(
                    textStyle: Theme.of(context).textTheme.displayMedium,
                    fontSize: 20,
                    color: Colors.black),
              )),
          Row(
            children: [
              Switch.adaptive(
                  value: _selectSwitch == index,
                  activeColor: Colors.teal,
                  onChanged: ((bool value) async {
                    setState(() {
                      // ignore: unrelated_type_equality_checks
                      if (_selectSwitch == index) {
                        _selectSwitch = null;
                      } else {
                        _selectSwitch = index as int?;
                      }
                      urlIndexBox.write("url_index", url.url.toString());
                      showSnackBar(
                          "Ip changes ${urlIndexBox.read("url_index")}",
                          Colors.green);
                      setState(() {});
                    });
                  })),
              IconButton(
                  onPressed: () {
                    deleteUrl(url);
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 244, 19, 2),
                    size: 28,
                  )),
            ],
          )
        ]),
      ),
    );
  }

  Future addUrl(String url) async {
    final urls = UrllList()..url = url;

    final box = Boxes.getUrllList();
    box.add(urls);
  }

  void deleteUrl(UrllList url) {
    url.delete();
  }

  showSnackBar(String content, Color color) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: color,
      action: SnackBarAction(label: "Hide", onPressed: () {}),
    ));
  }
}
