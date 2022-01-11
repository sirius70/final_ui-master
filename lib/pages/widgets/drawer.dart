import 'package:flutter/material.dart';
import 'package:login_ui/pages/widgets/profile_page.dart';
import 'package:login_ui/pages/widgets/vehicle.dart';
import 'package:login_ui/utils/sharedprefs.dart';

import '../login_page.dart';
import '../slotDetail.dart';
// /import '../prof2.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationDrawerWidgetState();
  }
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.teal.shade400,
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(height: 50),
            buildMenuItem(
                text: 'Profile',
                icon: Icons.people,
                onClicked: () => selectedItem(context, 0)),
            const SizedBox(height: 16),
            buildMenuItem(
                text: 'Slot Booking Details',
                icon: Icons.space_bar,
                onClicked: () => selectedItem(context, 1)),
            const SizedBox(height: 16),
            buildMenuItem(
                text: 'Logout',
                icon: Icons.logout,
                onClicked: () => selectedItem(context, 2)),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    String text,
    IconData icon,
    VoidCallback onClicked,
  }) {
    final color = Colors.black87;
    final hoverColor = Colors.white38;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) async {
    switch (index) {
      case 0:
        var UID = await getUIDValuesSF();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Profile(UID: UID,),
        ));

        break;
      case 1:
        var UID = await getUIDValuesSF();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => slotDetails(id: UID,),
        ));
        break;
      case 2:
        Navigator.pushNamed(context, '/');
        break;
    }
  }
}
