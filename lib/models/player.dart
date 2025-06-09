class Player {
  final String id;
  final String nickname;
  final int avatarId;
  final Map<String, String> choices;
  final bool ready;
  bool isHost;

  Player({
    required this.id,
    required this.nickname,
    required this.avatarId,
    required this.choices,
    required this.ready,
    this.isHost = false,
  });

  Map<String, dynamic> toMap() => {
    'nickname': nickname,
    'avatarId': avatarId,
    'choices': choices,
    'ready': ready,
    'isHost': isHost,
  };

  factory Player.fromMap(String id, Map data) {
    return Player(
      id: id,
      nickname: data['nickname'],
      avatarId: data['avatarId'],
      choices: Map<String, String>.from(data['choices'] ?? {}),
      ready: data['ready'] ?? false,
      isHost: data['isHost'] ?? false,
    );
  }
}
