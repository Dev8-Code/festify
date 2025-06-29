import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataEventoProvider = StateProvider<String>((ref) => '');
final horaEventoProvider = StateProvider<String>((ref) => '');
final diasMontagemProvider = StateProvider<String>((ref) => '');
final diasDesmontagemProvider = StateProvider<String>((ref) => '');
final pagadorBeneficiarioProvider = StateProvider<bool?>((ref) => null);
final beneficiarioProvider = StateProvider<String>((ref) => '');
final isLoadingCadastroEventoProvider = StateProvider<bool>((ref) => false);
final tipoEventoProvider = StateProvider<String>((ref) => '');
final idClienteSelecionadoProvider = StateProvider<int>((ref) => 0);
final idEventoCriadoProvider = StateProvider<int>((ref) => 0);
