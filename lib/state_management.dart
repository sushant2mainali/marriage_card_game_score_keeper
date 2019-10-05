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

  int get number_of_playing_players
  {
    int num = 0;
    for(int i=0;i<MAX_PLAYERS;i++)
      {
        if(this.players[i].is_playing)
          num++;
      }
    return num;
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
  bool summary_game;

  Game.empty(int l)
  {
    this.players = List(l);
    this.seen = List(l);
    this.points = List(l);
    this.dubli = false;
    this.calculated_score = List<int>(l);
    this.summary_game = false;

    for(int i=0;i<l;i++)
    {
      this.seen[i] = false;
      this.points[i] = 0;
      this.players[i] = 0;
      this.calculated_score[i] = 0;
    }
  }

  Game.summary()
  {
    this.players = List();
    this.seen = List();
    this.points = List();
    this.dubli = false;
    this.calculated_score = List();
    this.summary_game = true;
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

  void calculate_score()
  {
    int T = 0; // total
    int n = this.players.length; // number of players

    for(int i = 0;i<n;i++)
    {
      if( this.seen[i])
      {
        T += this.points[i];
      }
      else
      {
        this.points[i] = 0; // if not seen, then score is 0 by default
      }
    }

    // calculate score for each person and update chart
    for(int i = 0;i<this.players.length;i++)
    {
      int player_id = this.players[i];
      if( player_id != this.winner) // everyone except winner
      {
        int W = this.seen[i]?3:10; //if seen, then 10 else 3
        W += this.dubli?5:0;
        int S = this.points[i];
        int points = T+W-(n*S);
        this.calculated_score[i] = points;
      }
      else
      {
        this.calculated_score[i] = 0;
      }
    }

  }
}

enum ScoreCardAction{ADD,REMOVE}

class ScoreCard
{
  List<Game> games;
  List<List<int>> score_grid = new List(MAX_PLAYERS);

  ScoreCard()
  {
    games = [];
    for(int i=0;i<MAX_PLAYERS;i++)
      {
        score_grid[i] = new List(MAX_PLAYERS);
        for(int j=0;j<MAX_PLAYERS;j++)
          score_grid[i][j] = 0;
      }
  }

  void add_game(Game g)
  {
    g.calculate_score();
    this.games.add(g);
    this.update_score_card(g,ScoreCardAction.ADD);
  }

  int number_of_games()
  {
    return this.games.length;
  }

  Game game_at_index(int index)
  {
    return this.games[index];
  }

  void delete_single_game(int index)
  {
    update_score_card(this.game_at_index(index), ScoreCardAction.REMOVE);
    this.games.removeAt(index);
  }

  void update_score_card(Game g, ScoreCardAction action)
  {
    for(int i=0;i<g.players.length;i++)
      {
        if(g.calculated_score[i] > 0 )
          {
            if(action == ScoreCardAction.ADD)
              this.score_grid[g.winner][g.players[i]] += g.calculated_score[i];
            else
              this.score_grid[g.winner][g.players[i]] -= g.calculated_score[i];
          }
        else if(g.calculated_score[i] < 0)
          {
            if(action == ScoreCardAction.ADD)
              this.score_grid[g.players[i]][g.winner] += g.calculated_score[i].abs();
            else
              this.score_grid[g.players[i]][g.winner] -= g.calculated_score[i].abs();
          }
      }
  }

  bool is_payment_remaining(int player_id)
  {
    for(int i=0;i<MAX_PLAYERS;i++)
      {
        if(this.score_grid[i][player_id] > 0 || this.score_grid[player_id][i] > 0)
          return true;
      }
    return false;
  }

  bool does_player_have_to_pay(int player_id)
  {
    for(int i=0;i<MAX_PLAYERS;i++)
    {
      if(this.score_grid[i][player_id] > 0)
        return true;
    }
    return false;
  }

  int get_amount_to_pay(int player_from, int player_to)
  {
    return this.score_grid[player_to][player_from];
  }

  void minimize_transactions()
  {
    int c = 1;
    while( c > 0)
      {
        c = 0;
        for(int i = 0;i<MAX_PLAYERS; i++)
          {
            for(int j = i+1; j<MAX_PLAYERS;j++)
              {
                if(this.score_grid[i][j] != 0)
                  {
                    for(int u = 0;u<MAX_PLAYERS;u++)
                      {
                        if(this.score_grid[j][u] != 0)
                          {
                            if( this.score_grid[j][u] > this.score_grid[i][j])
                              {
                                this.score_grid[i][u] += this.score_grid[i][j];
                                this.score_grid[j][u] -= this.score_grid[i][j];
                                this.score_grid[i][j] = 0;
                                c+=1;
                                break;
                              }
                            else
                              {
                                this.score_grid[i][u] += this.score_grid[j][u];
                                this.score_grid[i][j] -= this.score_grid[j][u];
                                this.score_grid[j][u] = 0;
                                c+=1;
                              }
                          }
                      }
                  }
              }
          }
        for(int x = 0;x<MAX_PLAYERS;x++)
          this.score_grid[x][x] = 0;
      }
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
    bool to_ret = false;
    if(!this.score_card.is_payment_remaining(index))
      {
        this.all_players.delete_player(index);
        to_ret = true;
      }

    if(to_ret)
      notifyListeners();
    return to_ret;
  }

  void update_player_name(int index, String name)
  {
    this.all_players.update_player_name(index, name);
    notifyListeners();
  }

  int get number_of_playing_players
  {
    return this.all_players.number_of_playing_players;
  }

  List<int> get playing_players_list{
    List<int> l = List();
    for(int i = 0;i<this.number_of_players;i++)
    {
      if(this.all_players.is_playing(i))
        l.add(i);
    }
    return l;
  }

  void add_new_game(Game g)
  {
    this.score_card.add_game(g);
    notifyListeners();
  }

  int number_of_games()
  {
    return this.score_card.number_of_games();
  }

  Game game_at_index(int index)
  {
    return score_card.game_at_index(index);
  }

  Game delete_single_game(int index)
  {
    this.score_card.delete_single_game(index);
    notifyListeners();
  }

  void delete_all_games()
  {
    this.score_card = new ScoreCard();
    notifyListeners();
  }

  int get max_players
  {
    return MAX_PLAYERS;
  }

  bool any_payments(int player_index)
  {
    return this.score_card.does_player_have_to_pay(player_index);
  }

  int get_amount_to_pay(int player_from, int player_to)
  {
    return this.score_card.get_amount_to_pay(player_from,player_to);
  }

  void minimize_transactions()
  {
    this.score_card.minimize_transactions();
    this.score_card.games = []; // deleting all games

    //Add one summary game
    Game g = Game.summary();
    this.add_new_game(g);

    notifyListeners();
  }
}


