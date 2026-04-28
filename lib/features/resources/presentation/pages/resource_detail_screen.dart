import 'package:flutter/material.dart';
import '../controllers/resource_view_model.dart';
import '../../data/datasources/resource_remote_datasource.dart';
import '../../data/repositories/resource_repository_impl.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../../../core/services/navigation_service.dart';

class ResourceDetailScreen extends StatefulWidget {
  final String resourceId;

  const ResourceDetailScreen({super.key, required this.resourceId});

  @override
  State<ResourceDetailScreen> createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen> {
  late final ResourceViewModel _viewModel;

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
    _viewModel.loadResources();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final resource = _viewModel.selectedResource;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _viewModel.clearSelection();
                NavigationService.instance.pop();
              },
            ),
            title: Text(resource?.title ?? 'Resource'),
            actions: [
              if (resource != null)
                IconButton(
                  icon: Icon(
                    _viewModel.isResourceSaved(resource.id)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                  ),
                  onPressed: () => _viewModel.toggleSaveResource(resource.id),
                ),
            ],
          ),
          body: resource == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            resource.formattedReadTime,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 16),
                          ...resource.tags.take(3).map((tag) => Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(tag, style: Theme.of(context).textTheme.labelSmall),
                          )),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        resource.summary,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      _buildMarkdownContent(resource.content),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildMarkdownContent(String content) {
    final lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('# ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              line.substring(2),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (line.startsWith('## ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Text(
              line.substring(3),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        } else if (line.startsWith('- ')) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(line.substring(2))),
              ],
            ),
          );
        } else if (line.startsWith('**') && line.endsWith('**')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              line.substring(2, line.length - 2),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        } else if (line.trim().isEmpty) {
          return const SizedBox(height: 8);
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(line),
        );
      }).toList(),
    );
  }
}