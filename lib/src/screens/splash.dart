import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ketsuro/src/common/colors.dart';
import 'package:ketsuro/src/components/login/index.dart';
import 'package:ketsuro/src/screens/home.dart';
import 'package:ketsuro/src/screens/home_old.dart';
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';

import 'index.dart';

class Ketsuro extends StatefulWidget {
  @override
  _KetsuroState createState() => _KetsuroState();
}

class _KetsuroState extends State<Ketsuro> with RelativeScale {
  @override
  void didChangeDependencies() {
    initRelativeScaler(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/undraw_in_progress_ql66 1.png',
                    scale: 2.5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: sy(18), bottom: sy(2)),
                    child: Text(
                      'KETSURO',
                      style: TextStyle(
                        fontSize: sx(24),
                        letterSpacing: 2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    'Watch Things that matter',
                    style: TextStyle(
                      color: Color(0xFF989898),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MomentumBuilder(
                    controllers: [LoginController],
                    builder: (context, snapshot) {
                      var model = snapshot<LoginModel>();
                      if (model.isLoggedIn) {
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Color(0xFFF05454)),
                        );
                      } else {
                        return FlatButton.icon(
                          color: ketsuroRed,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () async {
                            var controller = model.controller;
                            Flushbar(
                              message: "Processing!",
                              duration: Duration(seconds: 2),
                            )..show(context);
                            var res = await controller.signInWithGoogle();

                            if (res == null) {
                              Flushbar(
                                message: "Error in logging in!",
                                duration: Duration(seconds: 2),
                              )..show(context);
                            } else {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => Loading(),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.play_arrow,
                            color: ketsuroBgWhite,
                          ),
                          label: Text(
                            'Login with Youtube',
                            style: TextStyle(
                              color: ketsuroBgWhite,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: sy(30),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
