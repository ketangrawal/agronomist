import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class ProductCardScreen extends StatelessWidget {
  const ProductCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final products = [
      {
        'name': loc.sulphurName,
        'dosage': loc.sulphurDosage,
        'price': loc.sulphurPrice,
      },
      {
        'name': loc.hexaconazoleName,
        'dosage': loc.hexaconazoleDosage,
        'price': loc.hexaconazolePrice,
      },
      {
        'name': loc.neemName,
        'dosage': loc.neemDosage,
        'price': loc.neemPrice,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: Text(loc.productRecommendations)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(product['name']!),
              subtitle: Text("${product['dosage']} • ${product['price']}"),
              trailing: ElevatedButton(
                onPressed: () {
                  // TODO: integrate Firebase save
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.saveSuccess)),
                  );
                },
                child: Text(loc.save),
              ),
            ),
          );
        },
      ),
    );
  }
}
