import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';
import '../providers/event_providers.dart';
import 'package:festify/src/features/custom_app_bar.dart';
import 'package:festify/src/features/custom_bottom_nav_bar.dart';
import 'package:festify/src/features/custom_drawer.dart';

class CadastroEventoPage extends ConsumerStatefulWidget {
  final int? idCliente;

  const CadastroEventoPage({super.key, this.idCliente});

  @override
  ConsumerState<CadastroEventoPage> createState() => _CadastroEventoPageState();
}

class _CadastroEventoPageState extends ConsumerState<CadastroEventoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeBeneficiarioController = TextEditingController();
  final _beneficiarioController = TextEditingController();
  final _tipoEventoController = TextEditingController();
  final _dataEventoController = TextEditingController();
  final _horaEventoController = TextEditingController();
  final _diasMontagemController = TextEditingController();
  final _diasDesmontagemController = TextEditingController();

  bool _isLoading = false;
  int? _idClienteAtual;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is int) {
        _idClienteAtual = args;
      } else if (widget.idCliente != null) {
        _idClienteAtual = widget.idCliente;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nomeBeneficiarioController.dispose();
    _beneficiarioController.dispose();
    _tipoEventoController.dispose();
    _dataEventoController.dispose();
    _horaEventoController.dispose();
    _diasMontagemController.dispose();
    _diasDesmontagemController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData(List<DateTime> datasBloqueadas) async {
    final today = DateTime.now();
    final firstDate = DateTime(today.year, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime(today.year + 1, today.month, today.day),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      // Verifica se a data escolhida já está bloqueada
      bool isBloqueada = datasBloqueadas.any((d) =>
          d.year == picked.year && d.month == picked.month && d.day == picked.day);

      if (isBloqueada) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Data ocupada'),
              content: const Text('Essa data já está cadastrada. Por favor, escolha outro dia.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return;
      }

      final dataFormatada =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
      _dataEventoController.text = dataFormatada;
    }
  }

  Future<void> _selecionarHora() async {
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
      final horaFormatada =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      _horaEventoController.text = horaFormatada;
    }
  }

  Future<void> _salvarEvento() async {
    if (!_formKey.currentState!.validate()) return;

    if (_beneficiarioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, responda se o pagador é o beneficiário!'),
        ),
      );
      return;
    }

    if (_idClienteAtual == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente não selecionado!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dataParts = _dataEventoController.text.split('/');
      final dataFormatada = '${dataParts[2]}-${dataParts[1]}-${dataParts[0]}';
      final horaSelecionada = _horaEventoController.text.trim();

      // Verifica conflito com eventos existentes
      final eventosExistentes = await EventService.buscarEventos();
      final existeConflito = eventosExistentes.any((e) =>
          e.dataEvento == dataFormatada && e.horaEvento == horaSelecionada);

      if (existeConflito) {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Data/Horário ocupado'),
              content: const Text(
                  'Já existe um evento cadastrado nesse dia e horário. Escolha outro.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return; // Não salva
      }

      final evento = Evento(
        NomeBeneficiario: _nomeBeneficiarioController.text.trim(),
        beneficiario: _beneficiarioController.text.trim(),
        tipoEvento: _tipoEventoController.text.trim(),
        dataEvento: dataFormatada,
        horaEvento: horaSelecionada,
        diasMontagem: int.parse(_diasMontagemController.text),
        diasDesmontagem: int.parse(_diasDesmontagemController.text),
        idCliente: _idClienteAtual!,
      );

      final idEvento = await EventService.salvarEvento(evento);

      // ignore: unnecessary_null_comparison
      if (idEvento != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento cadastrado com sucesso!')),
        );
        Navigator.of(context)
            .pushNamed('/cadastro-pagamento', arguments: idEvento);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar evento!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final labelColor = isDark ? Colors.white70 : Colors.black54;
    final borderColor = isDark ? Colors.white70 : Colors.black45;
    final iconColor = labelColor;

    final datasEventosAsync = ref.watch(datasEventosProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const MyDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _idClienteAtual == null
          ? const Center(child: CircularProgressIndicator())
          : datasEventosAsync.when(
              data: (datasBloqueadas) => SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Preencha os campos abaixo',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textColor, fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Cliente ID: $_idClienteAtual',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildDatePicker(context, textColor, labelColor, borderColor, iconColor, datasBloqueadas),
                      _buildTimePicker(context, textColor, labelColor, borderColor, iconColor),
                      _buildInput(
                        controller: _tipoEventoController,
                        label: 'Tipo de evento',
                        textColor: textColor,
                        labelColor: labelColor,
                        borderColor: borderColor,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Campo obrigatório' : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInput(
                              controller: _diasMontagemController,
                              label: 'Dias para montagem',
                              textColor: textColor,
                              labelColor: labelColor,
                              borderColor: borderColor,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Campo obrigatório';
                                if (int.tryParse(value) == null) return 'Digite um número válido';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInput(
                              controller: _diasDesmontagemController,
                              label: 'Dias para desmontagem',
                              textColor: textColor,
                              labelColor: labelColor,
                              borderColor: borderColor,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Campo obrigatório';
                                if (int.tryParse(value) == null) return 'Digite um número válido';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'O pagador é o beneficiário?',
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('Sim', style: TextStyle(color: textColor)),
                              value: 'sim',
                              groupValue: _beneficiarioController.text.isEmpty ? null : _beneficiarioController.text,
                              onChanged: (value) => setState(() => _beneficiarioController.text = value!),
                              activeColor: Colors.amber,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('Não', style: TextStyle(color: textColor)),
                              value: 'não',
                              groupValue: _beneficiarioController.text.isEmpty ? null : _beneficiarioController.text,
                              onChanged: (value) => setState(() => _beneficiarioController.text = value!),
                              activeColor: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInput(
                        controller: _nomeBeneficiarioController,
                        label: 'Beneficiário/Pagador',
                        textColor: textColor,
                        labelColor: labelColor,
                        borderColor: borderColor,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _isLoading
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
                                onPressed: _salvarEvento,
                                child: const Text('Ir para pagamento'),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erro ao carregar datas: $err')),
            ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required Color textColor,
    required Color labelColor,
    required Color borderColor,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: textColor),
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: labelColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
        ),
      );

  Widget _buildDatePicker(
    BuildContext context,
    Color textColor,
    Color labelColor,
    Color borderColor,
    Color iconColor,
    List<DateTime> datasBloqueadas,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: GestureDetector(
          onTap: () => _selecionarData(datasBloqueadas),
          child: AbsorbPointer(
            child: TextFormField(
              controller: _dataEventoController,
              style: TextStyle(color: textColor),
              validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              decoration: InputDecoration(
                labelText: 'Data Evento',
                labelStyle: TextStyle(color: labelColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.amber, width: 2),
                ),
                suffixIcon: Icon(Icons.calendar_today, color: iconColor),
              ),
            ),
          ),
        ),
      );

  Widget _buildTimePicker(
    BuildContext context,
    Color textColor,
    Color labelColor,
    Color borderColor,
    Color iconColor,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: GestureDetector(
          onTap: _selecionarHora,
          child: AbsorbPointer(
            child: TextFormField(
              controller: _horaEventoController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Hora Evento',
                labelStyle: TextStyle(color: labelColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.amber, width: 2),
                ),
                suffixIcon: Icon(Icons.access_time, color: iconColor),
              ),
            ),
          ),
        ),
      );
}
