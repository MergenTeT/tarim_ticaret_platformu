import 'package:flutter/material.dart';
import 'package:proje_app/core/base/base_view.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Mesajlar',
      child: Center(
        child: Text(
          'Mesajlar Sayfası',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 