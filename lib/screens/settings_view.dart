import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive/hive.dart';


class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}
List<String> urls = [];
List<String> list1 = ['10',"11"];
class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    List myList = urlbox.get('url_box');
    super.initState();
  }
  var urlbox = Hive.box("url_box");
  TextEditingController urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(28.0.r),
          child: Column(
            children: [
              Row(children: [
                Padding(
                  padding: EdgeInsets.only(right: 15.0.r),
                  child: SizedBox(
                    height: 60.h,
                    width: 300.w,
                    child: TextFormField(
                      controller: urlController,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5).w,
                      color: Colors.green,
                    ),
                    height: 60.h,
                    width: 60.h,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 45.r,
                      ),
                    ),
                  ),
                  onTap: () async{
                    urls.add(urlController.text);
                    urlbox.put("urslList", urls);
                    setState(() {});
                    print(1);
                  },
                ),
              ]),
              if (urls.isEmpty)
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Text(
                    "Add Url",
                    style:
                        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                  ),
                )
              else
                Container(
                  height: 600.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.r),
                    child: ListView(
                      children: List<Widget>.generate(urls.length, (int index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5.w)),
                          margin: EdgeInsets.only(bottom: 10.r),
                          height: 60.h,
                          width: 350.w,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    height:urlbox.getAt(index)[index].length > 35 ? 45.h : 20.h,
                                    width: 300.w,
                                    child: Text(urlbox.getAt(index)[index].toString())),
                                IconButton(
                                    onPressed: () {
                                      urls.removeAt(index);
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.delete))
                              ]),
                        );
                      }),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
