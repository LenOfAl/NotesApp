import 'package:comingsoon/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this item?',
    optionsBuilder: () => {
      'No': false,
      'Yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
