import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porkapp/shared/providers/connectivity_provider.dart';

class OfflineIndicator extends ConsumerWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement connectivity provider
    var isOffline = ref.watch(connectivityProvider).maybeWhen(
          data: (isConnected) => !isConnected,
          orElse: () => false,
        );

    if (!isOffline) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.red
            .withAlpha(25), // 0.1 opacity is approximately 25/255 in alpha
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off, size: 16, color: Colors.red[700]),
          const SizedBox(width: 4),
          Text(
            'Offline',
            style: TextStyle(
              color: Colors.red[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
