import 'package:expenses/utils/string_util.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(this.transactions, this.onRemove, this.onEdit, {super.key});

  final List<Transaction> transactions;
  final void Function(String) onRemove;
  final void Function(String) onEdit;

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                SizedBox(height: 20),
                SizedBox(
                  height: constraints.maxHeight * 0.15,
                  child: Text(
                    'Nenhuma Transação Cadastrada',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: constraints.maxHeight * 0.60,
                  child: Image.asset(
                    'assets/imagens/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('R\$${StringUtil.NumberFormatBR(tr.value)}'),
                      ),
                    ),
                  ),
                  title: Text(
                    tr.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    StringUtil.DateTimeFormatBR(tr.date),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MediaQuery.of(context).size.width > 480
                      ? TextButton(
                          child: Row(
                            children: [
                              Icon(Icons.border_color),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  top: 14
                                ),
                                child: Text(
                                  'Editar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // color: Theme.of(context).primaryColorDark,
                          onPressed: () => onEdit(tr.id),
                      )
                      : IconButton(
                          icon: Icon(Icons.border_color),
                          color: Theme.of(context).primaryColorDark,
                          onPressed: () => onEdit(tr.id),
                      ),
                      MediaQuery.of(context).size.width > 480
                      ? TextButton(
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red,),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  top: 14
                                ),
                                child: Text(
                                  'Excluir',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // color: Theme.of(context).primaryColorDark,
                          onPressed: () => onRemove(tr.id),
                      )
                      : IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () => onRemove(tr.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
