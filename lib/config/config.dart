library config.globals;

enum estados { vacio, cruz, circulo }

List<estados> tablero = List.filled(9, estados.vacio);
Map<estados, bool> resultados = {estados.cruz: false, estados.circulo: false};
int contadorCruz = 0;
int contadorCirculo = 0;
int contadorEmpates = 0;

void reiniciarJuego() {
  tablero = List.filled(9, estados.vacio);
  resultados = {estados.cruz: false, estados.circulo: false};
}