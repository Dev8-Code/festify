import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> deleteClient({
  required BuildContext context,
  required int idCliente,
}) async {
  try {
    await Supabase.instance.client
        .from('clientes')
        .delete()
        .eq('id_cliente', idCliente);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cliente excluído com sucesso!')),
    );

    return 'success';
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Erro ao excluir cliente: $e')));

    return 'error';
  }
}
