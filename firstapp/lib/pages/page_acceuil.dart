// ignore_for_file: deprecated_member_use, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstapp/pages/verifier_mot_de_passe.dart';
import 'package:firstapp/widgets/app_msg.dart';
import 'package:firstapp/widgets/slide_jeux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/Audio_BK.dart';
import '../widgets/app_text.dart';
import '../widgets/menue_infos.dart';

// ignore: camel_case_types
class acceil extends StatefulWidget {
  const acceil({Key key}) : super(key: key);

  @override
  _acceilState createState() => _acceilState();
}

// ignore: camel_case_types
class _acceilState extends State<acceil> {
  final referenceDatabase = FirebaseDatabase.instance;
  var player = AudioCache();
  String nom = '';
  String score = '';
  String mdp = '';
  String LastCo = '';
  String TempsJeu = '25';
  String TempsPause = '5';
  String Avatar = './assets/img/blank.png';
  bool icon_valume = false;

  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  Future<void> _deviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model;
          deviceVersion = build.version.toString();
          identifier = build.androidId;
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = data.name;
          deviceVersion = data.systemVersion;
          identifier = data.identifierForVendor;
        }); //UUID for iOS
      }
    } on PlatformException {
      // ignore: avoid_print
      print('Failed to get platform version');
    }
  }

  getData() async {
    _deviceDetails();
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('$identifier/id').get();
    final snapshot1 = await ref.child('$identifier/MotDePasse').get();
    final snapshot2 = await ref.child('$identifier/Enfant/Nom').get();
    final snapshot3 = await ref.child('$identifier/Enfant/Avatar').get();
    final snapshot4 = await ref.child('$identifier/Enfant/Score').get();
    final snapshot5 = await ref.child('$identifier/Enfant/LastCo').get();
    final snapshot6 = await ref.child('$identifier/Enfant/TempsJeu').get();
    final snapshot7 = await ref.child('$identifier/Enfant/TempsPause').get();
    if (snapshot.value == identifier) {
      setState(() {
        mdp = snapshot1.value;
        nom = snapshot2.value;
        Avatar = snapshot3.value;
        score = snapshot4.value;
        LastCo = snapshot5.value;
        TempsJeu = snapshot6.value;
        TempsPause = snapshot7.value;
      });
    }
  }

  getsons() async {
    if (icon_valume == true) {
      Audio_BK.pauseBK();
    }
    if (icon_valume == false) {
      Audio_BK.loopBK("musiques_fond/HeatleyBros_main.mp3");
    }
  }

  bool arret = false;
  setTempsJeu() async {
    getData();
    await Future.delayed(const Duration(seconds: 10), () {
      if (arret == false) {
        final timer = Timer(
          Duration(minutes: int.parse(TempsJeu)),
          () {
            arret = true;
          },
        );
      }
    });
    await Future.delayed(const Duration(seconds: 10), () {
      if (arret == true) {
        final timer = Timer(
          Duration(minutes: int.parse(TempsPause)),
          () {
            arret = false;
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    getsons();
    setTempsJeu();
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // ignore: missing_required_param
        floatingActionButton: const FloatingActionButton(
          mini: false,
          shape: RoundedRectangleBorder(),
          child: menueInfos(),
          backgroundColor: Colors.transparent,
          splashColor: Colors.transparent,
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double width = MediaQuery.of(context).size.width;
            double height = MediaQuery.of(context).size.height;
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/acceuil_fond.png"),
                      fit: BoxFit.cover)),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Image.asset("assets/img/acceuil_haut.png"),
                    Image.asset("assets/img/acceuil_bas.png"),
                    Column(children: [
                      SizedBox(
                        height: height / 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: RaisedButton(
                              onPressed: () {
                                player.play('sfx/poop.mp3');
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const verifier_mot_de_passe()));
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(Icons.menu,
                                  size: width / 8, color: Colors.white),
                              color: Colors.transparent,
                              splashColor: Colors.transparent,
                              elevation: 0,
                              hoverElevation: 0,
                              focusElevation: 0,
                              highlightElevation: 0,
                            ),
                          ),
                          Expanded(child: Container()),
                          IconButton(
                            icon: (icon_valume)
                                ? const Icon(
                                    Icons.volume_off,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.volume_up,
                                    color: Colors.white,
                                  ),
                            onPressed: () {
                              setState(() {
                                icon_valume = !icon_valume;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(Avatar),
                              minRadius: 35,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Container()),
                          Expanded(child: Container()),
                          Expanded(child: Container()),
                          Expanded(child: Container()),
                          Expanded(child: Container()),
                          Expanded(child: Container()),
                          Expanded(child: Container()),
                          Expanded(child: Container()),
                          Image.asset(
                            "assets/img/star.png",
                            height: width / 18,
                          ),
                          AppText(
                            text: " $score",
                            size: width / 10,
                            color: Colors.white,
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                      SizedBox(
                        height: height / 28,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: AppMsg(
                            text: (arret)
                                ? "Le temps de jeu est ??puis?? !\n Reviens plus tard."
                                : "Bonjour $nom, ?? quoi veux tu jouer aujourd'hui ?",
                            size: width / 10,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: height / 20,
                      ),
                      (arret) ? const SizedBox() : const slideJeux(),
                    ]),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
