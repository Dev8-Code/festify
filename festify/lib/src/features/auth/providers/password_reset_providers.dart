import 'package:flutter_riverpod/flutter_riverpod.dart';
export 'auth_providers.dart' show isLoadingProvider;

final emailProvider = StateProvider<String>((ref) => '');
