import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/contract_service.dart';
import '../../features/custom_app_bar.dart';
import '../../features/custom_bottom_nav_bar.dart';
import '../../features/custom_drawer.dart';

class CadastroPagamentoPage extends ConsumerStatefulWidget {
  final int? idEvento;

  const CadastroPagamentoPage({super.key, this.idEvento});

  @override
  ConsumerState<CadastroPagamentoPage> createState() =>
      _CadastroPagamentoPageState();
}

class _CadastroPagamentoPageState extends ConsumerState<CadastroPagamentoPage> {
  final _formKey = GlobalKey<FormState>();
  final _parcelasController = TextEditingController();
  final _dataVencimentoController = TextEditingController();
  final _valorContratoController = TextEditingController();
  final _valorPagoController = TextEditingController();
  final _tituloContratoController = TextEditingController();

  bool _isLoading = false;
  int? _idEventoAtual;

  @override
  void initState() {
    super.initState();
    // Pega o ID do evento dos argumentos ou do widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is int) {
        _idEventoAtual = args;
      } else if (widget.idEvento != null) {
        _idEventoAtual = widget.idEvento;
      }

      if (_idEventoAtual != null) {
        _tituloContratoController.text = 'Contrato do Evento $_idEventoAtual';
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _parcelasController.dispose();
    _dataVencimentoController.dispose();
    _valorContratoController.dispose();
    _valorPagoController.dispose();
    _tituloContratoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarDataVencimento() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      final dataFormatada =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
      _dataVencimentoController.text = dataFormatada;
    }
  }

  Future<void> _cadastrarContrato() async {
    if (!_formKey.currentState!.validate()) return;

    if (_idEventoAtual == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Evento não identificado!')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Converte a data do formato dd/MM/yyyy para yyyy-MM-dd para o backend
      final dataVencimento = _dataVencimentoController.text;
      String dataFormatadaBackend = dataVencimento;
      if (dataVencimento.contains('/')) {
        final parts = dataVencimento.split('/');
        if (parts.length == 3) {
          dataFormatadaBackend = '${parts[2]}-${parts[1]}-${parts[0]}';
        }
      }

      final idContrato = await ContractService.cadastrarContrato(
        idEvento: _idEventoAtual!,
        parcelas: int.parse(_parcelasController.text),
        dataVencimento: dataFormatadaBackend,
        valorContrato: double.parse(
          _valorContratoController.text.replaceAll(',', '.'),
        ),
        valorPago: double.parse(_valorPagoController.text.replaceAll(',', '.')),
        tituloContrato: _tituloContratoController.text.trim(),
      );

      if (idContrato != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contrato cadastrado com sucesso!')),
          );

          // Voltar para a home ou tela anterior
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home-page', (route) => false);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao cadastrar contrato!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final labelColor = Theme.of(context).textTheme.labelLarge?.color;
    final borderColor = Theme.of(context).colorScheme.outline;

    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const MyDrawer(),
      body:
          _idEventoAtual == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Preencha as informações de pagamento',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),

                      // Card com info do evento
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Evento ID: $_idEventoAtual',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Título do Contrato
                      _buildStyledTextField(
                        controller: _tituloContratoController,
                        label: 'Título do Contrato',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                        textColor: textColor,
                        labelColor: labelColor,
                        borderColor: borderColor,
                      ),

                      // Valor do Contrato
                      _buildCurrencyTextField(
                        controller: _valorContratoController,
                        label: 'Valor contrato',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          final valor = double.tryParse(
                            value.replaceAll(',', '.'),
                          );
                          if (valor == null || valor <= 0) {
                            return 'Digite um valor válido maior que 0';
                          }
                          return null;
                        },
                        textColor: textColor,
                        labelColor: labelColor,
                        borderColor: borderColor,
                      ),

                      // Valor Pago
                      _buildCurrencyTextField(
                        controller: _valorPagoController,
                        label: 'Valor pago',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          final valorPago = double.tryParse(
                            value.replaceAll(',', '.'),
                          );
                          if (valorPago == null || valorPago < 0) {
                            return 'Digite um valor válido maior ou igual a 0';
                          }

                          // Verificar se valor pago não é maior que valor do contrato
                          final valorContrato = double.tryParse(
                            _valorContratoController.text.replaceAll(',', '.'),
                          );
                          if (valorContrato != null &&
                              valorPago > valorContrato) {
                            return 'Valor pago não pode ser maior que o valor do contrato';
                          }

                          return null;
                        },
                        textColor: textColor,
                        labelColor: labelColor,
                        borderColor: borderColor,
                      ),

                      // Quantidade de Parcelas
                      _buildStyledTextField(
                        controller: _parcelasController,
                        label: 'Qtde parcelas',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          final parcelas = int.tryParse(value);
                          if (parcelas == null || parcelas <= 0) {
                            return 'Digite um número válido maior que 0';
                          }
                          return null;
                        },
                        textColor: textColor,
                        labelColor: labelColor,
                        borderColor: borderColor,
                      ),

                      // Data de Vencimento
                      _buildDatePicker(textColor, labelColor, borderColor),

                      const SizedBox(height: 16),

                      // Status Container
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Status: pendente de pagamento',
                          style: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Botão Cadastrar
                      SizedBox(
                        height: 50,
                        child:
                            _isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: const Color(0xFF121E30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onPressed: _cadastrarContrato,
                                  child: const Text('Cadastrar'),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Color? textColor,
    Color? labelColor,
    Color? borderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: labelColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor ?? Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    Color? textColor,
    Color? labelColor,
    Color? borderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        validator: validator,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          prefixText: 'R\$ ',
          prefixStyle: TextStyle(color: textColor),
          labelText: label,
          labelStyle: TextStyle(color: labelColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor ?? Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    Color? textColor,
    Color? labelColor,
    Color? borderColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: _selecionarDataVencimento,
        child: AbsorbPointer(
          child: TextFormField(
            controller: _dataVencimentoController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: 'Data vencimento',
              labelStyle: TextStyle(color: labelColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor ?? Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                  width: 2,
                ),
              ),
              suffixIcon: Icon(
                Icons.calendar_today,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
