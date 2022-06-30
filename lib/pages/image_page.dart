
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_escaperank_web/utils/app_colors.dart';
import 'package:video_player/video_player.dart';

class ImagePage extends StatefulWidget {

  final String url;
  ImagePage({required this.url}) : super();


  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {


  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Scaffold(
          backgroundColor: AppColors.blackBackGround,
          body: Center(
            child: CachedNetworkImage(
                  imageUrl:widget.url,
                  fit: BoxFit.cover
              ),
          ),
      ),
    );
  }

}