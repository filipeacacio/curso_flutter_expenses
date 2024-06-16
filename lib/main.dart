import 'dart:io';
import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'components/transaction_list.dart';
import 'models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]).then((_) {
    runApp(const ExpensesApp());
//   });
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: const MyHomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English
        const Locale('pt', 'BR'), // Portuguese (Brazil)
      ],
      locale: const Locale('pt', 'BR'), // Define o padrão inicial
      theme: ThemeData(
        primarySwatch: Colors.purple,
        // primaryColorDark: Colors.pink,
        // primaryColorLight: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
        ),
        // colorScheme: ColorScheme.fromSwatch().copyWith(
        // primary: Colors.purple.shade800,
        // secondary: Colors.pink,
        // ),
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 16 * MediaQuery.textScalerOf(context).scale(1),
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20 * MediaQuery.textScalerOf(context).scale(1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    // Transaction(
    //     id: 't0',
    //     title: 'Conta Antiga',
    //     value: 400.00,
    //     date: DateTime.now().subtract(const Duration(days: 33))),
    // Transaction(
    //     id: 't1',
    //     title: 'Novo Tênis de Corrida',
    //     value: 310.76,
    //     date: DateTime.now().subtract(const Duration(days: 3))),
    // Transaction(
    //     id: 't2',
    //     title: 'Conta de Luz',
    //     value: 210.30,
    //     date: DateTime.now().subtract(const Duration(days: 4))),
    // Transaction(
    //     id: 't3',
    //     title: 'Cartão de Crédito',
    //     value: 100311.30,
    //     date: DateTime.now()),
    // Transaction(
    //     id: 't4',
    //     title: 'Conta de Luz',
    //     value: 11.30,
    //     date: DateTime.now()),
  ];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _openTransactionFormModal(BuildContext context) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: '',
      value: 0.0,
      date: DateTime.now(),
    );
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction, transaction: newTransaction);
      });
  }

  _addTransaction(String id, String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: id,
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      if ( _transactions.where((tr) => tr.id == id).isEmpty ) {
        _transactions.add(newTransaction);
      } else {
        Transaction t = _transactions.firstWhere((tr) => tr.id == id);
        t.id = id;
        t.title = title;
        t.value = value;
        t.date = date;
      }
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    Transaction t = _transactions.firstWhere((tr) => tr.id == id);
    String formattedValue = StringUtil.NumberFormatBR(t.value);
    String msg = '${t.title}\n${StringUtil.DateTimeFormatBR(t.date)}\nR\$: ${formattedValue}' ;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Excluir Transação?'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _transactions.removeWhere((tr) => tr.id == id);
              });
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  _editTransaction(String id) {
    Transaction t = _transactions.firstWhere((element) => element.id == id);

    // print('ID Transaction: $id');
    // print('id: ${t.id}, title: ${t.title}, value: ${t.value}, date: ${t.date}');

    final newTransaction = Transaction(
      id: t.id,
      title: t.title,
      value: t.value,
      date: t.date,
    );

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction, transaction: newTransaction);
      });
  }

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
    ? GestureDetector(onTap: fn, child: Icon(icon))
    : IconButton(icon: Icon(icon), onPressed: fn, color: Colors.white,);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.list_bullet: Icons.list;
    final iconChart = Platform.isIOS ? CupertinoIcons.chart_bar_square: Icons.show_chart;

    final actions = [
      if ( isLandscape )
      _getIconButton(
        _showChart ? iconList : iconChart,
        () {
          setState(() {
            _showChart = !_showChart;
          });
        },
      ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context)
      ),
    ];


    final appBar = AppBar(
        title: const Text(
          'Despesas Pessoais',
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: actions,
      );

    final availableHeight = mediaQuery.size.height
          - appBar.preferredSize.height
          - mediaQuery.padding.top;

    final boryPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // if (isLandscape)
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //      Text('Exibir Gráfico'),
            //      Switch.adaptive(
            //       activeColor: Theme.of(context).colorScheme.primary, //Theme.of(context).colorScheme.secondary,
            //       value: _showChart,
            //       onChanged: (value) {
            //         setState(() {
            //           _showChart = !_showChart;
            //         });
            //      },
            //      ),
            //   ],
            // ),
            if (_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * (isLandscape ? 0.76 : 0.25),
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * (isLandscape ? 1 : 0.75),
                child: TransactionList(_transactions, _removeTransaction, _editTransaction)
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
    ? CupertinoPageScaffold(
      child: boryPage,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Despesas Pessoais'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: actions,
        ),
      ),
    )
    : Scaffold(
        appBar: appBar,
        body: boryPage,
        floatingActionButton: Platform.isIOS
        ? SizedBox()
        : FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () => _openTransactionFormModal(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
