import 'package:flutter/material.dart';
import 'package:marriage_game_scorekeeper/player_management.dart';
import 'package:marriage_game_scorekeeper/state_management.dart';
import 'package:marriage_game_scorekeeper/game_management.dart';
import 'package:marriage_game_scorekeeper/home_page.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(TabbedApp());
}

TabController controller;

class TabbedApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context)=> GameState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.home), text:"Home"),
                    Tab(icon: Icon(Icons.blur_circular), text: "Games"),
                    Tab(icon: Icon(Icons.supervisor_account), text: "Players"),
                  ],
                ),
                title: Text('Marriage Score Keeper'),
              ),
              body: TabBarView(
                controller: controller,
                children: <Widget>[
                  HomeTab(),
                  GameManagementTab(),
                  PlayerManagementTab(),
                ],
              ),
            ),
          ),
        ),
  );
  }
}