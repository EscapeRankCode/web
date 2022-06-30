
class ImageEscapeRoom {

  final int id;
  final String url;
  final String mimeType;
  final String resizedUrl;
  static const String testingImage = "https://picsum.photos";

  ImageEscapeRoom({required this.id, required this.url, required this.mimeType, required this.resizedUrl});

  ImageEscapeRoom.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        url = json["url"],
        mimeType = json["mime"],
        resizedUrl = json["resized_url"] != null ? json["resized_url"] : null;

}
