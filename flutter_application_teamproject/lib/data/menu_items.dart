import 'package:flutter_application_teamproject/model/meun_item.dart';
import 'package:flutter/material.dart';


class MenuItems{
  static const itemSetting = MenuItem(
    text: 'Setting', 
    icon:Icons.settings
    );

  static const itemShare = MenuItem(
    text: 'Share', 
    icon:Icons.share
    );

  static const itemSignout = MenuItem(
    text: 'Signout', 
    icon:Icons.logout
    );

   static const List<MenuItem> itemFirst =[
    itemSetting,
    itemShare
  ];

  static const List<MenuItem> itemSecond =[
    itemSignout
  ];
}