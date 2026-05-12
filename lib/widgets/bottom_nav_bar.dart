import 'package:flutter/material.dart';
import 'package:zubimovie/screens/home_screen.dart';
import 'package:zubimovie/screens/hots_and_new.dart';
import 'package:zubimovie/screens/search_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 70,
          child: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.home), text: "Home"),
              Tab(icon: Icon(Icons.search), text: "Search"),
              Tab(icon: Icon(Icons.photo_library_outlined), text: "New&Hots"),
            ],
            indicatorColor: Colors.transparent,
            labelColor: Colors.brown[900],
            unselectedLabelColor: Colors.white60,
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),
            // Note: if SearchScreen or HotsAndNewScreen do NOT have const constructors,
            // remove const from TabBarView and the specific items below.
            SearchScreen(),
            HotsAndNewScreen(),
          ],
        ),
      ),
    );
  }
}
