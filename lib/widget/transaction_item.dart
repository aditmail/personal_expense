import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late Color _bgColors;

  @override
  void initState() {
    super.initState();
    const availColors = [
      Colors.red,
      Colors.yellowAccent,
      Colors.green,
      Colors.blue
    ];

    _bgColors = availColors[Random().nextInt(availColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
              color: _bgColors,
              //color: Theme.of(context).primaryColorLight,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4.0)),
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: FittedBox(child: Text("\$${widget.transaction.amount}")),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(DateFormat.yMMMEd().format(widget.transaction.dateTime)),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                onPressed: () =>
                    widget.deleteTransaction(widget.transaction.id),
                icon: Icon(Icons.delete),
                textColor: Theme.of(context).errorColor,
                label: const Text('Delete'))
            : IconButton(
                icon: Icon(Icons.delete_outline_outlined),
                onPressed: () =>
                    widget.deleteTransaction(widget.transaction.id),
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}
