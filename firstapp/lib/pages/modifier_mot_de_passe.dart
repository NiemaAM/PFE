import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstapp/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remove_emoji/remove_emoji.dart';

import '../widgets/menue_retour.dart';

// ignore: camel_case_types
class modifier_mot_de_passe extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const modifier_mot_de_passe({this.app});
  final FirebaseApp app;

  @override
  _modifier_mot_de_passeState createState() => _modifier_mot_de_passeState();
}

// ignore: camel_case_types
class _modifier_mot_de_passeState extends State<modifier_mot_de_passe> {
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

  final referenceDatabase = FirebaseDatabase.instance;
  // ignore: non_constant_identifier_names
  String Nom = "mdp";

  var remove = RemoveEmoji();
  String idParent = "${Random().nextInt(100)}";
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final ref = referenceDatabase.reference();
    _deviceDetails();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/page_parents.png"),
                  fit: BoxFit.cover)),
          child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const retour(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: width / 25,
                  ),
                  SizedBox(
                    width: width,
                    height: height / 2.5,
                    child: AppText(text: "Espace de contrôle parental"),
                  ),
                  SizedBox(
                      width: width,
                      height: width / 10,
                      child: AppText(
                        text: "Modifier le mot de passe",
                        size: 30,
                      )),
                  SizedBox(
                    width: width / 1.5,
                    height: width / 6,
                    child: TextField(
                      controller: myController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      showCursor: true,
                      style: const TextStyle(fontSize: 30),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: width / 8,
                  ),
                  SizedBox(
                      width: width / 3,
                      height: width / 7,
                      child: ElevatedButton(
                        onPressed: () {
                          if (remove.removemoji(myController.text) !=
                              myController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                                text:
                                    'Le mot de passe ne peut pas contenir des emojis',
                                size: 15,
                                color: Colors.white,
                              ),
                            ));
                          } else if (myController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                                text:
                                    'Veillez saisir un mot de passe parentale',
                                size: 15,
                                color: Colors.white,
                              ),
                            ));
                          } else if (remove
                                  .removemoji(myController.text)
                                  .length <
                              5) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: AppText(
                                text:
                                    'Le mot de passe doit contenir minimum 5 caractéres',
                                size: 15,
                                color: Colors.white,
                              ),
                            ));
                          } else {
                            _deviceDetails();
                            ref.update({
                              "$identifier/MotDePasse":
                                  remove.removemoji(myController.text),
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: AppText(
                          text: "Valider",
                          size: 40,
                          color: Colors.white,
                        ),
                      )),
                ],
              ))),
    );
  }
}