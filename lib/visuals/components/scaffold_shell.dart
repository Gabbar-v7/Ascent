import 'package:ascent/visuals/components/utils/navigator_utils.dart';
import 'package:flutter/material.dart';

@immutable
class NavigationItem {
  final IconData icon;
  final String navBarTitle;
  final String appBarTitle;
  final Widget body;
  final List<Widget>? actions;

  const NavigationItem({
    required this.icon,
    required this.navBarTitle,
    required this.appBarTitle,
    required this.body,
    this.actions,
  });
}

/// Global Scaffold navigation bar and tab bar used throughout the app for consistent ui/ux
class ScaffoldShell extends StatefulWidget {
  final List<NavigationItem> pages;
  final NavigationDestination? auxiliaryDestination;
  final void Function(BuildContext)? onAuxiliaryTap;

  const ScaffoldShell({
    super.key,
    required this.pages,
    this.auxiliaryDestination,
    this.onAuxiliaryTap,
  }) : assert(
         (auxiliaryDestination == null && onAuxiliaryTap == null) ||
             (auxiliaryDestination != null && onAuxiliaryTap != null),
         'extraOption and onClickExtraOption must either both be null or both non-null',
       );

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
    _pageList = widget.pages
        .map(
          (item) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: item.body,
          ),
        )
        .toList();
    _navigationDestinations = [
      ...widget.pages.map(
        (item) => NavigationDestination(
          icon: Icon(item.icon),
          label: item.navBarTitle,
        ),
      ),
      if (widget.auxiliaryDestination != null) widget.auxiliaryDestination!,
    ];
  }

  void _onDestinationSelected(int index) {
    if (widget.auxiliaryDestination == null ||
        index < _navigationDestinations.length - 1) {
      setState(() {
        _pageIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    } else {
      widget.onAuxiliaryTap!(context);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pages[_pageIndex].appBarTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          onPressed: () => NavigatorUtils.popPage(context),
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: widget.pages[_pageIndex].actions,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pageList,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pageIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _navigationDestinations,
      ),
    );
  }
}
