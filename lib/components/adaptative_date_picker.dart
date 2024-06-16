import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expenses/utils/string_util.dart';

class AdaptativeDatePicker extends StatelessWidget {

  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final DateTime initialDate;

  const AdaptativeDatePicker({
    required this.selectedDate,
    required this.onDateChanged,
    required this.initialDate,
    super.key,
  });

  _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(
        const Duration(days: 6),
      ),
      lastDate: DateTime.now(),
    ).then((pickerdDdate) {
      if (pickerdDdate == null) {
        return;
      }
      onDateChanged(pickerdDdate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? SizedBox(
          height: 180,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: initialDate,
            minimumDate: DateTime.now().subtract(
              const Duration(days: 6),
            ),
            maximumDate: DateTime.now(),
            onDateTimeChanged: onDateChanged
          ),
        )
        : SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Data Selecionada:  ${StringUtil.DateTimeFormatBR(selectedDate)}',
                  ),
                ),
                TextButton(
                  onPressed: () => _showDatePicker(context),
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
          );
  }
}
