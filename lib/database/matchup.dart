class Matchup {
  final int id;
  final String winner;
  final String loser;

  const Matchup({
    required this.id,
    required this.winner,
    required this.loser,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'winner': winner,
      'loser': loser,
    };
  }

  factory Matchup.fromJson(Map<String, dynamic> json) =>
      Matchup(id: json['id'], winner: json['winner'], loser: json['loser']);

  Map<String, dynamic> toJson() => {'id': id, 'winner': winner, 'loser': loser};
}
