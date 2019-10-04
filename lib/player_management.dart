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
    String name = await showInputNameDialog(context, "");
    if(name.length > 0)
      {
        name = name[0].toUpperCase() + name.substring(1); // converting first letter to uppercase
        if (game_state.add_player(name) == -1)
          showAlertDialog(context, "20 jaana bhanda halna mildaina. Dherai naam halera garna khojya k? Khelne bela 5 jaana ta ho max.");
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

    if(game_state.number_of_players > 0)
      {
        return ListView.builder(
          itemCount: game_state.number_of_players,
          itemBuilder: (context, position) {
            final index = game_state.index_of_player_at(position);
            String image_name = "assets/image$index.png";
            return ListTile(
              leading: game_state.is_playing(index) ?
              IconButton(icon: Icon(Icons.check_box), onPressed: () {
                game_state.set_not_playing(index);
              }) :
              IconButton(icon: Icon(Icons.check_box_outline_blank), onPressed: () {
                if (!game_state.set_playing(index)) showAlertDialog(
                    context, "Marriage ma ek palta ma 5 jaana matra khelna milcha! Khelna aaudaina bhane gaera bhura bhuri sita jutpatti khela hai!");
              }),
              title: Row(children:[CircleAvatar(backgroundImage: AssetImage(image_name)),Text("  "), GestureDetector( onTap: () { update_player_name(context, game_state, index);},child: new Text(game_state.get_player_name(index)),)]), //

              //TextFormField(decoration:InputDecoration(border: InputBorder.none) , initialValue: item.name, onFieldSubmitted: (String newName){ game_state.update_player_name(position,newName);}),
              trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
                String player_name = game_state.get_player_name(index);
                if (!game_state.delete_player(index)) showAlertDialog(
                    context, "Delete garna milena: $player_name ko hisab kitab baaki cha. Paisa na tiri bhagna mildaina!");
              }),
            );
          },
        );
      }
    else{
      var _w = GestureDetector(
          onTap: () {add_player(context, game_state);},
          child: Text("Click here to add a new Player.\n", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)));
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/players_back.png', height: 200.0,
            ),
            Text("\n"),
            Text("No players added!\n", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            _w
          ],
        ),
      );
    }

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
          title: Text('Kheladi ko naam'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextFormField(
                    autofocus: true,
                    initialValue:initial_name,
                    decoration: new InputDecoration(
                        labelText: 'Naam', hintText: 'eg. Hatti, Gaida, Sungur etc.'),
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


