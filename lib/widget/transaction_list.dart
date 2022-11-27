import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTransaction;

  TransactionList(this.transaction, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    //If the List wanted to isolated height
    //return Container(
    //height:300, child:SingleChildScrollView(
    return transaction.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'No transcation added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
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
                          child: Text("\$${transaction[index].amount}")),
                    ),
                  ),
                  title: Text(
                    transaction[index].title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                      DateFormat.yMMMEd().format(transaction[index].dateTime)),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? FlatButton.icon(
                          onPressed: () =>
                              deleteTransaction(transaction[index].id),
                          icon: Icon(Icons.delete),
                          textColor: Theme.of(context).errorColor,
                          label: Text('Delete'))
                      : IconButton(
                          icon: Icon(Icons.delete_outline_outlined),
                          onPressed: () =>
                              deleteTransaction(transaction[index].id),
                          color: Theme.of(context).errorColor,
                        ),
                ),
              );
            },
            itemCount: transaction.length,
          );
  }
}
