import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendsms/screens/main/cubit/main_cubit.dart';
import 'package:sendsms/screens/main/state/main_state.dart';
import 'package:sendsms/screens/send_sms_view.dart';
import 'package:sendsms/widgets/buttom_navigation_bar_widget.dart';


class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

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
              return const Center(child: Text("Flag 1"),);
            } 
             else if (state is StateFlag2) {
              return const SendSms();
            } else if (state is StateFlag3) {
               return const Center(child: Text('Flag 3'),);
            }
          else{
            return Container();
          }
      }),
    );
  }
}