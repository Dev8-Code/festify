// lib/views/clientes/cliente_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/cliente_model.dart';
import '../../providers/cliente_provider.dart';

class ClientePage extends ConsumerWidget {
  const ClientePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientesAsync = ref.watch(clientesProvider);
    final nomeController = TextEditingController();
    final tipoController = TextEditingController();
    final docController = TextEditingController();
    final telefoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Column(
        children: [
          Expanded(
            child: clientesAsync.when(
              data: (clientes) => ListView.builder(
                itemCount: clientes.length,
                itemBuilder: (context, index) {
                  final c = clientes[index];
                  return ListTile(
                    title: Text(c.nome),
                    subtitle: Text('${c.tipo} - ${c.documento}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => ref.read(deletarClienteProvider)(c.id),
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
                TextField(controller: tipoController, decoration: InputDecoration(labelText: 'Tipo (PF/PJ)')),
                TextField(controller: docController, decoration: InputDecoration(labelText: 'Documento')),
                TextField(controller: telefoneController, decoration: InputDecoration(labelText: 'Telefone')),
                ElevatedButton(
                  onPressed: () {
                    final cliente = Cliente(
                      id: '',
                      nome: nomeController.text,
                      tipo: tipoController.text,
                      documento: docController.text,
                      telefone: telefoneController.text,
                    );
                    ref.read(criarClienteProvider)(cliente);
                  },
                  child: Text('Adicionar Cliente'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}