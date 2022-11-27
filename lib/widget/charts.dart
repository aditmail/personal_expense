import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/widget/chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTranscationValues {
    return List.generate(7, (index) {
      //Ambil hari lalu
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].dateTime.day == weekDay.day &&
            recentTransactions[i].dateTime.month == weekDay.month &&
            recentTransactions[i].dateTime.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      print(DateFormat.E().format(weekDay));
      print(totalSum);

      print(weekDay);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTranscationValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTranscationValues);

    return Card(
        elevation: 4.0,
        margin: EdgeInsets.all(24.0),
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
              children: groupedTranscationValues.map((data) {
            return Flexible(
              //flex: 2,
              fit: FlexFit.tight,
              child: ChartBar(
                  (data['day'] as String),
                  (data['amount'] as double),
                  //If the calculation -> NaN set default to 0
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList()),
        ),
    );
  }
}
