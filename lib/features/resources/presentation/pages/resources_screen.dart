import 'package:flutter/material.dart';
import '../controllers/resource_view_model.dart';
import '../widgets/category_chips.dart';
import '../widgets/resource_card.dart';
import '../../data/datasources/resource_remote_datasource.dart';
import '../../data/repositories/resource_repository_impl.dart';
import '../../domain/usecases/get_categories_usecase.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  late final ResourceViewModel _viewModel;
  bool _showSavedOnly = false;

  @override
  void initState() {
    super.initState();
    _viewModel = ResourceViewModel(
      getCategories: GetCategoriesUseCase(ResourceRepositoryImpl(ResourceRemoteDatasource())),
      getResources: GetResourcesUseCase(ResourceRepositoryImpl(ResourceRemoteDatasource())),
      getSavedResources: GetSavedResourcesUseCase(ResourceRepositoryImpl(ResourceRemoteDatasource())),
      saveResource: SaveResourceUseCase(ResourceRepositoryImpl(ResourceRemoteDatasource())),
      unsaveResource: UnsaveResourceUseCase(ResourceRepositoryImpl(ResourceRemoteDatasource())),
    );
    _viewModel.loadCategories();
    _viewModel.loadResources();
    _viewModel.loadSavedResources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Resources'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_showSavedOnly ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () {
              setState(() {
                _showSavedOnly = !_showSavedOnly;
              });
              if (_showSavedOnly) {
                _viewModel.loadSavedResources();
              }
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading && _viewModel.resources.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final resources = _showSavedOnly
              ? _viewModel.savedResources
              : _viewModel.resources;
          final featured = _viewModel.featuredResources;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: CategoryChips(
                    categories: _viewModel.categories,
                    selectedCategoryId: _viewModel.selectedCategoryId,
                    onCategorySelected: (id) {
                      _viewModel.selectCategory(id);
                    },
                  ),
                ),
              ),
              if (!_showSavedOnly && featured.isNotEmpty && _viewModel.selectedCategoryId == null) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Featured',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: featured.length,
                      itemBuilder: (context, index) {
                        final resource = featured[index];
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 280,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  resource.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      resource.formattedReadTime,
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    _showSavedOnly ? 'Saved' : 'All Resources',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (resources.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      _showSavedOnly ? 'No saved resources yet' : 'No resources found',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ResourceCard(
                      resource: resources[index],
                      isSaved: _viewModel.isResourceSaved(resources[index].id),
                      onTap: () {},
                      onSaveToggle: () => _viewModel.toggleSaveResource(resources[index].id),
                    ),
                    childCount: resources.length,
                  ),
                ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          );
        },
      ),
    );
  }
}