// Flutter imports:
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ketsuro/src/data/index.dart';
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';

// Project imports:
import 'package:ketsuro/src/common/colors.dart';
import 'package:ketsuro/src/components/youtube/index.dart';

import 'details.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends MomentumState<Home> with RelativeScale {
  List<Map<String, String>> res = [];

  @override
  void didChangeDependencies() {
    initRelativeScaler(context);
    super.didChangeDependencies();
  }

  @override
  void initMomentumState() async {
    var c = Momentum.controller<YoutubeController>(context);
    videos = c.model.videos;
    super.initMomentumState();
  }

  double currentPage = 0;
  List<VideoData> videos;

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(
        initialPage: (currentPage).floor(), viewportFraction: 0.8);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    return MomentumBuilder(
      controllers: [YoutubeController],
      builder: (context, snapshot) {
        var model = snapshot<YoutubeModel>();
        var db = model.videoSnapshot;
        var videos = model.videos;
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            drawer: Drawer(),
            body: videos.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 28.0),
                          child: Text(
                            'Trending Videos',
                            style: TextStyle(
                              fontSize: sx(32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(left: 28.0, bottom: sy(15)),
                          child: Text(
                            'Showing best videos for you',
                            style: TextStyle(color: ketsuroGrey),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: screenHeight * 0.35,
                          child: PageView.builder(
                            controller: controller,
                            pageSnapping: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              var current = videos[index];

                              return Container(
                                height: screenHeight * 0.3,
                                child: AnimatedPadding(
                                  curve: Curves.easeInQuad,
                                  duration: Duration(milliseconds: 200),
                                  padding: index == currentPage
                                      ? EdgeInsets.all(8.0)
                                      : EdgeInsets.all(18),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                            imageUrl: current.thumbnail,
                                            fit: BoxFit.fitHeight,
                                            placeholder: (context, url) {
                                              return Center(
                                                child: Image.asset(
                                                  'assets/undraw_video_files_fu10 1.png',
                                                  scale: 3,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: -1,
                                        bottom: -1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FloatingActionButton(
                                            heroTag: current.thumbnail,
                                            backgroundColor: ketsuroRed,
                                            child: Icon(Icons.play_arrow),
                                            onPressed: () {
                                              var summary = db.docs
                                                      .where((element) =>
                                                          element.data()[
                                                              'video_id'] ==
                                                          videos[currentPage
                                                                  .toInt()]
                                                              .id)
                                                      .isNotEmpty
                                                  ? db.docs
                                                      .where((element) =>
                                                          element.data()[
                                                              'video_id'] ==
                                                          videos[currentPage
                                                                  .toInt()]
                                                              .id)
                                                      .first['summary']
                                                  : null;

                                              if (summary != null) {
                                                var vid = db.docs
                                                    .where((element) =>
                                                        element['video_id'] ==
                                                        videos[currentPage
                                                            .toInt()])
                                                    .first['request_id'];
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (_) => Details(
                                                      summary: summary,
                                                      videoId: vid,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                Flushbar(
                                                  message: "OOPS!",
                                                  duration:
                                                      Duration(seconds: 2),
                                                )..show(context);
                                              }

                                              // print(vid);
                                              // if (vid.isNotEmpty) {
                                              //   var summary =
                                              //       vid.first.data()['summary'];
                                              //   var id = vid.first
                                              //       .data()['video_id'];

                                              // } else {

                                              // }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 28.0, right: 28, top: 28),
                          child: Text(videos[currentPage.toInt()].title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: sx(22)),
                              maxLines: 1),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 28.0, right: 28, top: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Linus Tech Tips',
                                style: TextStyle(
                                  color: ketsuroGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: sx(22),
                                ),
                              ),
                              Image.asset('assets/youtube.png', scale: 2)
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: 28.0, right: 28, top: 18),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: ketsuroCardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Overview',
                                  style: TextStyle(
                                      color: ketsuroRed,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sx(22)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(db.docs
                                        .where((element) =>
                                            element.data()['video_id'] ==
                                            videos[currentPage.toInt()].id)
                                        .isNotEmpty
                                    ? db.docs
                                        .where((element) =>
                                            element.data()['video_id'] ==
                                            videos[currentPage.toInt()].id)
                                        .first['summary']
                                    : 'Not found')
                              ],
                            ),
                          ),
                        ),
                      ))
                    ],
                  ));
      },
    );
  }
}
