// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_management.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return Player()
    ..name = json['name'] as String
    ..active = json['active'] as bool
    ..is_playing = json['is_playing'] as bool
    ..position = json['position'] as int;
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'name': instance.name,
      'active': instance.active,
      'is_playing': instance.is_playing,
      'position': instance.position,
    };

Players _$PlayersFromJson(Map<String, dynamic> json) {
  return Players()
    ..players = (json['players'] as List)
        ?.map((e) =>
            e == null ? null : Player.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..number_of_players = json['number_of_players'] as int;
}

Map<String, dynamic> _$PlayersToJson(Players instance) => <String, dynamic>{
      'players': instance.players,
      'number_of_players': instance.number_of_players,
    };

Game _$GameFromJson(Map<String, dynamic> json) {
  return Game(
    (json['players'] as List)?.map((e) => e as int)?.toList(),
    (json['seen'] as List)?.map((e) => e as bool)?.toList(),
    (json['points'] as List)?.map((e) => e as int)?.toList(),
    json['winner'] as int,
    json['dubli'] as bool,
  )
    ..calculated_score =
        (json['calculated_score'] as List)?.map((e) => e as int)?.toList()
    ..summary_game = json['summary_game'] as bool;
}

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'players': instance.players,
      'seen': instance.seen,
      'winner': instance.winner,
      'points': instance.points,
      'dubli': instance.dubli,
      'calculated_score': instance.calculated_score,
      'summary_game': instance.summary_game,
    };

ScoreCard _$ScoreCardFromJson(Map<String, dynamic> json) {
  return ScoreCard()
    ..games = (json['games'] as List)
        ?.map(
            (e) => e == null ? null : Game.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..score_grid = (json['score_grid'] as List)
        ?.map((e) => (e as List)?.map((e) => e as int)?.toList())
        ?.toList();
}

Map<String, dynamic> _$ScoreCardToJson(ScoreCard instance) => <String, dynamic>{
      'games': instance.games,
      'score_grid': instance.score_grid,
    };

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  return GameState()
    ..all_players = json['all_players'] == null
        ? null
        : Players.fromJson(json['all_players'] as Map<String, dynamic>)
    ..score_card = json['score_card'] == null
        ? null
        : ScoreCard.fromJson(json['score_card'] as Map<String, dynamic>)
    ..amount_per_point = (json['amount_per_point'] as num)?.toDouble();
}

Map<String, dynamic> _$GameStateToJson(GameState instance) => <String, dynamic>{
      'all_players': instance.all_players,
      'score_card': instance.score_card,
      'amount_per_point': instance.amount_per_point,
    };
