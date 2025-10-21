import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  final initialResult = await connectivity.checkConnectivity();
  yield initialResult != ConnectivityResult.none;

  yield* connectivity.onConnectivityChanged
      .map((status) => status != ConnectivityResult.none);
});
