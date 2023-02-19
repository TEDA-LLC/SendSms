import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sendsms/screens/main/cubit/main_cubit.dart';
import '../constants/colors_const.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentPage = context.watch<MainCubit>().currentpage;
    return BottomNavigationBar(
      backgroundColor: ColorConst.kPrimaryColor,
      selectedItemColor: whiteColor,

      currentIndex: currentPage,
      type: BottomNavigationBarType.fixed,
      onTap: (v) => context.read<MainCubit>().pages(v),
      // fixedColor: ColorConst.kPrimaryColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.sms,
            color: currentPage == 0
                ? ColorConst.whiteColor
                : ColorConst.sliderColors,
            size: currentPage == 0 ? 35.h : 25.h,
          ),
          label: 'Sms',
          backgroundColor: Colors.greenAccent,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.folder,
            color: currentPage == 1
                ? ColorConst.whiteColor
                : ColorConst.sliderColors,
            size: currentPage == 1 ? 35.h : 25.h,
          ),
          label: 'Arxiv',
          backgroundColor: Colors.redAccent,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.send,
            color: currentPage == 2
                ? ColorConst.whiteColor
                : ColorConst.sliderColors,
            size: currentPage == 2 ? 35.h : 25.h,
          ),
          label: 'Yuborilganlar',
          backgroundColor: Colors.yellowAccent,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: currentPage == 3
                ? ColorConst.whiteColor
                : ColorConst.sliderColors,
            size: currentPage == 3 ? 35.h : 25.h,
          ),
          label: 'Sozlash',
          backgroundColor: Colors.redAccent,
        ),
      ],
    );
  }
}
