import 'package:flutter/material.dart';
import 'package:hire_pro/shared/widgets/common_navbar.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _tabs = [
    NavbarItem(icon: HugeIconsStroke.home01, label: 'Home'),
    NavbarItem(icon: HugeIconsStroke.clock01, label: 'History'),
    NavbarItem(icon: HugeIconsStroke.file01, label: 'Resume'),
    NavbarItem(icon: HugeIconsStroke.analytics01, label: 'Insights'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _Placeholder(label: 'Home'),
          _Placeholder(label: 'History'),
          _Placeholder(label: 'Resume'),
          _Placeholder(label: 'Insights'),
        ],
      ),
      bottomNavigationBar: CommonNavbar(
        items: _tabs,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    );
  }
}
