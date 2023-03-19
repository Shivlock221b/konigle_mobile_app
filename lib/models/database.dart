import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:konigle_mobile_app/models/userModel.dart';

class Database {
  static List<User> _db = [];

  static Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? users = prefs.getString('users');
    if (users != null) {
      Iterable decoded = jsonDecode(users);
      _db = decoded.map((user) => User.fromJson(user)).toList();
    } else {
      _db = [
        User(id: 1, name: "Shivam Tiwari", email: "shivam.desire1@gmail.com", password: "1234567890")
      ];
    }
  }

  Future<Map> setUser(User user) async {
    Map response = {
      "status": 200,
      "message" : "Success"
    };
    if (checkUsernameExists(user.name)) {
      response['status'] = 400;
      response['message'] = "Username already exists";
      return response;
    }
    if (checkEmailExists(user.email)) {
      response['status'] = 400;
      response['message'] = "Email address already exists";
      return response;
    }
    _db.add(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String users = jsonEncode(_db);
    prefs.setString('users', users);
    return response;
  }

  dynamic getUser(String userName, String password) {
    for (User user in _db) {
      if (user.name == userName && user.password == password) {
        return user;
      }
    }
    return null;
  }

  static dynamic getUserByIndex(int index) {
    return _db.firstWhere((element) => element.id == index);
  }

  void updateUser(User user, int index) async {
    _db.insert(index, user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String users = jsonEncode(_db);
    prefs.setString('users', users);
  }

  int getLength() {
    return _db.length;
  }

  bool checkUsernameExists(String userName) {
    for (User user in _db) {
      if (user.name == userName) {
        return true;
      }
    }
    return false;
  }

  bool checkEmailExists(String email) {
    for (User user in _db) {
      if (user.email == email) {
        return true;
      }
    }
    return false;
  }

  void printDb() {
    for (User user in _db) {
      print(user);
    }
  }

  void resetDb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _db = [];
  }
}
