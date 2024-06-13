import '../core/core.dart';
import '../http/http.dart';

/// The [RequestContext] class is used to create the request context.
final class RequestContext {
  
  /// The [providers] property contains the providers of the request context.
  final Map<Type, Provider> providers;

  /// The [request] property contains the request of the context.
  final Request request;

  /// The [body] property contains the body of the context.
  Body get body => request.body ?? Body.empty();

  /// The [path] property contains the path of the request.
  String get path => request.path;

  /// The [method] property contains the method of the request.
  Map<String, dynamic> get headers => request.headers;

  /// The [add] method is used to add data to the request.
  void add(String key, dynamic value) {
    request.addData(key, value);
  }

  /// The [get] method is used to get data from the request.
  dynamic get(String key) {
    return request.getData(key);
  }

  /// The [params] property contains the path parameters of the request.
  Map<String, dynamic> get params => request.params;

  /// The [queryParameters] property contains the query parameters of the request.
  Map<String, dynamic> get queryParameters => request.queryParameters;

  /// The constructor of the [RequestContext] class.
  RequestContext(
    this.providers,
    this.request,
  );

  /// This method is used to retrieve a provider from the context.
  T use<T>() {
    if (!providers.containsKey(T)) {
      throw StateError('Provider not found in request context');
    }
    return providers[T] as T;
  }
}
