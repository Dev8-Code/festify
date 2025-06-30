import 'package:flutter_riverpod/flutter_riverpod.dart';

final razaoSocialProvider = StateProvider<String>((ref) => '');
final cnpjProvider = StateProvider<String>((ref) => '');
final responsavelProvider = StateProvider<String>((ref) => '');
final emailJuridicoProvider = StateProvider<String>((ref) => '');
final telefoneJuridicoProvider = StateProvider<String>((ref) => '');

final isLoadingCadastroJuridicoProvider = StateProvider<bool>((ref) => false);
