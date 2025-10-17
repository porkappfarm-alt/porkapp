import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final connectivityProvider = StreamProvider<bool>((ref) async* {
  final checker = InternetConnectionCheckerPlus();
  yield await checker.hasConnection;
  yield* checker.onStatusChange
      .map((status) => status == InternetConnectionStatus.connected);
});
