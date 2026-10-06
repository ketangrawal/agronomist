import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class ProductCardScreen extends StatelessWidget {
  const ProductCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.savedProductCards)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              loc.noCards, // ✅ matches your ARB
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.saveSuccess)), // ✅ matches ARB
                );
              },
              child: Text(loc.save),
            ),
          ],
        ),
      ),
    );
  }
}
