
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogBuilder {

  String title;
  String subtitle;
  String trueButtonName;
  String falseButtonName;

  AlertDialogBuilder(String title) {
    this.title = title;
    this.trueButtonName = "OK";
    this.falseButtonName = "Cancel";
    this.subtitle = null;
  }

  AlertDialogBuilder addTitle(String title) {
    this.title = title;
    return this;
  }

  AlertDialogBuilder addSubtitle(String subtitle) {
    this.subtitle = subtitle;
    return this;
  }

  AlertDialogBuilder addTrueButtonName(String trueButtonName) {
    this.trueButtonName = trueButtonName;
    return this;
  }

  AlertDialogBuilder addFalseButtonName(String falseButtonName) {
    this.falseButtonName = falseButtonName;
    return this;
  }

  AlertDialog build(BuildContext context) {

    // set up the button
    Widget trueButton = FlatButton(
      child: Text(trueButtonName),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
    );

    // set up the button
    Widget falseButton = FlatButton(
      child: Text(falseButtonName),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
    );

    return AlertDialog(
      title: Text(title),
      content: (subtitle != null) ? Text(subtitle) : null,
      actions: [
        trueButton,
        falseButton,
      ],
    );

  }
}