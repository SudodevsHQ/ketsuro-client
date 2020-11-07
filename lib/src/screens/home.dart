import 'package:flutter/material.dart';
import 'package:ketsuro/src/common/colors.dart';
import 'package:relative_scale/relative_scale.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with RelativeScale {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initRelativeScaler(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trending Videos',
          style: TextStyle(color: ketsuroBlack, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: Container(),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              child: Column(
                children: [
                  Image.network('https://i.ytimg.com/vi/iZBIeM2zE-I/hqdefault.jpg', ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
