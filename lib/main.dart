import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sendsms/models/url_list_model.dart';
import 'package:hive/hive.dart';
import 'package:sendsms/screens/main/view/main_view.dart';

import 'screens/main/cubit/main_cubit.dart';



void main() async{
 WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UrllListAdapter());
 await Hive.openBox<UrllList>('urls');
  runApp(
    MultiBlocProvider(providers: [ BlocProvider(create: (context) => MainCubit()),],
    child:  const MyApp(),)
   );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
