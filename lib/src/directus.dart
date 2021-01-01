// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:directus/src/adapters/shared_preferences_storage.dart';
import 'package:directus/src/data_classes/directus_error.dart';
import 'package:directus/src/data_classes/directus_storage.dart';
import 'package:directus/src/modules/items/items_converter.dart';
import 'package:meta/meta.dart';

import 'modules/handlers.dart';
import 'modules/items/map_items_converter.dart';

bool _isDirectusInitialized = false;

class Directus {
  /// [Dio] client used for HTTP requests.
  @protected
  @visibleForTesting
  final Dio client;

  /// Storage used for persisting data.
  final DirectusStorage _storage;

  /// Constructor with all provided services.
  Directus(String url, {required DirectusStorage? storage, Dio? client})
      : _storage = storage ?? SharedPreferencesStorage(),
        client = client ?? Dio(BaseOptions(baseUrl: url)) {
    // Check if SDK is inited before each request
    this.client.interceptors.add(InterceptorsWrapper(
      onRequest: (options) {
        if (!_isDirectusInitialized) {
          throw DirectusError(message: 'You must first await init method', code: 1000);
        }
        return options;
      },
    ));
  }

  /// Initialize SDK.
  ///
  /// This method must be called before using any other method.
  ///
  /// It returns [Directus] object in which this method is called.
  /// This way simpla chaining is possible without using `..init()`.
  /// For example:
  /// ```dart
  /// sdk = await Directus(url).init();
  /// ```
  Future<Directus> init() async {
    await auth.init();
    _isDirectusInitialized = true;
    return this;
  }

  /// Auth
  late AuthHandler auth = AuthHandler(client: client, storage: _storage);

  /// Items
  ItemsHandler<Map<String, dynamic>> items(String collection) =>
      typedItems<Map<String, dynamic>>(collection, converter: MapItemsConverter());

  /// Get items from API with strong typings.
  ///
  /// [ItemsConverter] must be provided that will convert data to
  /// and from json. If you don't care about types, use [items],
  /// that will return [Map]. [converter] is a simple interface that converts value to
  /// and from JSON so it can be consumed with this API.
  ItemsHandler<T> typedItems<T>(String collection, {required ItemsConverter<T> converter}) {
    if (collection.startsWith('directus')) {
      throw DirectusError(
        message: 'You can\'t read $collection collection directly.',
        code: 1000,
      );
    }
    return ItemsHandler<T>(collection, client: client, converter: converter);
  }

  /// Activity
  ActivityHandler get activity => ActivityHandler(client: client);

  /// Collections
  CollectionsHandler get collections => CollectionsHandler(client: client);

  /// HTTP client that can be used for accessing custom extensions.
  Dio get custom => client;

  /// Fields
  FieldsHandler get fields => FieldsHandler(client: client);

  /// Files
  FilesHandler get files => FilesHandler(client: client);

  /// Folders
  FoldersHandler get folders => FoldersHandler(client: client);

  /// Permissions
  PermissionsHandler get permissions => PermissionsHandler(client: client);

  /// Presets
  PresetsHandler get presets => PresetsHandler(client: client);

  /// Relations
  RelationsHandler get relations => RelationsHandler(client: client);

  /// Revisions
  RevisionsHandler get revisions => RevisionsHandler(client: client);

  /// Roles
  RolesHandler get roles => RolesHandler(client: client);

  /// Server
  ServerHandler get server => ServerHandler(client: client);

  /// Settings
  SettingsHandler get settings => SettingsHandler(client: client);

  /// Users
  UsersHandler get users => UsersHandler(client: client);

  /// Utils
  UtilsHandler get utils => UtilsHandler(client: client);
}