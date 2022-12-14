import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widget/adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  //String? _titleInput, _amountInput;
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final strTitle = _titleController.text;
    final dblAmount = double.parse(_amountController.text);

    if (strTitle.isEmpty || dblAmount <= 0 || _selectedDate == null) {
      return;
    }

    print('Title: ${strTitle}\nAmount: ${dblAmount}');
    widget.addTransaction(strTitle, dblAmount, _selectedDate);

    //Close the top most screen
    Navigator.of(context).pop();
  }

  Future<void> _presentDatePicker() async {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }

      setState(() {
        _selectedDate = value;
        print("DATA: $_selectedDate");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4.0,
        child: Container(
          padding: EdgeInsets.only(
              top: 10.0,
              left: 10.0,
              right: 10.0,
              bottom: MediaQuery.of(context).viewInsets.bottom * 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                autocorrect: false,
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: _titleController,
                onSubmitted: (_) =>
                    _submitData, //(_) indicated accept it but not using it
              ),
              TextField(
                autocorrect: false,
                decoration: InputDecoration(labelText: 'Amount'),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _amountController,
                onSubmitted: (_) =>
                    _submitData, //(_) indicated accept it but not using it
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? 'No Date Chosen !'
                        : "Picked Date:\n${DateFormat.yMMMEd().format(_selectedDate!)}"),
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  AdaptiveFlatButton('Choose Date', () => _presentDatePicker())
                ],
              ),
              SizedBox(
                height: 14.0,
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Add Transcation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
