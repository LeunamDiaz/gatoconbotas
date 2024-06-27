import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gto/config/config.dart';
import 'package:gto/widget/celda.dart';

class Controles extends StatefulWidget {
  const Controles({Key? key}) : super(key: key);

  @override
  State<Controles> createState() => _ControlesState();
}

class _ControlesState extends State<Controles> {
  estados inicial = estados.cruz;
  int contador = 0;
  bool gameOver = false;

  int victoriasEquis = 0;
  int victoriasCirculos = 0;
  int empates = 0;

  List<estados> tablero = List.filled(9, estados.vacio);
  Map<estados, bool> resultados = {
    estados.cruz: false,
    estados.circulo: false,
  };

  @override
  void initState() {
    super.initState();
    iniciarNuevoJuego();
  }

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ultimate Tic Tac Toe'),
        actions: <Widget>[
          _buildPopupMenu(),
        ],
      ),
      body: _buildBody(ancho),
      bottomNavigationBar: _buildBottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody(double ancho) {
    return Container(
      color: Colors.lightGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildScoreboard(),
          Expanded(
            child: _buildBoard(ancho),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildScoreboard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Victorias de las x: $victoriasEquis',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Victorias de las o: $victoriasCirculos',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Empates: $empates',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildBoard(double ancho) {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          width: ancho,
          height: ancho,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'imagenes/board.png',
                  fit: BoxFit.cover,
                ),
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) => Celda(
                  inicial: tablero[index],
                  alto: ancho / 3,
                  ancho: ancho / 3,
                  press: () => _presionarCelda(index),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _dialogoConfirmacionReinicio(),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _dialogoConfirmacionSalir(),
          ),
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () => iniciarNuevoJuego(),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        if (result == 'Reiniciar') {
          _dialogoConfirmacionReinicio();
        } else if (result == 'Salir') {
          _dialogoConfirmacionSalir();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Reiniciar',
          child: Text('Reiniciar'),
        ),
        const PopupMenuItem<String>(
          value: 'Salir',
          child: Text('Salir'),
        ),
      ],
    );
  }

  void _presionarCelda(int index) {
    if (!gameOver && tablero[index] == estados.vacio) {
      setState(() {
        tablero[index] = inicial;
        inicial = inicial == estados.cruz ? estados.circulo : estados.cruz;
        contador++;
        _verificarResultado();
      });
    }
  }

  void _verificarResultado() {
    for (int i = 0; i < 9; i += 3) {
      if (tablero[i] != estados.vacio &&
          tablero[i] == tablero[i + 1] &&
          tablero[i + 1] == tablero[i + 2]) {
        resultados[tablero[i]] = true;
        gameOver = true;
        _actualizarEstadisticasJuego(tablero[i]);
        _mostrarDialogoVictoria(tablero[i]);
        return;
      }
    }
    for (int i = 0; i < 3; i++) {
      if (tablero[i] != estados.vacio &&
          tablero[i] == tablero[i + 3] &&
          tablero[i + 3] == tablero[i + 6]) {
        resultados[tablero[i]] = true;
        gameOver = true;
        _actualizarEstadisticasJuego(tablero[i]);
        _mostrarDialogoVictoria(tablero[i]);
        return;
      }
    }
    if (tablero[0] != estados.vacio &&
        tablero[0] == tablero[4] &&
        tablero[4] == tablero[8]) {
      resultados[tablero[0]] = true;
      gameOver = true;
      _actualizarEstadisticasJuego(tablero[0]);
      _mostrarDialogoVictoria(tablero[0]);
      return;
    }
    if (tablero[2] != estados.vacio &&
        tablero[2] == tablero[4] &&
        tablero[4] == tablero[6]) {
      resultados[tablero[2]] = true;
      gameOver = true;
      _actualizarEstadisticasJuego(tablero[2]);
      _mostrarDialogoVictoria(tablero[2]);
      return;
    }

    if (contador == 9 && !gameOver) {
      gameOver = true;
      _actualizarEstadisticasJuego(null);
      _mostrarDialogoEmpate();
    }
  }

  void _actualizarEstadisticasJuego(estados? ganador) {
    setState(() {
      if (ganador == estados.cruz) {
        victoriasEquis++;
      } else if (ganador == estados.circulo) {
        victoriasCirculos++;
      } else {
        empates++;
      }
    });
  }

  void _mostrarDialogoVictoria(estados ganador) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Victoria!"),
          content: Text(ganador == estados.cruz
              ? "¡Las equis han ganado!"
              : "¡Los círculos han ganado!"),
          actions: <Widget>[
            TextButton(
              child: Text("Continuar"),
              onPressed: () {
                Navigator.of(context).pop();
                iniciarNuevoJuego();
              },
            ),
            TextButton(
              child: Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 500), () {
                  SystemNavigator.pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoEmpate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Empate!"),
          content: Text("No hay ganador en esta partida."),
          actions: <Widget>[
            TextButton(
              child: Text("Continuar"),
              onPressed: () {
                Navigator.of(context).pop();
                iniciarNuevoJuego();
              },
            ),
            TextButton(
              child: Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 500), () {
                  SystemNavigator.pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _dialogoConfirmacionReinicio() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reiniciar Juego"),
          content: Text("¿Estás seguro de reiniciar el juego?"),
          actions: <Widget>[
            TextButton(
              child: Text("Sí"),
              onPressed: () {
                Navigator.of(context).pop();
                reiniciarTodo();
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _dialogoConfirmacionSalir() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Salir del Juego"),
          content: Text("¿Estás seguro de salir del juego?"),
          actions: <Widget>[
            TextButton(
              child: Text("Sí"),
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void iniciarNuevoJuego() {
    setState(() {
      tablero = List.filled(9, estados.vacio);
      gameOver = false;
      contador = 0;
      inicial = estados.cruz;
      resultados = {estados.cruz: false, estados.circulo: false};
    });
  }

  void reiniciarTodo() {
    setState(() {
      iniciarNuevoJuego();

      victoriasEquis = 0;
      victoriasCirculos = 0;
      empates = 0;
    });
  }
}
