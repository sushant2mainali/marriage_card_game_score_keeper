import 'package:flutter/material.dart';
import 'package:marriage_game_scorekeeper/state_management.dart';
import 'package:provider/provider.dart';



class GameManagementTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GameManagementTabState();
  }
}

class GameManagementTabState extends State<GameManagementTab> {
  @override
  Widget build(BuildContext context) {
    final game_state = Provider.of<GameState>(context);
    return Scaffold(
        body: createGameList(context),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(
                  label:Text("Clear All"),
                  icon: Icon(Icons.fiber_new),
                  onPressed: ()  => deleteAll(context,game_state)),
              FlatButton.icon(
                  label:Text("Add Game"),
                  icon: Icon(Icons.add),
                  onPressed: () { addNewGame(context, game_state); } ),
            ],
          ),
        )
    );
  }

  void addNewGame(BuildContext context, GameState game_state)
  {
    int num_of_players = game_state.number_of_playing_players;
    if( num_of_players >= 2)
    {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>NewGamePage(game_data: new Game.empty(num_of_players),),
        ),
      );
    }
    else
    {
      showAlertDialog(context,"Message","Dui jaana chaincha game khelna. Players ma gaera dui jaana ko naam agadi check lagaunus. Bhaneko bujhnu bhaena bhane ali raksi kaam garne bela bhaecha!");
    }

  }

  Widget createGameList(BuildContext context)
  {
    final game_state = Provider.of<GameState>(context);

    if(game_state.number_of_games() > 0)
    {
      return ListView.builder(
        itemCount: game_state.number_of_games(),
        itemBuilder: (context, position) {
          final item = game_state.game_at_index(position);
          String winner = game_state.get_player_name(item.winner);
          String game_number = (position + 1).toString();
          String hisab_kitab = "Hisab Kitab:\n";
          for (int i = 0; i < item.players.length; i++) {
            if (item.calculated_score[i] > 0) {
              hisab_kitab +=
                  game_state.get_player_name(item.players[i]) + " Pays " +
                      game_state.get_player_name(item.winner) + " " +
                      item.calculated_score[i].toString() + "\n";
            }
            else if (item.calculated_score[i] <
                0) // this means winner pays the other person
                {
              hisab_kitab +=
                  game_state.get_player_name(item.winner) + " Pays " +
                      game_state.get_player_name(item.players[i]) + " " +
                      item.calculated_score[i].abs().toString() + "\n";
            }
          }

          return ListTile(
            leading: Text("Game - $game_number"),
            title: Text("Winner: $winner"),
            subtitle: Text("$hisab_kitab"),
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
              game_state.delete_single_game(position);
            }),
          );
        },
      );
    }
    else
      {
        var _w;
        if(game_state.number_of_playing_players >= 2)
          _w =           GestureDetector(
              onTap: () {addNewGame(context, game_state);},
              child: Text("Click here to add a new Game.\n", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)));
        else
          _w = Text("Go to \"Players\" tab to add and select atleast 2 players!\n", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),);

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/game_back.png', height: 200.0,
              ),
              Text("\n"),
              Text("You have not added any games yet!\n", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              _w,
            ],
          ),
        );
      }
  }

  showAlertDialog(BuildContext context, String title, String text) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop();},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deleteAll(BuildContext context, GameState game_state) async
  {
    if(game_state.number_of_games() > 0)
    {
      String deleteAllConfirm = await showDeleteAllDialog(context);
      if(deleteAllConfirm == "Ok")
      {
        game_state.delete_all_games();
        showAlertDialog(context,"Message","Sabai game haru suhaaaa!");
      }
    }
    else
    {
      showAlertDialog(context,"Message","Eutai game kheleko chaina, k delete garnu?Achamma cha ba!");
    }
  }

  Future<String> showDeleteAllDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text("Sabai Delete Garne nai ho ta?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Delete All'),
              onPressed: () {
                Navigator.of(context).pop("Ok");
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop("");
              },
            ),
          ],
        );
      },
    );
  }
}


class NewGamePage extends StatefulWidget {
  final Game game_data;

  NewGamePage({Key key, @required this.game_data}) : super(key: key);

