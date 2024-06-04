import 'package:expenses/models/transaction.dart';
import 'package:expenses/utils/string_util.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm(this.onSubmit, {required Transaction this.transaction, super.key});

  final Transaction transaction;
  final void Function(String, String, double, DateTime) onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState(transaction);
}

class _TransactionFormState extends State<TransactionForm> {
  _TransactionFormState(Transaction transaction) {
    id = transaction.id;
    _titleController.text = transaction.title;
    _valueController.text = StringUtil.NumberFormatBR(transaction.value);
    _selectedDate = transaction.date;
  }

  String id = '';
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();

  _submirForm() {
    final id = this.id;
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text.replaceAll('.', '').replaceAll(',', '.')) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(id, title, value, _selectedDate!);
  }

  @override
  void initState() {
    super.initState();
    _valueController.addListener(_formatInput);
  }

  @override
  void dispose() {
    _valueController.removeListener(_formatInput);
    _valueController.dispose();
    super.dispose();
  }

  void _formatInput() {
    String value = _valueController.text;

    // Remove qualquer caractere que não seja número
    value = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (value.isEmpty) {
      _valueController.value = const TextEditingValue(
        text: '0,00',
        selection: TextSelection.collapsed(offset: 4),
      );
      return;
    }

    double numValue = double.parse(value) / 100;
    String formattedValue = StringUtil.NumberFormatBR(numValue);

    // Atualiza o TextEditingController com o valor formatado
    _valueController.value = TextEditingValue(
      text: StringUtil.NumberFormatBR(numValue),
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 7),
      ),
      lastDate: DateTime.now(),
    ).then((pickerdDdate) {
      if (pickerdDdate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickerdDdate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                onSubmitted: (_) => _submirForm(),
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                  controller: _valueController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _submirForm(),
                  decoration: const InputDecoration(labelText: 'Valor (R\$)')),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Nenhum data selecionada!'
                            : 'Data Selecionada:  ${StringUtil.DateTimeFormatBR(_selectedDate!)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _showDatePicker,
                      child: Text(
                        'Selecionar Data',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      // side: BorderSide(
                      //     color: Colors.black,
                      //     width: 2), // Cor e largura da borda
                    ),
                    onPressed: _submirForm,
                    child: const Text(
                      'Salvar',
                      style: TextStyle(
                        // color: Theme.of(context).textTheme.bodyMedium?.color,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
