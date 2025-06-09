import 'package:flutter/foundation.dart';
import '../models/character.dart';

class UserSelection extends ChangeNotifier {
  String? selectedGender;
  String? selectedCategoryId;
  List<Character> selectedCharacters = [];
  Character? fChoice;
  Character? mChoice;
  Character? kChoice;
  int? avatarIndex;
  String? nickname;
  String gameMode = 'single';

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

  void selectCharacter(String type, Character character) {
    switch (type) {
      case 'f':
        fChoice = character;
        break;
      case 'm':
        mChoice = character;
        break;
      case 'k':
        kChoice = character;
        break;
    }

    notifyListeners();
  }

  void moveCharacter(String characterId, String newType) {
    if (fChoice?.id == characterId) fChoice = null;
    if (mChoice?.id == characterId) mChoice = null;
    if (kChoice?.id == characterId) kChoice = null;

    final character = selectedCharacters.firstWhere(
      (c) => c.id == characterId,
      orElse: () => throw Exception('Character not found'),
    );

    selectCharacter(newType, character);
  }

  String? getCharacterType(String characterId) {
    if (fChoice?.id == characterId) return 'f';
    if (mChoice?.id == characterId) return 'm';
    if (kChoice?.id == characterId) return 'k';
    return null;
  }

  void removeCharacter(String type) {
    switch (type) {
      case 'f':
        fChoice = null;
        break;
      case 'm':
        mChoice = null;
        break;
      case 'k':
        kChoice = null;
        break;
    }
    notifyListeners();
  }

  void resetSelections() {
    fChoice = null;
    mChoice = null;
    kChoice = null;
    notifyListeners();
  }

  void setAvatarIndex(int index) {
    avatarIndex = index;
    notifyListeners();
  }

  void setNickname(String name) {
    nickname = name;
    notifyListeners();
  }

  void setGameMode(String mode) {
    gameMode = mode;
    notifyListeners();
  }
}
