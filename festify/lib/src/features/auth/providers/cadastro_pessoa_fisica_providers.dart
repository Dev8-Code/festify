import 'package:flutter_riverpod/flutter_riverpod.dart';

// Campos do formulário
final nomeProvider = StateProvider<String>((ref) => '');
final cpfProvider = StateProvider<String>((ref) => '');
final rgProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => '');
final telefoneProvider = StateProvider<String>((ref) => '');
final cepProvider = StateProvider<String>((ref) => '');
final numeroProvider = StateProvider<String>((ref) => '');
final logradouroProvider = StateProvider<String>((ref) => '');
final bairroProvider = StateProvider<String>((ref) => '');
final cidadeProvider = StateProvider<String>((ref) => '');
final estadoProvider = StateProvider<String>((ref) => '');

// Estado de carregamento
final isLoadingCadastroProvider = StateProvider<bool>((ref) => false);