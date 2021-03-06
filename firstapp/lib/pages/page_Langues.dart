// ignore_for_file: deprecated_member_use, file_names
import 'package:firstapp/pages/page_Langues_Anglais.dart';
import 'package:firstapp/pages/page_Langues_Francais.dart';
import 'package:firstapp/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/menue_retour.dart';

// ignore: camel_case_types
class langues extends StatefulWidget {
  const langues({Key key}) : super(key: key);

  @override
  _languesState createState() => _languesState();
}

// ignore: camel_case_types
class _languesState extends State<langues> {
  var player = AudioCache();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset("assets/img/haut.png"),
              Column(children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const retour(
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: height / 9,
                    ),
                    GestureDetector(
                      onTap: () {
                        player.play('sfx/poop.mp3');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Francais()));
                      },
                      child: Container(
                        width: width - 50,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blue),
                        child: Center(
                          child: AppText(
                            text: "Fran??ais",
                            size: width / 3,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        player.play('sfx/poop.mp3');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Anglais()));
                      },
                      child: Container(
                        width: width - 50,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color.fromARGB(255, 244, 54, 124)),
                        child: Center(
                          child: AppText(
                            text: "Anglais",
                            size: width / 3,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
