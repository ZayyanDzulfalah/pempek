import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restoku/helpers/restoku_databaser.dart';
import '../authentication/register_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  RestoDatabase restoDatabase = RestoDatabase();
  void initState() {
    // TODO: implement initState
    restoDatabase.database();
    super.initState();
    openSplashScreen();
  }

  openSplashScreen() async {
    //bisa diganti beberapa detik sesuai keinginan
    var durasiSplash = const Duration(seconds: 3);
    return Timer(durasiSplash, () {
      //pindah ke halaman home
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return RegisterView();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome'),
      ),
    );
  }
}
