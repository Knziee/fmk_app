import 'package:flutter/foundation.dart';

class UserSelection extends ChangeNotifier {
  String? selectedGender;
  String? selectedCategoryTitle;

  void setGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void setCategory(String title, String emoji) {
    selectedCategoryTitle = title;
    notifyListeners();
  }
}
