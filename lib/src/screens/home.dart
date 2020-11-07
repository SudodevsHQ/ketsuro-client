// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';

// Project imports:
import 'package:ketsuro/src/common/colors.dart';
import 'package:ketsuro/src/components/youtube/index.dart';

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
    var ytController = Momentum.controller<YoutubeController>(context);
    var model = ytController.model;
    currentPage = model.videos.length - 1.0;

    super.initMomentumState();
  }

  double currentPage;

  @override
  Widget build(BuildContext context) {
    PageController controller =
        PageController(initialPage: (currentPage / 2).floor(), viewportFraction: 0.8);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    return MomentumBuilder(
      controllers: [YoutubeController],
      builder: (context, snapshot) {
        var model = snapshot<YoutubeModel>();
        var videos = model.videos;
        return videos.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                drawer: Drawer(),
                body: CustomScrollView(
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
                        padding: EdgeInsets.only(left: 28.0, bottom: sy(30)),
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
                                    : EdgeInsets.all(18.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
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
                            );
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 28.0, right: 28),
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
                              'Elon Musk',
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
                      padding:
                          const EdgeInsets.only(left: 28.0, right: 28, top: 18),
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
                              Text(
                                  '''Today we are finally liquid, calling the Rtx 3090 which is something that I've been so excited to do ever since it was first announced, but also a bit hesitant because this thing pulls around 350 watts on its own. S o, in this video, we'll be taking a look at how much radiator volume you actually need to keep this thing. 

Keep in mind that for the RTX 3090 you also have some memory modules on the back of the PCB as well and this is the water block that we'll be using with it. 
 
You'd at least expect these to be cut to the correct size, not to mention the possibility of user error here is pretty high, but what we're left with is an insanely dense piece of hardware and that gets me really excited for all of the possibilities when it comes to installing this into your board called PC even in a mid-tower build, this will give you a bit more breathing room for a pump and reservoir compared to your standard water block, which will typically be around 50 mils longer, but now let's talk about cooling. ''')
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
