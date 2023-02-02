import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sendsms/boxes/boxes.dart';
import 'package:sendsms/models/sms_model.dart';
import 'package:sendsms/services/new_sms_service.dart';


class SendedSmsesView extends StatefulWidget {
  const SendedSmsesView({super.key});

  @override
  State<SendedSmsesView> createState() => _SendedSmsesViewState();
}

class _SendedSmsesViewState extends State<SendedSmsesView> {
var urlIndexBox = GetStorage();
dynamic smsDataVariable;
var box;
  @override
  void initState() {
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Ip address > ${urlIndexBox.read("url_index")}")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,

              ),
             
              ValueListenableBuilder<Box<Datas>>(
                  valueListenable: SmsArxivBoxes.getArxivDataList().listenable(),
                  builder: ((context, box, _) {

                    final datas = box.values.toList().cast<Datas>();
                    
                    return buildContent(datas);
                  })),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                        }, child:const Text("Serverni yangilash")),
                     ElevatedButton(
                        onPressed: () async {
                          SmsService.boxArxivClear();
                        }, child:const Text("Arxivni tozalash")),
                  ],
                ),
              ),
             
              const Center(),
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
            "Jo'natilgan smslar bo'sh",
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

}