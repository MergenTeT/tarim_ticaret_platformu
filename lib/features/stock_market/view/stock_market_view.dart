import 'package:flutter/material.dart';

class StockMarketView extends StatelessWidget {
  const StockMarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarım Borsası'),
      ),
      body: const Center(
        child: Text('Tarım Borsası sayfası yakında hizmetinizde olacak'),
      ),
    );
  }
} 