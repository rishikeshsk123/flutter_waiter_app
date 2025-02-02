import 'package:flutter/material.dart';
import 'package:restaurant_app/presentation/home/screen_home.dart';
import 'package:restaurant_app/presentation/main_page/widgets/bottom_nav.dart';
import 'package:restaurant_app/presentation/profile/screen_profile.dart';

class ScreenMainPage extends StatelessWidget {
  ScreenMainPage({super.key});

  final _pages = const [
    ScreenHome(),
    ScreenProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: indexChangeNotifier,
          builder: (context, int index, _) {
            return _pages[index];
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(),
    );
  }
}
