import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sendsms/screens/main/cubit/main_cubit.dart';


class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentPage = context.watch<MainCubit>().currentpage;
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
        currentIndex: currentPage,
        type: BottomNavigationBarType.fixed,
        onTap: (v) => context.read<MainCubit>().pages(v),
        // fixedColor: ColorConst.kPrimaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sms,
              // color: currentPage == 0
              //     ? ColorConst.knavigationPressed
              //     : ColorConst.knavigationUnpressed,
              size:currentPage == 0
                  ? 35.h
                  : 25.h,
                  
            ),
            label: 'Sms',
            backgroundColor:Colors.greenAccent,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.folder,
                  // color: currentPage == 2
                  //     ? ColorConst.knavigationPressed
                  //     : ColorConst.knavigationUnpressed,
                      size:currentPage == 1
                  ? 35.h
                  : 25.h,),
              label: 'Yuborilganlar',
            backgroundColor:Colors.redAccent,
              ),
               BottomNavigationBarItem(
              icon: Icon(Icons.send,
                  // color: currentPage == 1
                  //     ? ColorConst.knavigationPressed
                  //     : ColorConst.knavigationUnpressed,
                      size:currentPage == 2
                  ? 35.h
                  : 25.h,),
              label: 'Arxiv',
            backgroundColor:Colors.yellowAccent,

              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings,
                  // color: currentPage == 2
                  //     ? ColorConst.knavigationPressed
                  //     : ColorConst.knavigationUnpressed,
                      size:currentPage == 3
                  ? 35.h
                  : 25.h,),
              label: 'Sozlash',
            backgroundColor:Colors.redAccent,
              ),
         
         
          
                
           
        ]);
  }
}
