import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

import 'app.dart';
import 'data/expense_repository.dart';
import 'logic/expense_store.dart';

/// Opt in to Flutter Driver so the official Dart and Flutter MCP server can
/// screenshot, tap and type in the app:
///
///   flutter run --dart-define=ENABLE_FLUTTER_DRIVER=true
const bool _enableFlutterDriver = bool.fromEnvironment('ENABLE_FLUTTER_DRIVER');

void main() {
  // Flutter allows only ONE binding per process, so the app picks one agent
  // bridge at startup. Neither ever ships in a release build.
  if (_enableFlutterDriver && !kReleaseMode) {
    // Bridge 1: Flutter Driver, used by the Dart and Flutter MCP server.
    enableFlutterDriverExtension();
  } else if (kDebugMode) {
    // Bridge 2 (default in debug): Marionette, used by Marionette MCP.
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }

  final store = ExpenseStore(
    repository: ExpenseRepository.withSampleData(DateTime.now()),
  );
  runApp(SpendTrackerApp(store: store));
}
