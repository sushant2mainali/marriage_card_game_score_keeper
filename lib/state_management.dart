import 'package:flutter/foundation.dart';

class Player{
  String name;
  bool active;
  List<int> score_card;

  Player(String name, int score_card_length){
    this.name = name;
    this.active = false;
    this.score_card = new List();

    for(int i = 0; i<score_card_length; i++)
      this.score_card.add(0);
  }

  String get player_name{
    return this.name;
  }

  void set player_name(String name){
    this.name = name;
  }

  void set player_active(bool active){
    this.active = active;
  }

  bool get player_active{
    return this.active;
  }

  void delete_score_card(int index)
  {
    this.score_card.removeAt(index);
  }

  void add_new_score_card()
  {
    this.score_card.add(0);
  }

  int get_score_card_at(int index)
  {
    return this.score_card[index];
  }

  void increment_score_card_at(int index, int value)
  {
    this.score_card[index] = this.score_card[index] + value;
  }

  List<int> get entire_score_card
  {
    return this.score_card;
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

  Game(List<int> players, List<bool> seen, List<int> points, int winner, bool dubli)
  {
    this.players = players;
    this.seen = seen;
    this.winner = winner;
    this.points = points;
    this.dubli = dubli;
    this.calculated_score = List();
  }

  Game.empty(int l)
  {
    this.players = List(l);
    this.seen = List(l);
    this.points = List(l);
    this.dubli = false;
    this.calculated_score = List();

    for(int i=0;i<l;i++)
    {
      this.seen[i] = false;
      this.points[i] = 0;
      this.players[i] = 0;
    }
  }
}

class GameState with ChangeNotifier{

  List<Player> player_list;
  List<Game> game_list;
  bool game_in_session;
  Game game_buffer;

  GameState()
  {
    this.player_list = new List();
    this.game_list = new List();
    this.game_in_session = false;
  }

  int get number_of_games{
    return this.game_list.length;
  }

  int get number_of_players{
    int i = 0;
    this.player_list.forEach((f)=> i++);
    return i;
  }

  List<Player> get players{
    return this.player_list;
  }

  int get number_of_active_players{
    int act_players = 0;

    for(int i=0;i<this.player_list.length;i++){
      if(player_list[i].player_active) act_players++;
    }
    return act_players;
  }

  bool delete_player(int index){

    if(!this.game_in_session) {
      this.player_list.removeAt(index);
      //remove score from every player
      for (int i = 0; i < this.player_list.length; i++)
        this.player_list[i].delete_score_card(index);
    }
    else
      {
        return false;
      }

    notifyListeners();
    return true;
  }

  bool add_player(String name)
  {
    if(this.player_list.length >= 20)
      return false;

    //add new score card to every player
    for(int i = 0;i<this.player_list.length;i++)
      this.player_list[i].add_new_score_card();

    Player new_player = Player(name,this.player_list.length+1);
    this.player_list.add(new_player);

    notifyListeners();

    return true;
  }

  bool update_player_name(int index, String name)
  {
    if(this.player_list.length <index)
      return false;

    this.player_list[index].name=name;
    notifyListeners();
    return true;
  }

  bool make_player_active(int index)
  {
    if(this.number_of_active_players >= 5 || this.player_list.length<index)
      return false;
    this.player_list[index].player_active = true;
    notifyListeners();
    return true;
  }

  bool make_player_inactive(int index)
  {
    if(this.player_list.length < index)
      return false;
    this.player_list[index].player_active = false;
    notifyListeners();
    return true;
  }

  bool switch_player_active_state(int index)
  {
    if(this.player_list.length < index)
      return false;
    this.player_list[index].player_active = !this.player_list[index].player_active;
    notifyListeners();
    return true;
  }

  void print_score_matrix()
  {
    for(int i = 0;i<this.player_list.length; i++)
      print(this.player_list[i].entire_score_card);
  }

  // Guide from https://www.pagat.com/rummy/marriage.html
  void process_scores(Game g)
  {
    int T = 0; // total
    int n = g.players.length; // number of players

    for(int i = 0;i<g.points.length;i++)
    {
      if( g.seen[i])
        {
          T += g.points[i];
        }
      else
        {
          g.points[i] = 0;
        }
    }


    // calculate score for each person and update chart
    for(int i = 0;i<g.players.length;i++)
      {
        int player_id = g.players[i];
        if( player_id != g.winner) // everyone except winner
        {
            int W = g.seen[i]?3:10; //if seen, then 10 else 3
            W += g.dubli?5:0;
            int S = g.points[i];
            int points = T+W-(n*S);
            g.calculated_score.add(points);
            if(points < 0) // then winners pays this person
              this.player_list[g.winner].increment_score_card_at(player_id,points.abs() );
            else
              this.player_list[player_id].increment_score_card_at(g.winner,points);
        }
        else
          {
            g.calculated_score.add(0); // this is for same person. Doesn pay anything to self
          }
      }
  }

  List<int> get active_players_list{
    List<int> l = List();
    for(int i = 0;i<this.number_of_players;i++)
      {
        if(this.player_list[i].player_active)
          l.add(i);
      }
    return l;
  }


  Game add_new_game(List<int> players, List<bool> seen, List<int> points, int winner, bool dubli)
  {
    this.game_in_session = true;
    Game new_game= new Game(players, seen, points, winner, dubli);
    this.game_list.add(new_game);
    this.process_scores(new_game);
    return new_game; // this will have the calculated scores
  }

  Game add_new_game_gameType(Game g)
  {
    this.game_in_session = true;
    this.process_scores(g);
    this.game_list.add(g);
    notifyListeners();
    return g; // this will have the calculated scores
  }

  void delete_all_games()
  {
    for(int i = 0;i<this.player_list.length;i++)
      for(int j = 0;j<this.player_list[i].score_card.length;j++)
        this.player_list[i].score_card[j] = 0;

    game_list = new List();
    this.game_in_session = false;
    notifyListeners();
  }


  void recalculate_Score()
  {
    for(int i = 0;i<this.player_list.length;i++)
      for(int j = 0;j<this.player_list[i].score_card.length;j++)
        this.player_list[i].score_card[j] = 0;

    for(int i = 0; i<this.game_list.length;i++)
      {
        this.game_list[i].calculated_score = List(); // empty out the score list.
        this.process_scores(this.game_list[i]);
      }
  }

  void delete_single_game(int index)
  {
    this.game_list.removeAt(index);
    if(this.game_list.length == 0)
    {
      this.game_in_session = false;
    }

    this.recalculate_Score();

    notifyListeners();
  }


  List<Player> get list_of_players_with_payment{
    List<Player> l = List();
    for(int i=0;i<this.number_of_players;i++)
      {
        for(int j = 0;j<this.player_list[i].score_card.length;j++)
          {
            if(this.player_list[i].score_card[j] > 0)
              {
                l.add(this.player_list[i]);
                break; // of we found one, we should just stop.
              }
          }
      }

    return l;
  }

  int get count_of_players_with_payment{
    List<Player> l = this.list_of_players_with_payment;
    int len = 0;
    if(l != null)
      len = l.length;

    return len;
  }

}
