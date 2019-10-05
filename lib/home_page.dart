import 'package:flutter/material.dart';
import 'package:marriage_game_scorekeeper/state_management.dart';
import 'package:provider/provider.dart';
import 'package:marriage_game_scorekeeper/player_management.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game_state = Provider.of<GameState>(context);
    return Scaffold(
      body: createPaymentList(context),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton.icon(
                label:Text("Minimize lenden"),
                icon: Icon(Icons.attach_money),
                onPressed: () { if(game_state.number_of_games() > 0) game_state.minimize_transactions();} ), // deleteAll(context,game_state)),
            FlatButton.icon(
                label:Text("Amount/Point"),
                icon: Icon(Icons.add),
                onPressed: () {update_amount_per_point(context,game_state);}),
          ],
        ),
      ),
    );
  }

  void update_amount_per_point(BuildContext context, GameState game_state) async
  {
    double initial_value = game_state.amount_per_point;
    double amount = await showInputAmountDialog(context,initial_value);
    if(amount != initial_value && amount != 0 )
      {
        game_state.set_amount_per_point(amount);
      }
  }

  Future<double> showInputAmountDialog(BuildContext context, double initial_value) async {
    double amount = initial_value;
    return showDialog<double>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Amount per point'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextFormField(
                    autofocus: true,
                    initialValue:initial_value.toString(),
                    decoration: new InputDecoration(
                        labelText: 'Amount Per point', hintText: 'eg.5'),
                    onChanged: (value) {
                      double x = double.parse(value);
                      if(x != 0)
                        amount = x;
                    },
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(amount);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(0);
              },
            ),
          ],
        );
      },
    );
  }


  Widget createPaymentList(BuildContext context) {
    final game_state = Provider.of<GameState>(context);
    if (game_state.number_of_games() > 0) {
      return ListView.builder(
        itemCount: game_state.max_players,
        itemBuilder: (context, position) {
          int player_index = position;
          String image_name = "assets/image$player_index.png";
          String player_name = "";
          String hisab_kitab = "";
          player_name = game_state.get_player_name(player_index);
          if (game_state.any_payments(player_index)) {
            for (int i = 0; i < game_state.max_players; i++) {
              double amount = game_state.get_amount_to_pay(player_index, i) * game_state.amount_per_point;
              String to_player_name = game_state.get_player_name(i);
              if (amount != 0) {
                hisab_kitab += "$to_player_name : $amount\n";
              }
            }
            return ListTile(
              leading: CircleAvatar(backgroundImage: AssetImage(image_name)),
              title: Text("$player_name Pays"),
              subtitle: Text("$hisab_kitab"),
            );
          }
          else {
            return IgnorePointer(ignoring: true);
          }
        },
      );
    }
    else {
      String text = "You have not added any players yet!\nGo to \"Players\" Tab to get started.\n";
      if(game_state.number_of_playing_players >= 2)
        text = "You have not added any games yet!\nGo to \"Games\" Tab to get started.\n";
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/home_back.png', width: 300.0,
            ),
          Text("\n"),
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
          ),
          ],
        ),
      );
    }
  }
}