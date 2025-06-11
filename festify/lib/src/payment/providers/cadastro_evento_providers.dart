import 'package:flutter_riverpod/flutter_riverpod.dart';

final tipoEventoProvider = StateProvider<String>((ref) => '');
final diasMontagemProvider = StateProvider<String>((ref) => '');
final pagadorBeneficiarioProvider = StateProvider<bool?>((ref) => null);
final beneficiarioProvider = StateProvider<String>((ref) => '');
final isLoadingCadastroEventoProvider = StateProvider<bool>((ref) => false);
