import '../../domain/entities/resource_category.dart';
import '../../domain/repositories/resource_repository.dart';
import '../datasources/resource_remote_datasource.dart';

class ResourceRepositoryImpl implements ResourceRepository {
  final ResourceRemoteDatasource _datasource;

  ResourceRepositoryImpl(this._datasource);

  @override
  Future<List<ResourceCategory>> getCategories() async {
    final models = await _datasource.getCategories();
    return models.map((m) => ResourceCategory(
      id: m.id,
      name: m.name,
      icon: m.icon,
      displayOrder: m.displayOrder,
    )).toList();
  }

  @override
  Future<List<WellnessResource>> getResources({
    String? categoryId,
    bool featuredOnly = false,
  }) async {
    final models = await _datasource.getResources(
      categoryId: categoryId,
      featuredOnly: featuredOnly,
    );
    return models.map((m) => WellnessResource(
      id: m.id,
      categoryId: m.categoryId,
      title: m.title,
      summary: m.summary,
      content: m.content,
      thumbnailUrl: m.thumbnailUrl,
      readTimeMinutes: m.readTimeMinutes,
      tags: m.tags,
      isFeatured: m.isFeatured,
      displayOrder: m.displayOrder,
    )).toList();
  }

  @override
  Future<List<WellnessResource>> getSavedResources() async {
    final models = await _datasource.getSavedResources();
    return models.map((m) => WellnessResource(
      id: m.id,
      categoryId: m.categoryId,
      title: m.title,
      summary: m.summary,
      content: m.content,
      thumbnailUrl: m.thumbnailUrl,
      readTimeMinutes: m.readTimeMinutes,
      tags: m.tags,
      isFeatured: m.isFeatured,
      displayOrder: m.displayOrder,
    )).toList();
  }

  @override
  Future<void> saveResource(String resourceId) async {
    return _datasource.saveResource(resourceId);
  }

  @override
  Future<void> unsaveResource(String resourceId) async {
    return _datasource.unsaveResource(resourceId);
  }

  @override
  Future<bool> isResourceSaved(String resourceId) async {
    return _datasource.isResourceSaved(resourceId);
  }
}