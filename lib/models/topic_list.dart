import 'topic.dart';

class TopicList {
  final List<Topic> topics;

  TopicList({required this.topics});

  factory TopicList.fromJson(List<dynamic> json) {
    List<Topic> topicList = json.map((i) => Topic.fromJson(i)).toList();
    return new TopicList(topics: topicList);
  }
}

