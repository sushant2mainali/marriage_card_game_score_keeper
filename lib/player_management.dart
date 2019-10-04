import 'package:flutter/material.dart';
import 'package:marriage_game_scorekeeper/state_management.dart';
import 'package:provider/provider.dart';

class PlayerManagementTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game_state = Provider.of<GameState>(context);
    return Scaffold(
      body: createPlayerList(context),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Player',
        child: Icon(Icons.add),
        onPressed: () => add_player(context, game_state),
      ),
    );
  }

  void add_player(BuildContext context, GameState game_state) async {
    final String name = await showInputNameDialog(context, "");
    if(name.length > 0)
      {
        if (game_state.add_player(name) == -1)
          showAlertDialog(context, "Max 20 players");
      }
  }

  void update_player_name(BuildContext context, GameState game_state, int index) async {
    final String name = await showInputNameDialog(context, game_state.get_player_name(index));
    if(name.length > 0)
    {
      game_state.update_player_name(index,name);
    }
  }

  Widget createPlayerList(BuildContext context) {
    final game_state = Provider.of<GameState>(context);
    return ListView.builder(
      itemCount: game_state.number_of_players,
      itemBuilder: (context, position) {
        final index = game_state.index_of_player_at(position);

        return ListTile(
          leading: game_state.is_playing(index) ?
          IconButton(icon: Icon(Icons.check_box), onPressed: () {
            game_state.set_not_playing(index);
          }) :
          IconButton(icon: Icon(Icons.check_box_outline_blank), onPressed: () {
            if (!game_state.set_playing(index)) showAlertDialog(
                context, "Only 5 players at a time!");
          }),
          title: GestureDetector( onTap: () { update_player_name(context, game_state, index);},child: new Text(game_state.get_player_name(index)),),

          //TextFormField(decoration:InputDecoration(border: InputBorder.none) , initialValue: item.name, onFieldSubmitted: (String newName){ game_state.update_player_name(position,newName);}),
          trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
            if (!game_state.delete_player(index)) showAlertDialog(
                context, "Cannot delete Player while game is in session!");
          }),
        );
      },
    );
  }

  showAlertDialog(BuildContext context, String text) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
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

  Future<String> showInputNameDialog(BuildContext context, String initial_name) async {
    String player_name = initial_name;
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Player Name'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextFormField(
                    autofocus: true,
                    initialValue:initial_name,
                    decoration: new InputDecoration(
                        labelText: 'Player Name', hintText: 'eg. Hatti'),
                    onChanged: (value) {
                      player_name = value;
                    },
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(player_name);
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


