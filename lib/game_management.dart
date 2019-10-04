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
                    showAlertDialog(context,"Message","Deleted all Games!");
                  }),
              FlatButton.icon(
                  label:Text("Recalculate"),
                  icon: Icon(Icons.grid_on),
                  onPressed: () {
                    showAlertDialog(context,"Message","Done Recalculating!");
                    //_showModal();
                  }),
              FlatButton.icon(
                  label:Text("Add Game"),
                  icon: Icon(Icons.add),
                  onPressed: () {
                        showAlertDialog(context,"Message","Atleast 2 players needed to play a game!");
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
      itemCount: 1,
      itemBuilder: (context, position) {
        return ListTile(
          leading: Text("$position:"),
          title:Text("Hisab Kitab:"),
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

                  }),
            ],
          ),
        )
    );
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

