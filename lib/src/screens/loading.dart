// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ketsuro/src/common/colors.dart';

// Package imports:
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';

// Project imports:
import 'package:ketsuro/src/components/youtube/index.dart';
import 'home.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends MomentumState<Loading> with RelativeScale {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initRelativeScaler(context);
  }

  @override
  void initMomentumState() async {
    super.initMomentumState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ketsuroBrown,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: sy(20),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Loading...',
                    style: TextStyle(
                      fontSize: sx(25),
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    )),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset(
                'assets/undraw_to_the_moon_v1mv 1.png',
                scale: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: sy(18), bottom: sy(2)),
                child: Text(
                  'HANG TIGHT',
                  style: TextStyle(
                    fontSize: sx(24),
                    fontWeight: FontWeight.w900,
                    color: Colors.white
                  ),
                ),
              ),
              Text(
                'Creating Awesomeness',
                style: TextStyle(
                  color: Color(0xFF989898),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(ketsuroRed),
              )),
              SizedBox(
                height: sy(70),
              )
            ],
          ),
        ),
      ),
    );
  }
}
