import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:events/authentication_service.dart';
import 'package:provider/provider.dart';


class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Center(
            child: ElevatedButton(
              child:Text("Logout"),
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
            )
          ),
        ),
      )
    );
    
    }
}
