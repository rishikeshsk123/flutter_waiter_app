import 'package:flutter/material.dart';
import 'package:restaurant_app/core/colors/colors.dart';

ValueNotifier<int> indexChangeNotifier = ValueNotifier(0);

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: indexChangeNotifier,
      builder: (context, int newIndex, _) {
        return BottomNavigationBar(
          currentIndex: newIndex,
          onTap: (index) => indexChangeNotifier.value = index,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kBlueAccentColor,
          unselectedItemColor: kGreyColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.shopping_bag_outlined),
            //   label: 'Takeaway',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.delivery_dining_outlined),
            //   label: 'Delivery',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}
