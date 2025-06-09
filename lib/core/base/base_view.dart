import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseView extends StatefulWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final bool showBottomNav;
  final Widget? bottomNavigationBar;

  const BaseView({
    Key? key,
    required this.child,
    required this.title,
    this.actions,
    this.showBottomNav = true,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.actions,
      ),
      body: widget.child,
      bottomNavigationBar: widget.bottomNavigationBar ?? (widget.showBottomNav
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
                switch (index) {
                  case 0:
                    context.go('/market');
                    break;
                  case 1:
                    context.go('/stock-market');
                    break;
                  case 2:
                    context.go('/add-listing');
                    break;
                  case 3:
                    context.go('/messages');
                    break;
                  case 4:
                    context.go('/settings');
                    break;
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.store),
                  label: 'Pazar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.trending_up),
                  label: 'Borsa',
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_box),
                  label: 'İlan Ekle',
                ),
                NavigationDestination(
                  icon: Icon(Icons.message),
                  label: 'Mesajlar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Ayarlar',
                ),
              ],
            )
          : null),
    );
  }
} 