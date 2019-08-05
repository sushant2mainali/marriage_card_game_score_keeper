import 'package:flutter/material.dart';
import 'package:marriage_game_scorekeeper/state_management.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game_state = Provider.of<GameState>(context);
    return Scaffold(
      body: createPaymentList(context),
    );
  }

  Widget createPaymentList(BuildContext context)
  {
    final game_state = Provider.of<GameState>(context);
    return ListView.builder(
      itemCount: game_state.count_of_players_with_payment,
      itemBuilder: (context, position) {

        int player_index = position+1;

        List<Player> payment_pending_players = game_state.list_of_players_with_payment;

        final List<int> score_list = game_state.list_of_players_with_payment[position].score_card;

        String hisab_kitab = game_state.list_of_players_with_payment[position].player_name + " Pays:\n";

        print(score_list);
        for(int i = 0;i<score_list.length;i++)
          {
            if(score_list[i] >0)
              hisab_kitab += game_state.player_list[i].player_name + " " + score_list[i].toString()+"\n";
          }

          return ListTile(
            leading: Text("$player_index:"),
            title:Text("$hisab_kitab"),
        );
      },
    );
  }

}