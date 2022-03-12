import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intechpro/providers/profile_provider.dart';
import 'package:intechpro/screens/home_screen.dart';
import 'package:intechpro/screens/update_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config.dart';

class AppDrawer extends StatelessWidget {
  String displayName;
  AppDrawer({Key? key, required this.displayName});

  Widget _createHeader(context) {
    return DrawerHeader(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                0.2,
                0.1,
                0.6,
                0.9,
              ],
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
                Colors.blue
              ],
            )),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                "assets/images/user.png",
                width: 90,
                height: 90,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                displayName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2),
              ),
            ],
          ),
        ));
  }

  Widget _createDrawerItem(
      {IconData? icon, String? text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text!),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Column(
            children: [
              _createHeader(context),
              _createDrawerItem(
                icon: Icons.home,
                text: "Home",
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()),
                    (Route<dynamic> route) => false),
              ),
              Divider(),
              _createDrawerItem(
                icon: Icons.request_quote,
                text: "My Requests",
                onTap: () => Navigator.pushNamed(context, "/customer_requests"),
              ),
              Divider(),
              _createDrawerItem(
                  icon: Icons.money_outlined,
                  text: "Wallet",
                  onTap: () => Navigator.pushNamed(context, "/wallet")),
              Divider(),
              _createDrawerItem(
                  icon: Icons.person,
                  text: "Profile",
                  onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => UpdateProfileScreen()),
                      )),
              Divider(),
              _createDrawerItem(
                  icon: Icons.call,
                  text: "Any Issues? Contact us",
                  onTap: () {
                    launch("tel://${contact_support}");
                  }),
              Divider(),
              _createDrawerItem(
                  icon: Icons.logout,
                  text: "Log out",
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Provider.of<ProfileProvider>(context, listen: false)
                        .signout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/login", (Route<dynamic> route) => false);
                  }),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                title: Text(
                  'v0.0.1',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
