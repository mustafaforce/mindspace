class ResourceCategoryModel {
  final String id;
  final String name;
  final String icon;
  final int displayOrder;

  ResourceCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.displayOrder,
  });

  factory ResourceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ResourceCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      displayOrder: json['display_order'] as int,
    );
  }
}

class WellnessResourceModel {
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

  WellnessResourceModel({
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

  factory WellnessResourceModel.fromJson(Map<String, dynamic> json) {
    return WellnessResourceModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String? ?? '',
      content: json['content'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String?,
      readTimeMinutes: json['read_time_minutes'] as int? ?? 5,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isFeatured: json['is_featured'] as bool? ?? false,
      displayOrder: json['display_order'] as int? ?? 0,
    );
  }
}