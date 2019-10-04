import 'package:flutter/foundation.dart';

final int MAX_PLAYERS = 20;

class Player
{
  String name;
  bool active;
  bool is_playing;
  int position;

  Player()
  {
    this.name = "";
    this.active = false;
    this.is_playing = false;
    this.position = -1;
  }
}

class Players
{
  var players = new List<Player>(MAX_PLAYERS);
  int number_of_players;

  Players()
  {
    for(int i = 0;i<MAX_PLAYERS;i++)
      {
        players[i] = new Player();
      }
    number_of_players = 0;
  }

  int get total_playing
  {
    int playing = 0;
    for(int i=0;i<MAX_PLAYERS;i++)
      {
        if(players[i].is_playing)
          playing++;
      }
    return playing;
  }

  int add_player(String name)
  {
    int to_return = -1;
    for(int i=0;i<MAX_PLAYERS;i++)
      {
        if(!players[i].active)
          {
            this.players[i].name = name;
            this.players[i].is_playing = false;
            this.players[i].active = true;
            this.players[i].position = this.number_of_players;
            this.number_of_players += 1;
            to_return = i;
            break;
          }
      }
    return to_return;
  }

  bool delete_player(int i)
  {
    if(this.players[i].active)
      {
        int curr_position = this.players[i].position;
        this.players[i] = new Player();
        this.number_of_players -= 1;

        //reduce the position of everyone after that by 1
        for(int x = 0;x<MAX_PLAYERS;x++)
          {
            if(this.players[x].position>0 && this.players[x].position>curr_position)
              {
                this.players[x].position -= 1;
              }
          }
        return true;
      }
    return false;
  }

  bool stop_playing_player(int i)
  {
    if(players[i].active && players[i].is_playing)
    {
      players[i].is_playing = false;
      return true;
    }
    return false;
  }

  bool start_playing_player(int i)
  {
    if(players[i].active && !players[i].is_playing && this.total_playing < 5)
    {
      players[i].is_playing = true;
      return true;
    }
    return false;
  }

  int get number_of_active_players
  {
    return this.number_of_players;
  }

  int index_of_player_at(int pos)
  {
    int ind = -1;
    for(int i=0;i<MAX_PLAYERS;i++)
      {
        if(this.players[i].position == pos)
          {
            ind = i;
            break;
          }
      }
    return ind;
  }

  bool is_playing(int i)
  {
    return players[i].is_playing;
  }

  String player_name(int i)
  {
    return players[i].name;
  }

  void update_player_name(int index, String name)
  {
    if(players[index].active)
      this.players[index].name = name;
  }
}


class Game
{
  List<int> players;
  List<bool> seen;
  int winner;
  List<int> points;
  bool dubli;
  List<int> calculated_score;

  Game.empty(int l)
  {
    this.players = List(l);
    this.seen = List(l);
    this.points = List(l);
    this.dubli = false;
    this.calculated_score = List(l);

    for(int i=0;i<l;i++)
    {
      this.seen[i] = false;
      this.points[i] = 0;
      this.players[i] = 0;
      this.calculated_score[i] = 0;
    }
  }

  Game(List<int> players, List<bool> seen, List<int> points, int winner, bool dubli)
  {
    this.players = players;
    this.seen = seen;
    this.winner = winner;
    this.points = points;
    this.dubli = dubli;
    this.calculated_score = List(this.players.length);
    this.calculate_score();
  }

  List<int> calculate_score()
  {
    for(int i = 0;i<this.players.length;i++)
      {
        this.calculated_score[i] = 10;
      }
  }
}

class ScoreCard
{
  List<Game> games;

  void add_game(Game g)
  {
    this.games.add(g);
  }

  int number_of_games()
  {
    return this.games.length;
  }

}


class GameState with ChangeNotifier
{
  Players all_players;
  ScoreCard score_card;

  GameState()
  {
    all_players = new Players();
    score_card = new ScoreCard();
  }

  int add_player(String name)
  {
    int id =  all_players.add_player(name);
    if( id != -1)
      notifyListeners();
    return id;

  }

  int get number_of_players{
    return this.all_players.number_of_active_players;
  }

  int index_of_player_at(int position)
  {
    return this.all_players.index_of_player_at(position);
  }

  void set_not_playing(int i)
  {
    this.all_players.stop_playing_player(i);
    notifyListeners();
  }

  bool set_playing(int i)
  {
    bool to_ret =  this.all_players.start_playing_player(i);
    if(to_ret)
      notifyListeners();
    return to_ret;
  }

  bool is_playing(int index)
  {
    return this.all_players.is_playing(index);
  }

  String get_player_name(int index)
  {
    return this.all_players.player_name(index);
  }

  bool delete_player(int index)
  {
    bool to_ret =  this.all_players.delete_player(index);
    if(to_ret)
      notifyListeners();
    return to_ret;
  }

  void update_player_name(int index, String name)
  {
    this.all_players.update_player_name(index, name);
    notifyListeners();
  }
}


