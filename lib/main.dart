import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nes/flutter_nes.dart';
import 'package:koala/page/game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koala',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Koala Nes Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _openGame(String nes) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LocalGame(
              rom: NesRom.asset("assets/nes/$nes.nes"),
            )));
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListView(
            children: ["SuperMario", "Contra", "Fighters", "Island", "BattleCity"]
                .map((e) => ListTile(
                      onTap: () {
                        _openGame(e);
                      },
                      title: SizedBox(
                        width: 256 * 0.8,
                        height: 240 * 0.8,
                        child: Center(
                          child: Transform.scale(
                            scale: 0.8,
                            child: FlutterNesWidget(rom: NesRom.asset("assets/nes/$e.nes")),
                          ),
                        ),
                      ),
                    ))
                .toList()),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
