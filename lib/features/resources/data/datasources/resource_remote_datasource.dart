import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/resource_category_model.dart';

class ResourceRemoteDatasource {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<ResourceCategoryModel>> getCategories() async {
    final response = await _client
        .from('resource_categories')
        .select()
        .order('display_order');

    return (response as List)
        .map((json) => ResourceCategoryModel.fromJson(json))
        .toList();
  }

  Future<List<WellnessResourceModel>> getResources({
    String? categoryId,
    bool featuredOnly = false,
  }) async {
    var query = _client.from('wellness_resources').select().eq('is_active', true);

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    if (featuredOnly) {
      query = query.eq('is_featured', true);
    }

    final response = await query.order('display_order');

    return (response as List)
        .map((json) => WellnessResourceModel.fromJson(json))
        .toList();
  }

  Future<List<WellnessResourceModel>> getSavedResources() async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('saved_resources')
        .select('wellness_resources(*)')
        .eq('user_id', userId)
        .order('saved_at', ascending: false);

    return (response as List)
        .map((json) => WellnessResourceModel.fromJson(json['wellness_resources']))
        .toList();
  }

  Future<void> saveResource(String resourceId) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('saved_resources').insert({
      'user_id': userId,
      'resource_id': resourceId,
    });
  }

  Future<void> unsaveResource(String resourceId) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('saved_resources').delete()
        .eq('user_id', userId)
        .eq('resource_id', resourceId);
  }

  Future<bool> isResourceSaved(String resourceId) async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('saved_resources')
        .select('resource_id')
        .eq('user_id', userId)
        .eq('resource_id', resourceId)
        .maybeSingle();
    return response != null;
  }
}