import '../entities/resource_category.dart';

abstract class ResourceRepository {
  Future<List<ResourceCategory>> getCategories();
  Future<List<WellnessResource>> getResources({String? categoryId, bool featuredOnly});
  Future<List<WellnessResource>> getSavedResources();
  Future<void> saveResource(String resourceId);
  Future<void> unsaveResource(String resourceId);
  Future<bool> isResourceSaved(String resourceId);
}