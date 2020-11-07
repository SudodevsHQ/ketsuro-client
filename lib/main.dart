import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ketsuro/src/components/login/index.dart';
import 'package:ketsuro/src/screens/index.dart';
import 'package:momentum/momentum.dart';

import 'src/common/colors.dart';
import 'src/services/client_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(momentum());
}

Momentum momentum() {
  return Momentum(
    restartCallback: main,
    key: UniqueKey(),
    child: MyApp(),
    controllers: [
      LoginController(),
    ],
    services: [
      ClientDB(),
    ],
    persistSave: (context, key, value) async {
      var sharedPref = await ClientDB.getByContext(context);
      var result = await sharedPref.setString(key, value);
      return result;
    },
    persistGet: (context, key) async {
      var sharedPref = await ClientDB.getByContext(context);
      var result = sharedPref.getString(key);
      return result;
    },
    onResetAll: (context, resetAll) async {
      var sharedPref = await ClientDB.getByContext(context);
      sharedPref.clear();
      try {
        await FirebaseFirestore.instance.clearPersistence();
      } catch (e) {
        print(e);
      }
      resetAll(context);
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MomentumBuilder(
        controllers: [LoginController],
        builder: (context, snapshot) {
          var model = snapshot<LoginModel>();
          if (model.isLoggedIn) {
            return Home();
          } else {
            return Ketsuro();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: ketsuroBgWhite,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          body1: TextStyle(
            color: ketsuroBlack,
          ),
          body2: TextStyle(
            color: ketsuroBlack,
          ),
        ),
      ),
    );
  }
}
