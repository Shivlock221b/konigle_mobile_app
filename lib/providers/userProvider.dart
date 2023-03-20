import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:konigle_mobile_app/models/userModel.dart';
import 'package:provider/provider.dart';

import '../models/database.dart';

/**
 * ChangeNotifier Provider class to maintain state of the current User
 */

class UserProvider with ChangeNotifier {
  User? user;
  Database db = Database();

  setCurrentUser(User user) {
    this.user = user;
    notifyListeners();
  }

  markSectionAsComplete(int chapter, String section) {
    int? index;
    ChapterProgress chapterProgress = user!.chapterProgress!.firstWhere((element) => element.chapterId == chapter, orElse: () {ChapterProgress cp = ChapterProgress(chapterId: user!.chapterProgress!.length, sectionProgress: [section]); return cp;});
    if (user!.chapterProgress!.length == chapterProgress.chapterId) {
      user!.chapterProgress!.add(chapterProgress);
    } else {
      chapterProgress.sectionProgress!.add(section);
    }
    db.updateUser(user!, user!.id);
    notifyListeners();
  }
}