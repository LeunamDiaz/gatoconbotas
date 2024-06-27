import 'package:flutter/material.dart';
class BottomAppBarWidget extends StatelessWidget {
  final VoidCallback reiniciarJuego;
  final VoidCallback salirJuego;
  const BottomAppBarWidget({
    required this.reiniciarJuego,
    required this.salirJuego,
  });
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              tooltip: 'Reiniciar',
              icon: const Icon(Icons.refresh),
              onPressed: reiniciarJuego,
            ),
            IconButton(
              tooltip: 'Salir',
              icon: const Icon(Icons.exit_to_app),
              onPressed: salirJuego,
            ),
          ],
        ),
      ),
    );
  }
}