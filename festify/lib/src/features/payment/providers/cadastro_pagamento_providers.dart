import 'package:flutter_riverpod/flutter_riverpod.dart';

final valorContratoProvider = StateProvider<String>((ref) => '');
final valorPagoProvider = StateProvider<String>((ref) => '');
final qtdeParcelasProvider = StateProvider<String>((ref) => '');
final dataVencimentoProvider = StateProvider<String>((ref) => '');
final isLoadingCadastroPagamentoProvider = StateProvider<bool>((ref) => false);
