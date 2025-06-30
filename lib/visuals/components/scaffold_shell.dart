import 'package:ascent/utils/navigator_utils.dart';
import 'package:flutter/material.dart';

@immutable
class NavigationItem {
  final IconData icon;
  final String navBarTitle;
  final String appBarTitle;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? actions;

  const NavigationItem({
    required this.icon,
    required this.navBarTitle,
    required this.appBarTitle,
    required this.body,
    this.floatingActionButton,
    this.actions,
  });
}

/// Global Scaffold navigation bar and tab bar used throughout the app for consistent ui/ux
class ScaffoldShell extends StatefulWidget {
  const ScaffoldShell({
    super.key,
    required this.pages,
  });

  final List<NavigationItem> pages;

  @override
  State<ScaffoldShell> createState() => _ScaffoldShellState();
}

class _ScaffoldShellState extends State<ScaffoldShell> {
  int _pageIndex = 0;
  late PageController _pageController;
  late List<Widget> _pageList;
  late List<NavigationDestination> _navigationDestinations;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    _pageList = widget.pages.map((item) => item.body).toList();
    _navigationDestinations = widget.pages.map((item) {
      return NavigationDestination(
        icon: Icon(item.icon),
        label: item.navBarTitle,
      );
    }).toList();
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _pageIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.pages[_pageIndex].floatingActionButton,
      appBar: AppBar(
        title: Text(widget.pages[_pageIndex].appBarTitle),
        leading: IconButton(
            onPressed: () => NavigatorUtils.popPage(context),
            icon: Icon(Icons.arrow_back_ios_rounded)),
        actions: widget.pages[_pageIndex].actions,
      ),
      body: PageView(
        controller: _pageController,
        children: _pageList,
      ),
      bottomNavigationBar: NavigationBar(
          selectedIndex: _pageIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: _navigationDestinations),
    );
  }
}
