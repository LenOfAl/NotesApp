import 'package:comingsoon/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetEmailSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content: 'We have sent you a password reset email',
    optionsBuilder: () => {'Ok': null},
  );
}
