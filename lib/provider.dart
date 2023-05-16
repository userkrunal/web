import 'package:flutter/foundation.dart';

class WebProvider extends ChangeNotifier
{
  double p1=0;

  void changprogress(double updated)
  {
    p1=updated;
    notifyListeners();
  }
}