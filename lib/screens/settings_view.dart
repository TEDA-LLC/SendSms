import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(child: Padding(
        padding: EdgeInsets.all(40.0.r),
        child: Column(children: [
          TextFormField(),
          TextFormField(),
          TextFormField(),
          TextFormField(),
          TextFormField(),
          TextFormField(),
          TextFormField(),
          TextFormField(),
          TextFormField(),
          TextFormField(),
        ],),
      ),),
    );
  }
}
