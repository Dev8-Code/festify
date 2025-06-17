import 'package:festify/src/features/custom_app_bar.dart';
import 'package:festify/src/features/custom_bottom_nav_bar.dart';
import 'package:festify/src/features/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cadastro_evento_providers.dart';

class CadastroEventoPage extends ConsumerWidget {
  const CadastroEventoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipoEvento = ref.watch(tipoEventoProvider);
    final diasMontagem = ref.watch(diasMontagemProvider);
    final pagadorBeneficiario = ref.watch(pagadorBeneficiarioProvider);
    final isLoading = ref.watch(isLoadingCadastroEventoProvider);
    final beneficiario = ref.watch(beneficiarioProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const MyDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Preencha os campos abaixo',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 24),
            _buildDatePicker(context, ref),
            _buildTimePicker(context, ref),
            _buildInput(ref, 'Tipo de evento', tipoEventoProvider),
                        Row(
              children: [
                Expanded(
                  child: _buildInput(ref, 'Dias para montagem', diasMontagemProvider),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInput(ref, 'Dias para desmontagem', diasDesmontagemProvider),
                ),
              ],
            ),


            const SizedBox(height: 16),
            const Text(
              'O pagador é o beneficiário?',
              style: TextStyle(color: Colors.white70),
            ),
            Row(
              children: [
                Checkbox(
                  value: pagadorBeneficiario == true,
                  onChanged: (value) {
                    if (value == true) {
                      ref.read(pagadorBeneficiarioProvider.notifier).state = true;
                    }
                  },
                ),
                const Text('Sim', style: TextStyle(color: Colors.white)),
                const SizedBox(width: 16),
                Checkbox(
                  value: pagadorBeneficiario == false,
                  onChanged: (value) {
                    if (value == true) {
                      ref.read(pagadorBeneficiarioProvider.notifier).state = false;
                    }
                  },
                ),
                const Text('Não', style: TextStyle(color: Colors.white)),
              ],
            ),

            const SizedBox(height: 16),
            _buildInput(ref, 'Beneficiário/Pagador', beneficiarioProvider),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.yellow))
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        foregroundColor: const Color(0xFF121E30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                          final diasDesmontagem = ref.watch(diasDesmontagemProvider);
                            if ([tipoEvento, diasMontagem, diasDesmontagem, beneficiario].any((e) => e.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Preencha todos os campos')),
                          );
                          return;
                        }

                        ref.read(isLoadingCadastroEventoProvider.notifier).state = true;
                        await Future.delayed(const Duration(seconds: 1));
                        ref.read(isLoadingCadastroEventoProvider.notifier).state = false;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Evento salvo! Indo para pagamento...')),
                        );

                        Navigator.of(context).pushNamed('/cadastro-pagamento');
                      },
                      child: const Text('Ir para pagamento'),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildInput(WidgetRef ref, String label, StateProvider<String> provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        onChanged: (value) => ref.read(provider.notifier).state = value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataEventoProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            locale: const Locale('pt', 'BR'),
          );
          if (picked != null) {
            final dataFormatada = '${picked.day.toString().padLeft(2, '0')}/'
                '${picked.month.toString().padLeft(2, '0')}/'
                '${picked.year}';
            ref.read(dataEventoProvider.notifier).state = dataFormatada;
          }
        },
        child: AbsorbPointer(
          child: TextField(
            controller: TextEditingController(text: data),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Data Evento',
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white70),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.amber, width: 2),
              ),
              suffixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }

Widget _buildTimePicker(BuildContext context, WidgetRef ref) {
  final hora = ref.watch(horaEventoProvider);

  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (picked != null) {
          final horaFormatada = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
          ref.read(horaEventoProvider.notifier).state = horaFormatada;
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(text: hora),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Hora Evento',
            labelStyle: const TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white70),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.amber, width: 2),
            ),
            suffixIcon: const Icon(Icons.access_time, color: Colors.white70),
          ),
        ),
      ),
    ),
  );
}


}

