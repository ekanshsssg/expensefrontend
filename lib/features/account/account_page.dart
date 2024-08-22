import 'package:expensefrontend/features/authentication/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/logout/core/logout_bloc.dart';

class AccountPage extends StatefulWidget {
  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  String name = "Loading..";
  String emailId = "Loading..";
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "-";
      emailId = prefs.getString('emailId') ?? "-";
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LogoutBloc(),
        child: Builder(
          builder: (context) => BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Logout Successful')));
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } else if (state is LogoutFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Logout Failed')));
              }
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Account", style: TextStyle(fontSize: 24)),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          CircleAvatar(
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 40,
                              color: Colors.black54,
                            ),
                            backgroundColor: Colors.lightGreen,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name),
                              SizedBox(
                                height: 4,
                              ),
                              Text(emailId)
                            ],
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Divider(thickness: 1, color: Colors.grey),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(children: [
                          // CircleAvatar(
                          //   child:
                          // ),
                          Icon(
                            Icons.logout,
                            size: 40,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                // BlocProvider.of(context)
                                context
                                    .read<LogoutBloc>()
                                    .add(LogoutRequested());
                              },
                              style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Made by Ekansh"),
                          Text("Copyright © 2024")
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
