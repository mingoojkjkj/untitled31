import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeSign with ChangeNotifier{
  bool _StandardSign = true;
  var _SelectedValue = int.parse('1');
  var _index = 0;

  bool getStandardSign() => _StandardSign;
  dynamic getSelectedVale() => _SelectedValue;
  dynamic getIndex() => _index;


  void Change_Sign(){
    _StandardSign = !_StandardSign;
    notifyListeners();
  }

  void ChangSelectedVale(int selectnum){
    _SelectedValue = selectnum;
    notifyListeners();
  }
}