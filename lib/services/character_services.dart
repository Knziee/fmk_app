import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import '../models/character.dart';

class CharacterService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final logger = Logger();

  Future<List<Character>> fetchRandomCharactersByValues({
    required String categoryId,
    required String gender,
  }) async {
    final snapshot = await _dbRef.child(categoryId).get();

    if (!snapshot.exists) {
      logger.w('⚠️ Nothing found.');
      return [];
    }

    final data = snapshot.value as Map<dynamic, dynamic>;
    final List<Character> allCharacters = [];

    if (data['items'] != null) {
      final itemsMap = data['items'] as Map<dynamic, dynamic>;

      for (var item in itemsMap.values) {
        final character = Character.fromMap(item);

        if (gender == 'both' || character.gender == gender) {
          allCharacters.add(character);
        }
      }
    }

    if (allCharacters.isEmpty) {
      logger.w('⚠️ Nothing found.');
    }

    allCharacters.shuffle(Random());
    return allCharacters.take(3).toList();
  }

  Future<void> incrementVote(
    String categoryId,
    String characterId,
    String voteType,
  ) async {
    final voteRef = _dbRef.child(
      '$categoryId/items/$characterId/votes/$voteType',
    );

    await voteRef.runTransaction((currentData) {
      final current = (currentData as int?) ?? 0;
      return Transaction.success(current + 1);
    });
  }
}
