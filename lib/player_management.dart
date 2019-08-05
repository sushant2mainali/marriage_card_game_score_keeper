import 'package:flutter/material.dart';
import 'package:marriage_game_scorekeeper/state_management.dart';
import 'package:provider/provider.dart';

List<String> random_names = ["Musa","Biralo","Kukur","Hatti","Gaida",
                              "Bheda", "Gai", "Bhaisi","Sungur","Kharayo",
                              "Gadha","Ghoda","Tattu","Bandel", "Badar",
                              "Singa","Bhakra","Sarpa","Jarayo","Bagh"];

class PlayerManagementTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game_state = Provider.of<GameState>(context);
      return Scaffold(
        body: createPlayerList(context),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Player',
          child: Icon(Icons.add),
            onPressed: () => add_player(context,game_state),
          ),
      );
  }

  void add_player(BuildContext context, GameState game_state)
  {
    if(!game_state.add_player(random_names[game_state.number_of_players%random_names.length]))
      showAlertDialog(context,"Max 20 players");
  }

  Widget createPlayerList(BuildContext context)
  {
    final game_state = Provider.of<GameState>(context);
    return ListView.builder(
      itemCount: game_state.number_of_players,
      itemBuilder: (context, position) {
        final item = game_state.player_list[position];
        
        return ListTile(
                leading: item.active?
                          IconButton(icon:Icon(Icons.check_box), onPressed: () {game_state.make_player_inactive(position);}):
                          IconButton(icon:Icon(Icons.check_box_outline_blank), onPressed: () {if(!game_state.make_player_active(position)) showAlertDialog(context, "Only 5 players at a time!");}),
                title: Text(item.name), //TextFormField(decoration:InputDecoration(border: InputBorder.none) , initialValue: item.name, onFieldSubmitted: (String newName){ game_state.update_player_name(position,newName);}),
                trailing: IconButton(icon:Icon(Icons.delete), onPressed:(){if(!game_state.delete_player(position)) showAlertDialog(context, "Cannot delete Player while game is in session!");}),
            );
      },
    );
  }



  showAlertDialog(BuildContext context, String text) {
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


