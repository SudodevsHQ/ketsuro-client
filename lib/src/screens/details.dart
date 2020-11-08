// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ketsuro/src/components/youtube/index.dart';
import 'package:ketsuro/src/data/index.dart';
import 'package:momentum/momentum.dart';

// Package imports:
import 'package:relative_scale/relative_scale.dart';
import 'package:video_player/video_player.dart';

// Project imports:
import 'package:ketsuro/src/common/colors.dart';

class Details extends StatefulWidget {
  final VideoData video;
  final String god;
  const Details({
    Key key,
    this.video,
    this.god,
  }) : super(key: key);
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends MomentumState<Details> with RelativeScale {
  VideoPlayerController _controller;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initRelativeScaler(context);
  }

  @override
  void initMomentumState() async {
    var controller = Momentum.controller<YoutubeController>(context);


    _controller = VideoPlayerController.network(
      widget.god,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();

   

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
        controllers: [YoutubeController],
        builder: (context, snapshot) {
          var model = snapshot<YoutubeModel>();
          var q = model.videoSnapshot.docs;
          var url = q
              .where((element) => element.data()['video_id'] == widget.video.id)
              .first
              .data()['summary_video'];
          print(url);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            drawer: Drawer(),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Container(
                      height: screenHeight * 0.3,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(20),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    VideoPlayer(_controller),
                                    // ClosedCaption(text: _controller.value.caption.text),
                                    _ControlsOverlay(controller: _controller),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 28.0, right: 28),
                    child: Text(widget.video.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: sx(22)),
                        maxLines: 2),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 28.0, right: 28, top: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.video.channel,
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
                          Text(q
                                  .where((element) =>
                                      (element.data()['video_id'] ==
                                          widget.video.id))
                                  .isNotEmpty
                              ? q
                                  .where((element) =>
                                      element.data()['video_id'] ==
                                      widget.video.id)
                                  .first['summary']
                              : 'No data')
                        ],
                      ),
                    ),
                  ),
                ))
              ],
            ),
          );
        });
  }
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({Key key, this.controller}) : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  __ControlsOverlayState createState() => __ControlsOverlayState();
}

class __ControlsOverlayState extends State<_ControlsOverlay>
    with RelativeScale {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initRelativeScaler(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            widget.controller.value.isPlaying
                ? widget.controller.pause()
                : widget.controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: widget.controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              widget.controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _ControlsOverlay._examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${widget.controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
