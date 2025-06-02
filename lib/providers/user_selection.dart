import 'package:flutter/foundation.dart';
import '../models/character.dart'; 

class UserSelection extends ChangeNotifier {
  String? selectedGender;
  String? selectedCategoryId;
  List<Character> selectedCharacters = [];

  void setGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void setCategory(String id) {
    selectedCategoryId = id;
    notifyListeners();
  }

  void setCharacters(List<Character> characters) {
    selectedCharacters = characters;
    notifyListeners();
  }
}
