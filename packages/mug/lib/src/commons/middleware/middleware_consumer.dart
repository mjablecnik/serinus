import 'package:mug/mug.dart';

class MiddlewareConsumer{

  MugMiddleware? _middleware;

  MugMiddleware? get middleware => _middleware;

  List<ConsumerRoute> _excludedRoutes = [];
  List<ConsumerRoute> _forRoutes = [];

  List<ConsumerRoute> get excludedRoutes => _excludedRoutes;
  List<ConsumerRoute> get forRoutes => _forRoutes;

  MiddlewareConsumer apply(MugMiddleware middleware, {List<ConsumerRoute> forRoutes = const []}){
    _middleware = middleware;
    _forRoutes = forRoutes;
    return this;
  }

  void excludeRoutes(List<ConsumerRoute> routes){
    if(routes.any((element) => forRoutes.indexWhere((route) => route.uri == element.uri && element.method == route.method) > -1)){
      throw new StateError("You can't exclude a route set in forRoutes!");
    }
    _excludedRoutes.clear();
    _excludedRoutes.addAll(routes);
  }

}