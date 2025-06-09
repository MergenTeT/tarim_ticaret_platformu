import 'package:flutter/material.dart';
import '../../../core/base/base_view.dart';

class StockMarketView extends StatelessWidget {
  const StockMarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseView(
      title: 'Tarım Borsası',
      child: Center(
        child: Text('Tarım Borsası sayfası yakında hizmetinizde olacak'),
      ),
    );
  }
} 