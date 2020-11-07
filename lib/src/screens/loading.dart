import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with RelativeScale {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initRelativeScaler(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Text('Trending Videos',
                    style: TextStyle(
                      fontSize: sx(25),
                      fontWeight: FontWeight.bold,
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
