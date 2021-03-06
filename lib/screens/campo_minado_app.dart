import 'package:campo_minado/components/tabuleiro_widget.dart';
import 'package:campo_minado/Models/tabuleiro.dart';
import 'package:flutter/material.dart';
import '../components/resultado_widget.dart';
import '../Models/campo.dart';
import '../Models/explosao_exception.dart';

class CampoMinadoApp extends StatefulWidget {
  @override
  _CampoMinadoAppState createState() => _CampoMinadoAppState();
}

class _CampoMinadoAppState extends State<CampoMinadoApp> {
  bool _venceu;
  Tabuleiro _tabuleiro;

  void _reiniciar() {
    setState(() {
      _venceu = null;
      _tabuleiro.reiniciar();
    });
  }

  void _abrir(Campo campo) {
    setState(() {
      if (_venceu != null) {
        return;
      }
      try {
        campo.abrir();
        if (_tabuleiro.resolvido) {
          _venceu = true;
        }
      } on ExplosaoException {
        _venceu = false;
        _tabuleiro.revelarBombas();
      }
    });
  }

  void _alternarMarcacao(Campo campo) {
    if (_venceu != null) {
      return;
    }
    setState(() {
      campo.alternarMarcacao();
      if (_tabuleiro.resolvido) {
        _venceu = true;
      }
    });
  }

  Tabuleiro _getTabuleiro(double largura, double altura) {
    if (_tabuleiro == null) {
      int qtdeColunas = 15;
      double tamanhoDoCampo = (largura / qtdeColunas) * 1.2;
      int qtdeLinhas = (altura / tamanhoDoCampo).floor();

      _tabuleiro = Tabuleiro(
        linhas: qtdeLinhas,
        colunas: qtdeColunas,
        qtdeBombas: 3,
      );
    }
    return _tabuleiro;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: ResultadoWidget(
          venceu: _venceu,
          onReiniciar: _reiniciar,
        ),
        body: Container(
          color: Colors.blue,
          child: LayoutBuilder(builder: (ctx, constraints) {
            return TabuleiroWidget(
              tabuleiro:
                  _getTabuleiro(constraints.maxWidth, constraints.maxHeight),
              onAbrir: _abrir,
              onAlternarMarcacao: _alternarMarcacao,
            );
          }),
        ),
      ),
    );
  }
}