  @override
  AddGameScreenState createState() => new AddGameScreenState();
}


class AddGameScreenState extends State<NewGamePage> {

  String error_message = "";
  List<TextEditingController> score_input_controller = List(5);

  @override
  void initState() {
    super.initState();

    for(int i=0;i<5;i++)
    {
      score_input_controller[i] = TextEditingController();
    }

  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    for(int i=0;i<5;i++)
      score_input_controller[i].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game_state = Provider.of<GameState>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new Game"),
        ),
        body: Container(child: ListView(children: createNewGameForm(context),
            padding: const EdgeInsets.all(20.0)),
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(
                  label:Text("Cancel"),
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    Navigator.pop(context);
                    //_showModal();
                  }),
              FlatButton.icon(
                  label:Text("Save"),
                  icon: Icon(Icons.save),
                  onPressed: () {
                    //_showModal();
                    if(validate_newGame())
                    {
                      game_state.add_new_game(widget.game_data);
                      Navigator.pop(context);
                    }
                  }),
            ],
          ),
        )
    );
  }

  List<Widget> createNewGameForm(BuildContext context)
  {
    final game_state = Provider.of<GameState>(context);
    widget.game_data.players = game_state.playing_players_list;

    List<Row> rows = List(widget.game_data.players.length+1);

    int row_index = 1; // row index 0 is reserved for the heading
    for(int i = 0; i<widget.game_data.players.length;i++)
    {
      String image_name = "assets/image"+widget.game_data.players[i].toString()+".png";
      rows[row_index] = Row(
        children: <Widget>[
          new Container(width: 30, child:CircleAvatar(backgroundImage: AssetImage(image_name))),
          new Container(width: 10, child:Text(" ")),
          new Container(width: 70, child:Text(game_state.get_player_name(widget.game_data.players[i]))),
          new Container(width: 60, child:Radio(value : widget.game_data.players[i], groupValue: widget.game_data.winner, onChanged: (int newValue) {setState(() {widget.game_data.winner = newValue;widget.game_data.seen[i] = true;});})),
          new Container(width: 60, child:Checkbox(value: widget.game_data.seen[i],  onChanged: (bool newValue) {setState(() {if(widget.game_data.winner != widget.game_data.players[i]) widget.game_data.seen[i] = newValue;});} )),
          new Container(width: 60, child:TextField(controller: score_input_controller[i])),
          //new Container(width: 70, child:TextField(onChanged: (String newValue) {setState(() {widget.game_data.points[i] = int.parse(newValue);});}, keyboardType:TextInputType.numberWithOptions()))
        ],
      );
      row_index++;
    }

    rows[0] = Row( children: <Widget>[
      new Container(width: 40, child:Text("")),
      new Container(width: 70, child:Text("Name",style: TextStyle(fontWeight: FontWeight.bold,))),
      new Container(width: 60, child:Text("Winner",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center)),
      new Container(width: 60, child:Text("Seen",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center)),
      new Container(width: 60, child:Text("Score",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center)),
    ]);
    return rows;
  }

  bool validate_newGame()
  {
    error_message = "";
    // for now, we only have to check if all scores are numbers
    // other error conditions are not possible.
    // In the future may be we have to check if winner and seen are both selected or not
    // atleast 1 winner is selected, etc.
    // for now, the UI is setup in such a way that no error inputs are possible except actual inputs
    //check if atleast one winner and winner is among playing players

    if(!widget.game_data.players.contains(widget.game_data.winner))
    {
      showAlertDialog(context,"Yo game ma winner nai thiena? Ki khelna aaudaina? Ki raksi dher bhayo?");
      return false;
    }

    for(int i = 0;i<widget.game_data.players.length;i++)
    {
      int a;
      if(score_input_controller[i].text == "" || score_input_controller[i].text == null)
        a = 0;
      else
      {
        a = int.tryParse(score_input_controller[i].text);
        if(a == null)
        {
          showAlertDialog(context,"Points ko thau ma number matra halna milcha. Tetti pani tha chaina?");
          return false;
        }
      }
      widget.game_data.points[i] = a.abs();
    }

    return true;
  }

  showAlertDialog(BuildContext context,String text) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop();},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(text),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

