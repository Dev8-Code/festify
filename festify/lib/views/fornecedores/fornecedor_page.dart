// lib/views/fornecedores/fornecedor_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/fornecedor_model.dart';
import '../../providers/fornecedor_provider.dart';

class FornecedorPage extends ConsumerWidget {
  const FornecedorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fornecedoresAsync = ref.watch(fornecedoresProvider);
    final nomeController = TextEditingController();
    final tipoController = TextEditingController();
    final contatoController = TextEditingController();
    final telefoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Fornecedores')),
      body: Column(
        children: [
          Expanded(
            child: fornecedoresAsync.when(
              data: (fornecedores) => ListView.builder(
                itemCount: fornecedores.length,
                itemBuilder: (context, index) {
                  final f = fornecedores[index];
                  return ListTile(
                    title: Text(f.nome),
                    subtitle: Text('${f.tipo} - ${f.contato}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => ref.read(deletarFornecedorProvider)(f.id),
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
                TextField(controller: tipoController, decoration: InputDecoration(labelText: 'Tipo')),
                TextField(controller: contatoController, decoration: InputDecoration(labelText: 'Contato')),
                TextField(controller: telefoneController, decoration: InputDecoration(labelText: 'Telefone')),
                ElevatedButton(
                  onPressed: () {
                    final fornecedor = Fornecedor(
                      id: '',
                      nome: nomeController.text,
                      tipo: tipoController.text,
                      contato: contatoController.text,
                      telefone: telefoneController.text,
                    );
                    ref.read(criarFornecedorProvider)(fornecedor);
                  },
                  child: Text('Adicionar Fornecedor'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}