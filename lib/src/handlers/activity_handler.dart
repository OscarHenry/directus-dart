import 'package:dio/dio.dart';
import 'package:directus/src/data_classes/data_classes.dart';
import 'package:directus/src/handlers/items_handler.dart';

class ActivityHandler {
  Dio client;
  ItemsHandler handler;

  ActivityHandler({required this.client})
      : handler = ItemsHandler('directus_activity', client: client);

  Future<DirectusResponse<Map>> readOne(String key) async {
    return handler.readOne(key);
  }

  Future<DirectusResponse<List<Map>>> readMany({Query? query}) async {
    return handler.readMany(query: query);
  }

  /// Create comment
  Future<DirectusResponse<Map>> createComment({
    required String collection,
    required String itemId,
    required String comment,
  }) async {
    return DirectusResponse.fromRequest(
      () => client.post(
        '/activity/comments',
        data: {'collection': collection, 'item': itemId, 'comment': comment},
      ),
    );
  }

  /// Update existing comment
  Future<DirectusResponse<Map>> updateComment({
    required String id,
    required String comment,
  }) async {
    return DirectusResponse.fromRequest(
      () => client.patch(
        '/activity/comments/$id',
        data: {'comment': comment},
      ),
    );
  }

  /// Delete comment
  Future<void> deleteComment(String key) async {
    try {
      await client.delete('/activity/comments/$key');
    } catch (e) {
      throw DirectusError.fromDio(e);
    }
  }
}
