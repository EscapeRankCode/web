import 'package:meta/meta.dart';
import 'escapist.dart';

class Review {
  final String? createdAt;
  final String? scoreAmbient;
  final String? scoreImmersion;
  final String? scoreStoryline;
  final String? scoreChallenges;
  final String? scoreFear;
  final String? scoreHistory;
  final String? scoreGameMaster;
  final String? avgScore;
  final String? review;
  final Escapist? escapist;

  Review({required this.createdAt, required this.scoreAmbient,required this.scoreImmersion, required this.scoreStoryline, required this.scoreChallenges,
    required this.scoreFear, required this.scoreHistory, required this.scoreGameMaster, required this.avgScore, required this.review,
    required this.escapist});

  factory Review.fromJson(Map<String, dynamic> json) {
    Escapist? escapist;
    if (json["escapist"] != null) {
      var userFromJson = json["escapist"] as Map<String, dynamic>;
      escapist = Escapist.fromJson(userFromJson);
    }

    return Review(
        createdAt : json["created_at"],
        scoreAmbient : json["score_ambient"] != null ? json["score_ambient"].toString() : null,
        scoreImmersion : json["score_immersion"] != null ? json["score_immersion"].toString() : null,
        scoreStoryline : json["score_storyline"] != null ? json["score_storyline"].toString() : null,
        scoreChallenges : json["score_challenges"] != null ? json["score_challenges"].toString() : null,
        scoreFear : json["score_fear"] != null ? json["score_fear"].toString() : null,
        scoreHistory : json["score_history"] != null ? json["score_history"].toString() : null,
        scoreGameMaster : json["score_game_master"] != null ? json["score_game_master"].toString() : null,
        avgScore : json["avg_score"] != null ? json["avg_score"].toString() : null,
        review : json["review"] != null ? json["review"].toString() : null,
        escapist : escapist
    );
  }

}