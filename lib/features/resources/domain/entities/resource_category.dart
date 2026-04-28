class ResourceCategory {
  final String id;
  final String name;
  final String icon;
  final int displayOrder;

  ResourceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.displayOrder,
  });
}

class WellnessResource {
  final String id;
  final String categoryId;
  final String title;
  final String summary;
  final String content;
  final String? thumbnailUrl;
  final int readTimeMinutes;
  final List<String> tags;
  final bool isFeatured;
  final int displayOrder;

  WellnessResource({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.summary,
    required this.content,
    this.thumbnailUrl,
    required this.readTimeMinutes,
    required this.tags,
    required this.isFeatured,
    required this.displayOrder,
  });

  String get formattedReadTime => '$readTimeMinutes min read';
}