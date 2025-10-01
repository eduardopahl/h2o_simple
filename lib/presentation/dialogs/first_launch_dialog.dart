import 'package:flutter/material.dart';

class FirstLaunchDialog extends StatelessWidget {
  final VoidCallback onComplete;

  const FirstLaunchDialog({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(
            Icons.water_drop,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 8),
          const Text('Bem-vindo ao H2O Simple!'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Para ajudá-lo a manter uma hidratação saudável, gostaríamos de enviar lembretes para beber água.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Você poderá personalizar os horários e intervalos nas configurações.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onComplete();
          },
          child: const Text('Agora não'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onComplete();
          },
          child: const Text('Permitir Notificações'),
        ),
      ],
    );
  }
}
