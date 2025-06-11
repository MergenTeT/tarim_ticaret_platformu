import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseView extends StatefulWidget {
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget child;
  final bool showBottomNav;
  final Widget? bottomNavigationBar;
  final bool showBackButton;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  const BaseView({
    super.key,
    required this.title,
    this.titleWidget,
    this.actions,
    required this.child,
    this.showBottomNav = true,
    this.bottomNavigationBar,
    this.showBackButton = false,
    this.backgroundColor,
    this.bottom,
  });

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: widget.titleWidget ?? Text(widget.title),
        actions: widget.actions,
        automaticallyImplyLeading: widget.showBackButton,
        bottom: widget.bottom,
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
                  icon: Icon(Icons.store_outlined),
                  selectedIcon: Icon(Icons.store),
                  label: 'Pazar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.trending_up_outlined),
                  selectedIcon: Icon(Icons.trending_up),
                  label: 'Borsa',
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_box_outlined),
                  selectedIcon: Icon(Icons.add_box),
                  label: 'İlan Ekle',
                ),
                NavigationDestination(
                  icon: Icon(Icons.message_outlined),
                  selectedIcon: Icon(Icons.message),
                  label: 'Mesajlar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Ayarlar',
                ),
              ],
            )
          : null),
    );
  }
} 