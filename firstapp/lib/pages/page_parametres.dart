// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstapp/pages/page_TempsJeu.dart';
import 'package:firstapp/pages/page_TempsPause.dart';
import 'package:firstapp/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/menue_retour_parametres.dart';
import 'modifier_mot_de_passe.dart';
import 'modifier_profile_enfant.dart';

// ignore: camel_case_types
class parametres extends StatefulWidget {
  const parametres({Key key}) : super(key: key);

  @override
  _parametresState createState() => _parametresState();
}

// ignore: camel_case_types
class _parametresState extends State<parametres> {
  String nom = " ";
  String avatar = './assets/img/blank.png';

  int valeur = 0;
  bool min = true;
  bool max = true;

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
    final snapshot = await ref.child('$identifier/Enfant/Nom').get();
    final snapshot2 = await ref.child('$identifier/Enfant/Avatar').get();
    setState(() {
      nom = snapshot.value;
      avatar = snapshot2.value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getData();
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
                SizedBox(
                  height: height / 10,
                  width: width,
                ),
                AppText(
                  text: "Param??tres du profil de l'enfant",
                  size: width / 10,
                  color: const Color.fromARGB(255, 20, 111, 186),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const modifier_profile_enfant()));
                  },
                  child: AppText(
                    text: "Modifier le profil",
                    size: width / 12,
                    color: Colors.black87,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(10),
                    width: width / 2,
                    height: width / 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: AssetImage(avatar), fit: BoxFit.cover))),
                AppText(
                  // ignore: unnecessary_string_interpolations
                  text: "$nom",
                  size: width / 9,
                  color: Colors.blue,
                ),
                SizedBox(
                  height: height / 50,
                  width: width,
                ),
                AppText(
                  text: 'Param??tres de contr??le parental',
                  size: width / 10,
                  color: const Color.fromARGB(255, 20, 111, 186),
                ),
                SizedBox(
                  height: height / 250,
                  width: width,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TempsPause()));
                  },
                  child: AppText(
                    text: "Temps de pause",
                    size: width / 12,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  height: height / 100,
                  width: width,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TempsJeu()));
                  },
                  child: AppText(
                    text: "Temps de jeu",
                    size: width / 12,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  height: height / 100,
                  width: width,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const modifier_mot_de_passe()));
                  },
                  child: AppText(
                    text: "Changer le mot de passe",
                    size: width / 12,
                    color: Colors.redAccent,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
