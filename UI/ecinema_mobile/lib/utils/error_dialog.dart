import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showErrorDialog(BuildContext context, String message) {
  final l10n = AppLocalizations.of(context)!;
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.error),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.ok),
        ),
      ],
    ),
  );
}
