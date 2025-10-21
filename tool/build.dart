import 'dart:io';

void main() async {
  print('🚀 Starting build process...');

  print('\n📦 Running flutter pub get...');
  await _runCommand('flutter', ['pub', 'get']);

  print('\n🧹 Cleaning build files...');
  await _runCommand('dart', ['run', 'build_runner', 'clean']);

  print('\n🏗️ Building generated files...');
  await _runCommand('dart', [
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ]);

  print('\n✅ Build process completed!');
}

Future<void> _runCommand(String command, List<String> arguments) async {
  final result = await Process.run(command, arguments);
  if (result.stdout.toString().isNotEmpty) {
    print(result.stdout);
  }
  if (result.stderr.toString().isNotEmpty) {
    print(result.stderr);
  }
  if (result.exitCode != 0) {
    print('❌ Command failed with exit code ${result.exitCode}');
    exit(result.exitCode);
  }
}
