import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';

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
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(0xFFF05454 )),
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