import 'package:directus/src/handlers/items_handler.dart';
import 'package:directus/src/handlers/collections_handler.dart';
import 'package:test/test.dart';

import '../mock/mock_dio.dart';

void main() {
  test('that CollectionsHandler extends ItemsHandler.', () async {
    final collections = CollectionsHandler(client: MockDio());

    expect(collections, isA<ItemsHandler>());
  });
}
