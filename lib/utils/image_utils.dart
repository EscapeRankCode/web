import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../configuration.dart';
import '../models/image_escaperoom.dart';

class ImageUtils {

  static const List<String> devel_images = [
    "assets/images/devel_images/3magos.jpg",
    "assets/images/devel_images/el_santuario.jpg",
    "assets/images/devel_images/harrypott.jpg",
    "assets/images/devel_images/hobbit.jpg",
    "assets/images/devel_images/maldita_fama.jpg",
    "assets/images/devel_images/mazmorra.jpg",
    "assets/images/devel_images/nightmare.jpg",
    "assets/images/devel_images/oscuridad.jpg",
    "assets/images/devel_images/prisioneros_alkaban.jpg",
    "assets/images/devel_images/sherlock_london.jpg",
  ];

  ImageUtils._();

  static const List<String> imageCatalog = [
    "https://picsum.photos/380/150?random=1",
    "https://picsum.photos/380/150?random=2",
    "https://picsum.photos/380/150?random=3",
    "https://picsum.photos/380/150?random=4",
    "https://picsum.photos/380/150?random=5",
  ];

  static String getFirstImage(List<ImageEscapeRoom> images, bool isResized) {
    // return "null"; // todo: TESTING ONLY
    for (int i = 0; i < images.length; i++) {
      if (images[i].url.toLowerCase().contains("jpg") || images[i].url.toLowerCase().contains("jpeg") || images[i].url.toLowerCase().contains("png")) {
        return isResized ? images[i].resizedUrl : images[i].url;
      }
    }
    return "null";
  }

  static bool checkIfVideo(String url) {
    if (url.toLowerCase().contains("jpeg") ||
        url.toLowerCase().contains("jpg") ||
        url.toLowerCase().contains("png")) return false;
    return true;
  }

   static Future<String> getImageBase64(File image) async{
    String img64;
    var minSize = VARS.minSizeImages;
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = dir.absolute.path + "/temp.jpg";
    var imgFile = await testCompressAndGetFile(image, targetPath, minSize);
    var bytes = imgFile!.readAsBytesSync();
    img64 = base64Encode(bytes);
    int sizeInBytes = imgFile.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    while (sizeInMb > 1) {
      minSize = minSize - 100;
      imgFile = await testCompressAndGetFile(image, targetPath, minSize);
      imgFile!.readAsBytesSync();
      img64 = base64Encode(bytes);
      int sizeInBytes = imgFile.lengthSync();
      sizeInMb = sizeInBytes / (1024 * 1024);
    }

    return img64;
  }

  static Future<File?> testCompressAndGetFile(
      File file, String targetPath, int minSize) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: minSize,
      minHeight: minSize,
      quality: 80,
    );

    // ignore: avoid_print
    print(file.lengthSync());
    // ignore: avoid_print
    print(result?.lengthSync());

    return result;
  }
}