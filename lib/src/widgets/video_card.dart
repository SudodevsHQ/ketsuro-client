// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:relative_scale/relative_scale.dart';

// Project imports:
import 'package:ketsuro/src/common/colors.dart';

class VideoCard extends StatefulWidget {
  final String thumbnail;
  final String url;
  final String title;
  final String channel;

  const VideoCard({Key key, this.thumbnail, this.url, this.title, this.channel})
      : super(key: key);
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
      child: AspectRatio(
        aspectRatio: 360 / 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: widget.thumbnail,
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
    );
  }
}
