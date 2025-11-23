import 'package:flutter_riverpod/flutter_riverpod.dart';

final nomeOperadorProvider = StateProvider<String>((ref) => '');
final cpfOperadorProvider = StateProvider<String>((ref) => '');
final emailOperadorProvider = StateProvider<String>((ref) => '');
final telefoneOperadorProvider = StateProvider<String>((ref) => '');
final senhaOperadorProvider = StateProvider<String>((ref) => '');
final repetirSenhaOperadorProvider = StateProvider<String>((ref) => '');
final senhaVisivelOperadorProvider = StateProvider<bool>((ref) => false);
final repetirSenhaVisivelOperadorProvider = StateProvider<bool>((ref) => false);
