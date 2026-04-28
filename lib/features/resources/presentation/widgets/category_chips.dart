import 'package:flutter/material.dart';
import '../../domain/entities/resource_category.dart';

class CategoryChips extends StatelessWidget {
  final List<ResourceCategory> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: selectedCategoryId == null,
            onSelected: (_) => onCategorySelected(null),
          ),
          const SizedBox(width: 8),
          ...categories.map((category) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text('${category.icon} ${category.name}'),
              selected: selectedCategoryId == category.id,
              onSelected: (_) => onCategorySelected(category.id),
            ),
          )),
        ],
      ),
    );
  }
}