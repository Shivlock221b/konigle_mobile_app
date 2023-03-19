import 'package:flutter/material.dart';
import 'package:konigle_mobile_app/models/userModel.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  User? user;

  setCurrentUser(User user) {
    this.user = user;
    notifyListeners();
  }

  markSectionAsComplete(int chapter, String section) {
    for (dynamic elem in user!.chapterProgress!) {
      if (elem['chapterId'] == chapter) {
        elem["sectionProgress"].add(section);
      }
    }
  }

}