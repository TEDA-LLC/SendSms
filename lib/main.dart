import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sendsms/models/sms_model.dart';
import 'package:sendsms/models/url_list_model.dart';
import 'package:hive/hive.dart';
import 'package:sendsms/screens/main/view/main_view.dart';
import 'package:sendsms/services/new_sms_service.dart';
import 'package:workmanager/workmanager.dart';

import 'screens/main/cubit/main_cubit.dart';

void callbackDispatcher() {
  var urlBox = GetStorage();
  Workmanager().executeTask((taskName, inputData) async {
    for (var i = 0; i < 2880; i++) {
      await Future.delayed(const Duration(seconds: 5));
      // ignore: use_build_context_synchronously
      await SmsService.getSmsFlag1(urlBox.read("url_index"));
      print("1");
      await Future.delayed(const Duration(seconds: 5));
      // ignore: use_build_context_synchronously
      await SmsService.sendingSmsback(urlBox.read("url_index"));
      print("2");
    }
    return Future.value(true);
  });
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Hive.initFlutter();
  Hive.registerAdapter(UrllListAdapter());
  Hive.registerAdapter(SmsModelAdapter());
  Hive.registerAdapter(DatasAdapter());
  await Hive.openBox<UrllList>('urlss');
  await SmsService.openBoxArxivModel();
  await SmsService.openBoxDataModel();
  await Hive.openBox<Datas>("new_sms");
  await SmsService.openBox();
  await GetStorage.init();
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => MainCubit()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  var urlbox = GetStorage();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final url = urlbox.read("url_index");
    url == null
        ? context.read<MainCubit>().changeCurrentPage(2)
        : context.read<MainCubit>().changeCurrentPage(0);
    return ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MainView(),
          );
        });
  }
}
