import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hire_pro/core/network/locator.dart';
import 'package:hire_pro/core/utils/enums.dart';
import 'package:hire_pro/features/applicant_module/feed/ui/feed_screen.dart';
import 'package:hire_pro/features/employer_module/feed/ui/feed_screen.dart';
import 'package:hire_pro/shared/widgets/common_navbar.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  late final Future<String?> _userTypeFuture;

  @override
  void initState() {
    super.initState();
    _userTypeFuture = ref.read(localStorageServiceProvider).userType;
  }

  static const _tabs = [
    NavbarItem(icon: HugeIconsStroke.home01, label: 'Home'),
    NavbarItem(icon: HugeIconsStroke.clock01, label: 'History'),
    NavbarItem(icon: HugeIconsStroke.file01, label: 'Resume'),
    NavbarItem(icon: HugeIconsStroke.analytics01, label: 'Insights'),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _userTypeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final userType = UserTypeX.fromString(snapshot.data ?? '');

        print("userType : ${userType.name}");

        final feedScreen = userType == UserType.recruiter
            ? const EmployerFeedScreen()
            : const ApplicantFeedScreen();

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              feedScreen,
              const _Placeholder(label: 'History'),
              const _Placeholder(label: 'Resume'),
              const _Placeholder(label: 'Insights'),
            ],
          ),
          bottomNavigationBar: CommonNavbar(
            items: _tabs,
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
          ),
        );
      },
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
