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
      itemCount: 2,
      itemBuilder: (context, position) {
          return ListTile(
            leading: Text("234234"),
            title:Text("xcmvn"),
        );
      },
    );
  }

}