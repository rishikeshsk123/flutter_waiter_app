import 'package:flutter/material.dart';
import 'package:restaurant_app/presentation/delivery/screen_delivery.dart';
import 'package:restaurant_app/presentation/dine_in/screen_dine_in.dart';
import 'package:restaurant_app/presentation/main_page/widgets/bottom_nav.dart';
import 'package:restaurant_app/presentation/rooms/screen_rooms.dart';
import 'package:restaurant_app/presentation/takeaway/screen_takeaway.dart';

class ScreenMainPage extends StatelessWidget {
  ScreenMainPage({super.key});

  final _pages = [
    ScreenDineIn(),
    ScreenTakeaway(),
    ScreenDelivery(),
    ScreenRooms(),
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
