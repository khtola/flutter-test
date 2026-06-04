
import 'package:first_app/cart_screen.dart';
import 'package:first_app/styles/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget widgetButtom(BuildContext context, {required Function onClick, Function? onClick1}){
  return Container(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(width: 130,child: CupertinoButton(onPressed:() => onClick(), color: AppColor().textColors,padding: EdgeInsets.zero,child: Text("Button 1", style: TextStyle(color: Colors.black),),),),
        SizedBox(width: 130,child: CupertinoButton(onPressed: () => onClick1!(), color: AppColor().textColors,padding: EdgeInsets.zero,child: Text("Button 2", style: TextStyle(color: Colors.black),),),),
      ],
    ),
  );
}



