import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sendsms/screens/seded_smses.dart';
import 'package:sendsms/screens/sms_view.dart';
import 'package:sendsms/screens/main/cubit/main_cubit.dart';
import 'package:sendsms/screens/main/state/main_state.dart';
import 'package:sendsms/screens/arxiv_view.dart';
import 'package:sendsms/screens/settings_view.dart';
import 'package:sendsms/widgets/buttom_navigation_bar_widget.dart';
import 'package:workmanager/workmanager.dart';


class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var index = GetStorage();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    
    super.dispose();
  }

 
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_)=> MainCubit(),
      child: scofold(context));
  }

  Scaffold scofold(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarWidget(),
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<MainCubit, MainState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is StateFlag1) {
              return SmsView();
            } 
             else if (state is StateFlag2) {
              return SendSms();
            } else if (state is StateFlag3) {
               return  SendedSmsesView();
            }
            else if (state is StateFlag4) {
              return const SettingsView();
            } 
          else{
            return Container();
          }
      }),
    );
  }
}