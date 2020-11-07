import 'package:momentum/momentum.dart';

import 'index.dart';

class YoutubeController extends MomentumController<YoutubeModel> {
  @override
  YoutubeModel init() {
    return YoutubeModel(
      this,
      // TODO: specify initial values here...
    );
  }
}
