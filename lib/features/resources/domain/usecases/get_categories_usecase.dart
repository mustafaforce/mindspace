import '../entities/resource_category.dart';
import '../repositories/resource_repository.dart';

class GetCategoriesUseCase {
  final ResourceRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<ResourceCategory>> call() async {
    return repository.getCategories();
  }
}

class GetResourcesUseCase {
  final ResourceRepository repository;

  GetResourcesUseCase(this.repository);

  Future<List<WellnessResource>> call({String? categoryId, bool featuredOnly = false}) async {
    return repository.getResources(categoryId: categoryId, featuredOnly: featuredOnly);
  }
}

class GetSavedResourcesUseCase {
  final ResourceRepository repository;

  GetSavedResourcesUseCase(this.repository);

  Future<List<WellnessResource>> call() async {
    return repository.getSavedResources();
  }
}

class SaveResourceUseCase {
  final ResourceRepository repository;

  SaveResourceUseCase(this.repository);

  Future<void> call(String resourceId) async {
    return repository.saveResource(resourceId);
  }
}

class UnsaveResourceUseCase {
  final ResourceRepository repository;

  UnsaveResourceUseCase(this.repository);

  Future<void> call(String resourceId) async {
    return repository.unsaveResource(resourceId);
  }
}