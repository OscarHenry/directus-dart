import 'package:dio/dio.dart';
import 'package:directus/src/data_classes/data_classes.dart';
import 'package:directus/src/data_classes/directus_item.dart';

typedef T CreateItem<T>(params);

/// Handler for fetching data from Directus API
/// Provides CRUD API
class ItemsHandler<T> {
  /// HTTP Client
  Dio client;

  /// Collection endpoint
  /// It's `/items/$collection` for normal collections and `/$collection` for system collection
  final String _endpoint;

  ItemsHandler(String collection, {required this.client, DirectusItem? convert})
      : _endpoint = collection.startsWith('directus_')
            ? '/${collection.substring(9)}'
            : '/items/${collection}';

  /// Get item by ID
  ///
  /// [id] is [String] or [int], but Dart does not allow
  Future<DirectusResponse<T>> readOne(String id) async {
    final response = await client.get('$_endpoint/$id');
    return DirectusResponse<T>(response);
  }

  /// Get many items
  /// ```dart
  /// await this.readMany(query: Query(
  ///   filter: Filters([
  ///     Filter('a', 'b')
  ///   ])
  /// ));
  /// ```
  Future<DirectusResponse<List<T>>> readMany({Query? query}) async {
    final response = await client.get<ItemsHandler>(
      '$_endpoint',
      queryParameters: query?.toMap(),
    );
    return DirectusResponse<List<T>>(response);
  }

  /// Create one item
  Future<DirectusResponse<T>> createOne(Map data) async {
    final response = await client.post('$_endpoint', data: data);
    return DirectusResponse<T>(response);
  }

  /// Update single item
  Future<DirectusResponse<T>> updateOne({required Map data, required String id}) async {
    final response = await client.patch('$_endpoint/$id', data: data);
    return DirectusResponse<T>(response);
  }

  /// Update many items
  Future<DirectusResponse<List<T>>> updateMany(
      {required List<String> ids, required Map data}) async {
    final response = await client.patch(
      '$_endpoint/${ids.join(',')}',
      data: data,
    );
    return DirectusResponse<List<T>>(response);
  }

  /// Delete item by ID
  Future<void> deleteOne(String id) async {
    final response = await client.delete('$_endpoint/$id');
    return response.data;
  }

  /// Delete many items
  Future<void> deleteMany(List<String> ids) async {
    final csvKeys = ids.join(',');
    await client.delete('$_endpoint/$csvKeys');
  }
}
