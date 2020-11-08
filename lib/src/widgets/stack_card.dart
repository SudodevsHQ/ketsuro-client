// Dart imports:
import 'dart:math';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

var cardAspectRatio = 12.0 / 20.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class CardScrollWidget extends StatelessWidget {
  final double currentPage;
  final double padding = 20.0;
  final double verticalInset = 20.0;
  final List<Map<String, String>> res;
  const CardScrollWidget({
    Key key,
    this.currentPage,
    this.res,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < 10; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(3.0, 6.0),
                    blurRadius: 10.0,
                  ),
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    // fit: StackFit.expand,
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.network(

                          res[i]['thumbnail'] ??
                              'https://i.ytimg.com/vi/eS7VqGBofVo/hq720.jpg',
                          fit: BoxFit.cover,

                        ),
                        // child: Container(
                        //   decoration: new BoxDecoration(
                        //     image: new DecorationImage(
                        //       image: CachedNetworkImageProvider(
                        //           res[i]['thumbnail']),
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        //   child: new BackdropFilter(
                        //     filter: new ImageFilter.blur(
                        //         sigmaX: 10.0, sigmaY: 10.0),
                        //     child: new Container(
                        //       decoration: new BoxDecoration(
                        //           color: Colors.white.withOpacity(0.0)),
                        //       child: CachedNetworkImage(
                        //           imageUrl: res[i]['thumbnail']),
                        //     ),
                        //   ),
                        // ),
                      ),
                      Positioned(
                        bottom: -1,
                        right: -1,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: i == currentPage
                              ? CircularProgressIndicator()
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
