import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  int state = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state,
        onTap: (value) {
          setState(() {
            state = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: state == 0
                ? Image.asset(
                    'assets/images/home_filled.png',
                    color: state == 0
                        ? Pallete.whiteColor
                        : Pallete.inactiveBottomBarItemColor,
                  )
                : Image.asset(
                    'assets/images/home_unfilled.png',
                  ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/library.png',
              color: state == 1
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
