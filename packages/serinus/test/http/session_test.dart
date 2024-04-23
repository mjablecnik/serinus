import 'dart:convert';
import 'dart:io';

import 'package:serinus/serinus.dart';
import 'package:test/test.dart';

class TestRoute extends Route {
  
  const TestRoute({
    required super.path,
    super.method = HttpMethod.get,
  });
  
}

class TestJsonObject with JsonObject {

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': 'json-obj'
    };
  }

}

class TestController extends Controller{
  
  TestController({super.path = '/'}){
    on(TestRoute(path: '/session'), (context) async {
      final isNew = context.request.session.isNew;
      if(isNew){
        context.request.session.put('sessionNew', true);
      }else{
        context.request.session.put('sessionNew', false);
      }
      return Response.json({
        'isSessionNew': context.request.session.get('sessionNew'),
      });
    });
  }

}

class TestModule extends Module {
  
  TestModule({
    super.controllers,
    super.imports,
    super.providers,
    super.exports
  });
  
}

class SessionsTestSuite {

  static void runTests(){
    group(
      '$Session', 
      () {
        SerinusApplication? app;
        setUpAll(() async {
          app = await serinus.createApplication(
            entrypoint: TestModule(controllers: [TestController()]),
            loggingLevel: LogLevel.none,
          );
          await app?.serve();
        });
        tearDownAll(() async {
          await app?.close();
        });
        test(
          '''when the first request of session is handled, then the session should be new''',
          () async {
            final request = await HttpClient().getUrl(Uri.parse('http://localhost:3000/session'));
            final response = await request.close();
            final body = await response.transform(Utf8Decoder()).join();

            expect(response.headers.contentType?.mimeType, 'application/json');
            expect(jsonDecode(body), {'isSessionNew': true});
          }
        );

        test(
          '''when the second request of session is handled, then the session should not be new''',
          () async {
            var request = await HttpClient().getUrl(Uri.parse('http://localhost:3000/session'));
            var response = await request.close();
            request = await HttpClient().getUrl(Uri.parse('http://localhost:3000/session'),);
            request.headers.add('Cookie', response.headers['set-cookie']!);
            response = await request.close();
            final body = await response.transform(Utf8Decoder()).join();

            expect(response.headers.contentType?.mimeType, 'application/json');
            expect(jsonDecode(body), {'isSessionNew': false});
          }
        );
      }
    ); 
  }

}