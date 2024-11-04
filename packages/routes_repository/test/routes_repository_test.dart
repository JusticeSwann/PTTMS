import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routes_repository/routes_repository.dart';
import 'dart:convert';

void main() {
  // Ensure binding is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  test('test route loading', () async {
    // Define the mock JSON as a valid JSON string
    const String mockJson = '''
    [
      {"name": "test-route1"},
      {"name": "test-route2"}
    ]
    ''';

    // Set up a mock for rootBundle's loadString to return the mock JSON
    final byteData = ByteData.sublistView(Utf8Encoder().convert(mockJson));
    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (message) async {
        return byteData;
      },
    );

    // Initialize the repository and load routes
    final repository = RoutesRepository();
    final routes = await repository.loadRoutes();

    // Assertions
    expect(routes, isNotEmpty);          // Expect non-empty list
    expect(routes.length, 2);            // Expect two routes in list
    expect(routes[0].name, 'test-route1'); // Verify first route's name
    expect(routes[1].name, 'test-route2'); // Verify second route's name
  });
}
