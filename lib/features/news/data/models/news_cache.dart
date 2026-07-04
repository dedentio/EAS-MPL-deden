import 'package:isar/isar.dart';

part 'news_cache.g.dart';

@collection
class NewsCache {
  Id id = Isar.autoIncrement;

  late String title;
  late String description;
  late String urlToImage;
  late String content;
}