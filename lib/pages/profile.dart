import 'package:expensefrontend/features/Group/groupsPage/groups_page.dart';
import 'package:flutter/material.dart';

import '../features/account/account_page.dart';
import '../features/activity/activity_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;

  final List<Widget> pages = [GroupsPage(), ActivityPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Material(
        elevation: 20,
        shadowColor: Colors.black,
        child: BottomNavigationBar(
          backgroundColor: Colors.grey.shade100,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Groups',
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.assessment_outlined),
                label: 'Activity',
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Account',
                backgroundColor: Colors.grey),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.green,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
