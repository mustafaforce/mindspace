import 'package:flutter/foundation.dart';
import '../../domain/entities/resource_category.dart';
import '../../domain/usecases/get_categories_usecase.dart';

class ResourceViewModel extends ChangeNotifier {
  late final GetCategoriesUseCase _getCategories;
  late final GetResourcesUseCase _getResources;
  late final GetSavedResourcesUseCase _getSavedResources;
  late final SaveResourceUseCase _saveResource;
  late final UnsaveResourceUseCase _unsaveResource;

  ResourceViewModel({
    required GetCategoriesUseCase getCategories,
    required GetResourcesUseCase getResources,
    required GetSavedResourcesUseCase getSavedResources,
    required SaveResourceUseCase saveResource,
    required UnsaveResourceUseCase unsaveResource,
  })  : _getCategories = getCategories,
        _getResources = getResources,
        _getSavedResources = getSavedResources,
        _saveResource = saveResource,
        _unsaveResource = unsaveResource;

  List<ResourceCategory> _categories = [];
  List<ResourceCategory> get categories => _categories;

  List<WellnessResource> _resources = [];
  List<WellnessResource> get resources => _resources;

  List<WellnessResource> _featuredResources = [];
  List<WellnessResource> get featuredResources => _featuredResources;

  List<WellnessResource> _savedResources = [];
  List<WellnessResource> get savedResources => _savedResources;

  WellnessResource? _selectedResource;
  WellnessResource? get selectedResource => _selectedResource;

  String? _selectedCategoryId;
  String? get selectedCategoryId => _selectedCategoryId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadCategories() async {
    try {
      _categories = await _getCategories();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadResources() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _resources = await _getResources(categoryId: _selectedCategoryId);
      _featuredResources = await _getResources(featuredOnly: true);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSavedResources() async {
    try {
      _savedResources = await _getSavedResources();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    loadResources();
  }

  void selectResource(WellnessResource resource) {
    _selectedResource = resource;
    notifyListeners();
  }

  Future<void> toggleSaveResource(String resourceId) async {
    final isSaved = _savedResources.any((r) => r.id == resourceId);
    try {
      if (isSaved) {
        await _unsaveResource(resourceId);
        _savedResources.removeWhere((r) => r.id == resourceId);
      } else {
        await _saveResource(resourceId);
        final resource = _resources.firstWhere((r) => r.id == resourceId);
        _savedResources.add(resource);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  bool isResourceSaved(String resourceId) {
    return _savedResources.any((r) => r.id == resourceId);
  }

  void clearSelection() {
    _selectedResource = null;
    notifyListeners();
  }
}