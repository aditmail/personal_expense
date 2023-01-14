import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4.0)),
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: FittedBox(
                child: Text("\$${transaction.amount}")),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
            DateFormat.yMMMEd().format(transaction.dateTime)),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
            onPressed: () =>
                deleteTransaction(transaction.id),
            icon: Icon(Icons.delete),
            textColor: Theme.of(context).errorColor,
            label: const Text('Delete'))
            : IconButton(
          icon: Icon(Icons.delete_outline_outlined),
          onPressed: () =>
              deleteTransaction(transaction.id),
          color: Theme.of(context).errorColor,
        ),
      ),
    );
  }
}
