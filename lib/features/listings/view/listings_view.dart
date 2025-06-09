import 'package:flutter/material.dart';
import 'package:proje_app/core/base/base_view.dart';

class ListingsView extends StatelessWidget {
  const ListingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'İlanlarım',
      child: Center(
        child: Text(
          'İlanlarım Sayfası',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 