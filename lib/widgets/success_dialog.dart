import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String message; // Dışarıdan gelecek mesaj parametresi

  const SuccessDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Başarılı"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Tamam"),
        ),
      ],
    );
  }
}
