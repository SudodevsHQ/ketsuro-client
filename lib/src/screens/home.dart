import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:ketsuro/src/common/colors.dart';
import 'package:ketsuro/src/components/login/index.dart';
import 'package:ketsuro/src/config/config.dart';
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../main.dart';

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
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: ketsuroBlack),
          onPressed: () async {
            var controller = Momentum.controller<LoginController>(context);
            await controller.signOutGoogle();
            Momentum.restart(context, momentum());
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: () async {
              clientViaServiceAccount(credentials, scopes)
                  .then((httpClient) async {
                var youtube = new YoutubeApi(httpClient);
                var subs = await youtube.videos.list([
                  'suggestions',
                  'snippet',
                ], chart: 'mostPopular', videoCategoryId: '28');
                // print(subs.items);
                subs.items.forEach((element) {
                  print('https://www.youtube.com/watch?v=' + element.id);
                });
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: sx(30), right: sx(30), top: sy(10)),
        child: ListView.separated(
          itemCount: 20,
          itemBuilder: (context, index) {
            return VideoCard();
          },
          separatorBuilder: (context, index) => SizedBox(height: sy(6)),
        ),
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> with RelativeScale {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initRelativeScaler(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: ketsuroGrey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 360 / 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: 'https://i.ytimg.com/vi/efDxvq_M-aI/hqdefault.jpg',
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Center(
                      child: Image.asset(
                    'assets/undraw_video_files_fu10 1.png',
                    scale: 3,
                  ));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 18.0, top: 8, bottom: 24, right: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Remember this day… - AMD Ryzen 5000 Series',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: sx(20),
                      color: ketsuroBlack,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  'LinusTechTips',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: sx(15),
                      color: ketsuroGrey,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
