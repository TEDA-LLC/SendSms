import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sendsms/models/sms_model.dart';
import 'package:telephony/telephony.dart';

class FlagOneView extends StatefulWidget {
  const FlagOneView({super.key});

  @override
  State<FlagOneView> createState() => _FlagOneViewState();
}
final telephony = Telephony.instance;
TextEditingController _urlControllerFlag1 = TextEditingController();
List<Data>? _smsDataFlag1;

Future getData() async {
    try {
      Response res = await Dio().get("http://185.185.80.245:77/sms/status?status=2");
      // print(res.data.data[0].user.username);
      print(res.data);
      SmsModel smses = SmsModel.fromJson(res.data);
      _smsDataFlag1 = smses.data;
    } catch (e) {
      print("Errorr >> ${e.toString()}");
    }
  }
class _FlagOneViewState extends State<FlagOneView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yangi Smslar")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _urlControllerFlag1,
              ),
            ),
            Text("Number of sms ${_smsDataFlag1 == null ? 0 : _smsDataFlag1!.length}"),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.8,
              color: Colors.blueAccent.shade100,
              child: ListView.builder(
                  itemCount: _smsDataFlag1 == null ? 0 : _smsDataFlag1!.length,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        getData().then((value) => setState(() {}));
                      },
                      child: const Text("Get data")),
                  ElevatedButton(
                      onPressed: () async {
                        if (_smsDataFlag1 != null) {
                          // for (var i = 0; i < _smsDataFlag1!.length; i++) {
                          //   await telephony.sendSms(
                          //       to: _smsDataFlag1![i].tel.toString(),
                          //       message: _smsDataFlag1![i].rezult.toString());
                          //   print(i);
                          // }
                          final snackBar = SnackBar(
            content: const Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          showSnackBar(context,"No data", Colors.red);
                        }
                      },
                      child: Text('Send sms'))
                ],
              ),
            ),
            Center(),
          ],
        ),
      ),
    );
  }

  Future getData() async {
    try {
      Response res = await Dio().get("http://185.185.80.245:77/sms/status?status=2");
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
