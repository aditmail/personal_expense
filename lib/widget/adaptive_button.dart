import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function handler;

  const AdaptiveFlatButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return TextButton(
        onPressed: () => handler(),
        child: Text(
          text,
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Platform.isIOS
          ? CupertinoButton(
              onPressed: () => handler(),
              child: Text(
                text,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold),
              ))
          : TextButton(
              onPressed: () => handler(),
              child: Text(
                text,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold),
              ),
            );
    }
  }
}
