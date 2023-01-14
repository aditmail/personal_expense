import 'package:flutter/material.dart';
import 'package:personal_expense/widget/transaction_item.dart';

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
              return TransactionItem(transaction: transaction[index], deleteTransaction: deleteTransaction);
            },
            itemCount: transaction.length,
          );
  }
}


