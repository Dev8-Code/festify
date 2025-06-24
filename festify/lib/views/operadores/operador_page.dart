// lib/views/operadores/operador_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/operador_model.dart';
import '../../providers/operador_provider.dart';

class OperadorPage extends ConsumerWidget {
  const OperadorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operadoresAsync = ref.watch(operadoresProvider);
    final nomeController = TextEditingController();
    final emailController = TextEditingController();
    final telefoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Operadores')),
      body: Column(
        children: [
          Expanded(
            child: operadoresAsync.when(
              data: (operadores) => ListView.builder(
                itemCount: operadores.length,
                itemBuilder: (context, index) {
                  final o = operadores[index];
                  return ListTile(
                    title: Text(o.nome),
                    subtitle: Text('${o.email} - ${o.telefone}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => ref.read(deletarOperadorProvider)(o.id),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Erro: $err'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: nomeController, decoration: InputDecoration(labelText: 'Nome')),
                TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
                TextField(controller: telefoneController, decoration: InputDecoration(labelText: 'Telefone')),
                ElevatedButton(
                  onPressed: () {
                    final operador = Operador(
                      id: '',
                      nome: nomeController.text,
                      email: emailController.text,
                      telefone: telefoneController.text,
                    );
                    ref.read(criarOperadorProvider)(operador);
                  },
                  child: Text('Adicionar Operador'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}