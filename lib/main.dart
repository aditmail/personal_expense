import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expense/widget/charts.dart';
import 'package:personal_expense/widget/new_transaction.dart';
import 'package:personal_expense/widget/transaction_list.dart';

import 'models/transaction.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    /*DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,*/
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build:: MyApp()');

    return MaterialApp(
      title: 'Expense Planner',
      theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.lightGreenAccent,
          //errorColor: ,
          fontFamily: 'Quicksand',
          //Changes for the Non Appbar
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  fontSize: 18.0)),
          //Changes for the Appbar
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTranscation = [
    /*Transaction(
        id: '1', title: 'New Shoes', amount: 10.15, dateTime: DateTime.now()),
    Transaction(
        id: '2', title: 'New Shirt', amount: 75.21, dateTime: DateTime.now()),*/
  ];

  bool _isShowChart = false;

  List<Transaction> get _recentTransactions {
    return _userTranscation.where((trx) {
      return trx.dateTime.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txtTitle, double txtAmount, DateTime chosenDate) {
    final newTransaction = Transaction(
        title: txtTitle,
        amount: txtAmount,
        dateTime: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTranscation.add(newTransaction);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTranscation(String id) {
    setState(() {
      _userTranscation.removeWhere((trx) => trx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _isShowChart,
              onChanged: (val) {
                setState(() {
                  _isShowChart = val;
                });
              }),
        ],
      ),
      _isShowChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPotraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('build:: MyHomePage()');

    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final dynamic appBar = kIsWeb
        ? AppBar(
            title: Text(
              'Expense Planner',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
            actions: [
              IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: Icon(
                    Icons.add_outlined,
                  ))
            ],
          )
        : Platform.isIOS
            ? CupertinoNavigationBar(
                middle: Text('Expense Planner'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _startAddNewTransaction(context),
                      child: Icon(CupertinoIcons.add),
                    )
                  ],
                ),
              )
            : AppBar(
                title: Text(
                  'Expense Planner',
                  style: TextStyle(fontFamily: 'OpenSans'),
                ),
                actions: [
                  IconButton(
                      onPressed: () => _startAddNewTransaction(context),
                      icon: Icon(
                        Icons.add_outlined,
                      ))
                ],
              );

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTranscation, _deleteTranscation));

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isLandscape)
            ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
          if (!isLandscape)
            ..._buildPotraitContent(mediaQuery, appBar, txListWidget),
        ],
      ),
    ));

    return kIsWeb
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar,
            //floatingActionButton: Platform.isIOS
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterFloat,
            body: pageBody,
          )
        : Platform.isIOS
            ? CupertinoPageScaffold(
                child: pageBody,
                navigationBar: appBar,
              )
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: appBar,
                //floatingActionButton: Platform.isIOS
                floatingActionButton: Platform.isIOS
                    ? Container()
                    : FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () => _startAddNewTransaction(context),
                      ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniCenterFloat,
                body: pageBody,
              );
  }
}

//Notes for Error in Setup Platform Beside WEB
//https://stackoverflow.com/questions/71249485/flutter-web-is-giving-error-about-unsupported-operation-platform-operatingsyst
