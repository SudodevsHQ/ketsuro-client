class VideoData {
  final String title;
  final String channel;
  final String url;
  final String thumbnail;

  VideoData({this.title, this.channel, this.url, this.thumbnail});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'channel': channel,
      'url': url,
      'thumbnail': thumbnail,
    };
  }

  VideoData fromJson(Map<String, dynamic> map) {
    if (map == null) return null;

    return VideoData(
      title: map['title'],
      channel: map['channel'],
      url: map['url'],
      thumbnail: map['thumbnail'],
    );
  }
}
