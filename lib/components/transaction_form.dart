import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adaptative_text_field.dart';
import 'package:expenses/components/adaptative_date_picker.dart';
import 'package:expenses/models/transaction.dart';
import 'package:expenses/utils/string_util.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm(this.onSubmit,
      {required Transaction this.transaction, super.key});

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
  DateTime _selectedDate = DateTime.now();

  _submirForm() {
    final id = this.id;
    final title = _titleController.text;
    final value = double.tryParse(
            _valueController.text.replaceAll('.', '').replaceAll(',', '.')) ??
        0.0;

    if (title.isEmpty || value <= 0) {
      return;
    }

    widget.onSubmit(id, title, value, _selectedDate);
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
      child: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 10,
        ),
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                right: 10,
                left: 10,
                bottom: 10 + MediaQuery.of(context).viewInsets.bottom
              ),
              child: Column(
                children: [
                  AdaptativeTextField(
                    controller: _titleController,
                    onSubmitted: (_) => _submirForm(),
                    label: 'Título',
                  ),
                  AdaptativeTextField(
                      controller: _valueController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onSubmitted: (_) => _submirForm(),
                      label: 'Valor (R\$)'
                  ),
                  AdaptativeDatePicker(
                    selectedDate: _selectedDate,
                    onDateChanged: (newDate) {
                      setState(() {
                        _selectedDate = newDate;
                      });
                    },
                    initialDate: _selectedDate,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AdaptativeButton(
                        label: 'Salvar',
                        onPressed: _submirForm,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
