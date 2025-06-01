import 'package:flutter/foundation.dart';

class UserSelection extends ChangeNotifier {
  String? selectedGender;
  String? selectedCategoryId;

  void setGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void setCategory(String id) {
    selectedCategoryId = id;
    notifyListeners();
  }
}
