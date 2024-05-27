import 'package:flutter/material.dart';

class AddScreenProvider extends ChangeNotifier{
  DateTimeRange dateRange;
  DateTimeRange extendsDateRage;
  String foodTime;
  AddScreenProvider({required this.dateRange, required this.foodTime,required this.extendsDateRage});
  void setParticularrDate(int date){
    dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: date)));
    notifyListeners();
  }
  void setDate(DateTimeRange dateTimeRange){
    dateRange = dateTimeRange;
    notifyListeners();
  }

  void setFoodTime(String foodTime){
    this.foodTime = foodTime;
    notifyListeners();
  }
  void setExtendsDate(DateTimeRange dateTimeRange){
    extendsDateRage = dateTimeRange;
    notifyListeners();
  }
}