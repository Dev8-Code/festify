import 'package:flutter_riverpod/flutter_riverpod.dart';

// Campos do formulário
final nomeProvider = StateProvider<String>((ref) => '');
final cpfProvider = StateProvider<String>((ref) => '');
final rgProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => '');
final telefoneProvider = StateProvider<String>((ref) => '');

// Estado de carregamento
final isLoadingCadastroProvider = StateProvider<bool>((ref) => false);