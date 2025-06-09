import 'package:flutter/material.dart';
import 'package:proje_app/core/base/base_view.dart';

class MarketView extends StatelessWidget {
  const MarketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Pazar',
      child: Center(
        child: Text(
          'Pazar Sayfası',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 