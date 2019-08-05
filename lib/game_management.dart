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
                  onPressed: () {
                    game_state.delete_all_games();
                    showAlertDialog(context,"Message","Deleted all Games!");
                  }),
              FlatButton.icon(
                  label:Text("Recalculate"),
                  icon: Icon(Icons.grid_on),
                  onPressed: () {
                    game_state.recalculate_Score();
                    showAlertDialog(context,"Message","Done Recalculating!");
                    //_showModal();
                  }),
              FlatButton.icon(
                  label:Text("Add Game"),
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if(game_state.number_of_active_players >= 2)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>NewGamePage(game_data: new Game.empty(game_state.number_of_active_players),),
                          ),
                        );
                      }
                    else
                      {
                        showAlertDialog(context,"Message","Atleast 2 players needed to play a game!");
                      }

                  }),
            ],
          ),
        )
    );
  }


  Widget createGameList(BuildContext context)
  {
    final game_state = Provider.of<GameState>(context);
    return ListView.builder(
      itemCount: game_state.number_of_games,
      itemBuilder: (context, position) {
        final item = game_state.game_list[position];
        String winner = game_state.player_list[item.winner].player_name;
        String game_number = (position+1).toString();
        String hisab_kitab = "";
        for(int i = 0; i< item.players.length; i++)
          {
            if(item.calculated_score[i] >0 )
              {
                hisab_kitab += game_state.player_list[item.players[i]].player_name + " Pays " +
                              game_state.player_list[item.winner].player_name + " "+item.calculated_score[i].toString() + "\n";
              }
          }
        return ListTile(
          leading: Text("$game_number:"),
          title:Text("Hisab Kitab:\n$hisab_kitab"),
          trailing: IconButton(icon:Icon(Icons.delete),  onPressed:(){game_state.delete_single_game(position);}),
        );
      },
    );
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
        body: Container(child: ListView(children: createNewGameForm(context) ,),
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
                      game_state.add_new_game_gameType(widget.game_data);
                      Navigator.pop(context);
                    }

                  }),
            ],
          ),
        )
    );
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
      showAlertDialog(context,"Please select a winner");
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
          showAlertDialog(context,"All points have to be numbers");
          return false;
        }
      }
      widget.game_data.points[i] = a.abs();
    }

    return true;
  }

  List<Widget> createNewGameForm(BuildContext context)
  {

    final game_state = Provider.of<GameState>(context);
    widget.game_data.players = game_state.active_players_list;

    List<Row> rows = List(widget.game_data.players.length+1);

    int row_index = 1; // row index 0 is reserved for the heading
    for(int i = 0; i<widget.game_data.players.length;i++)
    {
      rows[row_index] = Row(
        children: <Widget>[
          new Container(width: 70, child:Text(game_state.players[widget.game_data.players[i]].name)),
          new Container(width: 70, child:Radio(value : widget.game_data.players[i], groupValue: widget.game_data.winner, onChanged: (int newValue) {setState(() {widget.game_data.winner = newValue;widget.game_data.seen[i] = true;});})),
          new Container(width: 70, child:Checkbox(value: widget.game_data.seen[i],  onChanged: (bool newValue) {setState(() {if(widget.game_data.winner != widget.game_data.players[i]) widget.game_data.seen[i] = newValue;});} )),
          new Container(width: 70, child:TextField(controller: score_input_controller[i])),

          //new Container(width: 70, child:TextField(onChanged: (String newValue) {setState(() {widget.game_data.points[i] = int.parse(newValue);});}, keyboardType:TextInputType.numberWithOptions()))
        ],
      );
      row_index++;
    }

    rows[0] = Row( children: <Widget>[
      new Container(width: 70, child:Text("Name",style: TextStyle(fontWeight: FontWeight.bold,))),
      new Container(width: 70, child:Text("Winner",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center)),
      new Container(width: 70, child:Text("Seen",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center)),
      new Container(width: 70, child:Text("Score",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center)),
    ]);
    return rows;
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

