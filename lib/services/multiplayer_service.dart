import 'package:firebase_database/firebase_database.dart';
import '../models/character.dart';
import '../models/player.dart';
import '../utils/code_generator.dart';

class JoinLobbyResult {
  final bool success;
  final String? categoryId;
  final String? gender;

  JoinLobbyResult({required this.success, this.categoryId, this.gender});
}

class MultiplayerService {
  final db = FirebaseDatabase.instance.ref();

  Future<String> createLobby(
    Player player,
    String categoryId,
    String gender,
  ) async {
    final code = generateLobbyCode();

    await db.child('lobbies/$code').set({
      'createdAt': ServerValue.timestamp,
      'isStarted': false,
      'categoryId': categoryId,
      'gender': gender,
    });

    final hostPlayer = Player(
      id: player.id,
      nickname: player.nickname,
      avatarId: player.avatarId,
      choices: player.choices,
      ready: player.ready,
      isHost: true,
    );

    await db
        .child('lobbies/$code/players/${hostPlayer.id}')
        .set(hostPlayer.toMap());

    return code;
  }

  Future<JoinLobbyResult> joinLobby(String code, Player player) async {
    final snapshot = await db.child('lobbies/$code').get();
    if (!snapshot.exists) return JoinLobbyResult(success: false);

    final lobbyData = snapshot.value as Map<dynamic, dynamic>;
    final categoryId = lobbyData['categoryId'] as String?;
    final gender = lobbyData['gender'] as String?;

    await db.child('lobbies/$code/players/${player.id}').set(player.toMap());

    return JoinLobbyResult(
      success: true,
      categoryId: categoryId,
      gender: gender,
    );
  }

  Future<void> updateChoices(
    String code,
    String userId,
    Map<String, String> choices,
  ) async {
    await db.child('lobbies/$code/players/$userId/choices').set(choices);
  }

  Future<void> setReady(String code, String userId, bool ready) async {
    await db.child('lobbies/$code/players/$userId/ready').set(ready);
  }

  Stream<List<Player>> watchPlayers(String code) {
    return db.child('lobbies/$code/players').onValue.map((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.entries
          .map((e) => Player.fromMap(e.key, Map<String, dynamic>.from(e.value)))
          .toList();
    });
  }

  Stream<bool> watchAllPlayersVoted(String code) {
    return FirebaseDatabase.instance.ref('lobbies/$code/players').onValue.map((
      event,
    ) {
      final playersMap = event.snapshot.value as Map<dynamic, dynamic>?;

      if (playersMap == null) return false;

      final allVoted = playersMap.values.every((p) {
        final player = p as Map<dynamic, dynamic>;
        final choices = player['choices'] as Map<dynamic, dynamic>?;

        return choices != null &&
            choices['f'] != null &&
            choices['marry'] != null &&
            choices['kill'] != null;
      });

      return allVoted;
    });
  }

  Future<List<Player>> getFinalLobbyData(String code) async {
    final snapshot = await db.child('lobbies/$code/players').get();
    if (!snapshot.exists) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return data.entries.map((e) {
      final playerData = Map<String, dynamic>.from(e.value);
      return Player.fromMap(e.key, playerData);
    }).toList();
  }

  Future<void> resetReadyAndChoicesForAllPlayers(String lobbyCode) async {
    final playersSnapshot = await db.child('lobbies/$lobbyCode/players').get();
    if (!playersSnapshot.exists) return;

    final playersMap = Map<String, dynamic>.from(playersSnapshot.value as Map);

    Map<String, Object?> updates = {};

    playersMap.forEach((playerId, playerData) {
      updates['$playerId/ready'] = null;
      updates['$playerId/choices'] = null;
    });

    await db.child('lobbies/$lobbyCode/players').update(updates);
  }

  Future<void> removePlayerFromLobby(String lobbyCode, String playerId) async {
    await db.child('lobbies/$lobbyCode/players/$playerId').remove();
  }

  Future<void> saveRandomCharacters(
    String lobbyCode,
    List<Character> characters,
  ) async {
    Map<String, dynamic> characterToMap(Character c) {
      return {
        'id': c.id,
        'name': c.name,
        'imageUrl': c.imageUrl,
        'gender': c.gender,
        'votes': c.votes,
      };
    }

    final characterMaps = characters.map(characterToMap).toList();
    await db.child('lobbies/$lobbyCode/characters').set(characterMaps);
  }

  Future<List<Character>> fetchLobbyCharacters(String lobbyCode) async {
    final snapshot = await db.child('lobbies/$lobbyCode/characters').get();
    if (!snapshot.exists) return [];

    final data = snapshot.value as List<dynamic>;
    return data.map((item) {
      final map = Map<String, dynamic>.from(item);
      return Character.fromMap(map);
    }).toList();
  }

  // Stream<List<Character>> watchLobbyCharacters(String lobbyCode) {
  //   return db.child('lobbies/$lobbyCode/characters').onValue.map((event) {
  //     final data = event.snapshot.value;
  //     if (data == null) return <Character>[];

  //     final listData = data as List<dynamic>;
  //     return listData.map((item) {
  //       final map = Map<String, dynamic>.from(item);
  //       return Character.fromMap(map);
  //     }).toList();
  //   });
  // }

  Future<void> setHost(String lobbyCode, String playerId) async {
    final playersRef = db.child('lobbies/$lobbyCode/players');

    final snapshot = await playersRef.get();
    if (!snapshot.exists) return;

    final playersData = snapshot.value as Map<dynamic, dynamic>;

    final updates = <String, dynamic>{};
    playersData.forEach((key, value) {
      updates['$key/isHost'] = (key == playerId);
    });

    await playersRef.update(updates);
  }
}
