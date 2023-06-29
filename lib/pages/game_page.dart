import 'package:flutter/material.dart';
import 'package:jogo_velha/controllers/game_controller.dart';
import 'package:jogo_velha/core/constants.dart';
import 'package:jogo_velha/enums/player_type.dart';
import 'package:jogo_velha/enums/winner_type.dart';
import 'package:jogo_velha/widgets/custom_dialog.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _controller = GameController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
  
  _buildAppBar() {
    return AppBar(
      title: Text(GAME_TITLE),
      centerTitle: true,
    );
  }
  
  _buildBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBoard(),
          _buildPlayerMode(),
          _buildResetButton(),
        ],
      ),
    );
  }
  
  _buildBoard() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: BOARD_SIZE,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10
          ), 
        itemBuilder: _buildTile,));
  }
  
  _buildPlayerMode() {
    return SwitchListTile(
      title: Text(_controller.isSinglePlayer ? '1 Jogador' : 'Dois Jogadores'),
      secondary: Icon(_controller.isSinglePlayer ? Icons.person : 
      Icons.group),
      value: _controller.isSinglePlayer, 
      onChanged: (value) {
        setState(() {
          _controller.isSinglePlayer = value;
        });
      }
      );
  }
  
  _buildResetButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        child: Text(RESET_BUTTON_LABEL),
        onPressed: _onResetGame),
    );
  }

  void _onResetGame() {
    setState(() {
      _controller.reset();
    });
  }

  Widget _buildTile(context, index) {
    return GestureDetector(
      onTap: () => _onMarkTile(index),
      child: Container(
        color: _controller.tiles[index].color,
        child: Center(
          child: Text(
            _controller.tiles[index].symbol,
            style: TextStyle(
              fontSize: 72.0,
              color: Colors.white,
            ),
          ),
        ),
      )
    );
  }
  
  _onMarkTile(index) {
    if(!_controller.tiles[index].enable) return;

    setState(() {
      _controller.markBoardTileByIndex(index);
    });

    _checkWinner();
  }
  
   _checkWinner() {
    var winner = _controller.checkWinner();
    if(winner == WinnerType.none) {
      if(!_controller.hasMoves) {
        _showTiedDialog();
      } else if (_controller.isSinglePlayer &&
      _controller.currentPlayer == PlayerType.player2){
        final index = _controller.automaticMove();
        _onMarkTile(index);
      }
    } else {
      String symbol =
          winner == WinnerType.player1 ? PLAYER1_SYMBOL : PLAYER2_SYMBOL;
          _showWinnerDialog(symbol);
    }
   }
   
     void _showTiedDialog() {
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (context) {
          return CustomDialog(
            title: TIED_TITLE, 
            message: DIALOG_MESSAGE, 
            onPressed: _onResetGame
            );
        }
        );
     }
     
       void _showWinnerDialog(String symbol) {
        showDialog(
          context: context,
           builder: (context) {
            return CustomDialog(
              title: WIN_TITLE.replaceAll('[SYMBOL]', symbol),
              message: DIALOG_MESSAGE,
              onPressed: _onResetGame,
            );
           }
           );
       }

}