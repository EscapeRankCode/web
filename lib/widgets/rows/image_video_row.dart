import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_escaperank_web/models/image_escaperoom.dart';
import 'package:flutter_escaperank_web/pages/image_page.dart';
import 'package:flutter_escaperank_web/pages/video_page.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:flutter_escaperank_web/utils/image_utils.dart';
import 'package:video_player/video_player.dart';

class ImageVideoRow extends StatefulWidget {
  final ImageEscapeRoom imageVideo;

  ImageVideoRow({required this.imageVideo});

  @override
  _ImageVideoRowState createState() => _ImageVideoRowState();
}

class _ImageVideoRowState extends State<ImageVideoRow> {
  late VideoPlayerController _controller;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    if (ImageUtils.checkIfVideo(widget.imageVideo.mimeType)) {
      _controller = VideoPlayerController.network(widget.imageVideo.url)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            ready = true;
          });
        });
    }
  }

  //

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8.0, 12, 8),
      child: Container(
          decoration: BoxDecoration(
              color: AppColors.blackRow,
              borderRadius: BorderRadius.circular(10)),
          //
          child: !ImageUtils.checkIfVideo(widget.imageVideo.mimeType)
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (BuildContext context) =>
                                ImagePage(url: widget.imageVideo.url)));
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                          imageUrl: widget.imageVideo.resizedUrl,
                          errorWidget: (context, url, error) =>
                              CachedNetworkImage(
                                  imageUrl: widget.imageVideo.url,
                                  height: 180,
                                  width: 210,
                                  fit: BoxFit.cover),
                          height: 180,
                          width: 210,
                          fit: BoxFit.cover)),
                )
              : ready
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (BuildContext context) =>
                                    VideoPage(url: widget.imageVideo.url)));
                      },
                      child: Stack(alignment: Alignment.center, children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        Image.asset("assets/images/icon_video.png"),
                      ]),
                    )
                  : Container()),
    );
  }
}
