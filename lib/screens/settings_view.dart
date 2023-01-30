import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sendsms/boxes/boxes.dart';
import 'package:sendsms/models/url_list_model.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void dispose() {
    // Hive.box("urlss").close();
    super.dispose();
  }
  var urlIndexBox = GetStorage();
  
  TextEditingController urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Settings: Ip address > ${urlIndexBox.read("url_index")}")),
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
                  onTap: () async {
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
                  }))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent(List<UrllList> urls) {
    if (urls.isEmpty) {
      return const Center(
        child: Text(
          'Add url',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return SizedBox(
        height: 500.h,
        width: 400.w,
        child: ListView.builder(
          padding: EdgeInsets.all(8.r),
          itemCount: urls.length,
          itemBuilder: (BuildContext context, int index) {
            final url = urls[index];
            
            return buildUrlList(context, url,index);
          },
        ),
      );
    }
  }

  Widget buildUrlList(BuildContext context, UrllList url, int index) {
    return GestureDetector(
      onDoubleTap: () {
        urlIndexBox.write("url_index", url.url.toString());
        showSnackBar("Ip changes ${urlIndexBox.read("url_index")}", Colors.green);
        setState(() {
          
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(5.w)),
        margin: EdgeInsets.only(bottom: 10.r),
        height: 60.h,
        width: 350.w,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(height: 20.h, width: 300.w, child: Text(url.url)),
          IconButton(
              onPressed: () {
                deleteUrl(url);
                setState(() {});
              },
              icon: const Icon(Icons.delete))
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
