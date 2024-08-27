import 'package:expensefrontend/features/authentication/login/login_page.dart';
import 'package:expensefrontend/features/authentication/signup/signup_page.dart';
import 'package:expensefrontend/features/botttom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // const HomePage({super.key});

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final isLogin = prefs.getBool('isUserLoggedIn') ?? false;
      print(isLogin);
      if (isLogin) {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => BottomNavigation(),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpenseTrak'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon.jpg',
                height: 180,
              ),
              const SizedBox(height: 40),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Colors.lightGreen),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.lightGreen),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()));
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Colors.lightGreen),
                ),
                child: const Text(
                  'Signup',
                  style: TextStyle(fontSize: 18, color: Colors.lightGreen),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.teal.shade300, Colors.teal.shade700],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Hero(
//                       tag: 'app_logo',
//                       child: CircleAvatar(
//                         radius: 80,
//                         backgroundColor: Colors.white,
//                         child: Image.asset(
//                           'assets/images/icon.jpg',
//                           height: 120,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 24),
//                     Text(
//                       'Expense Management',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Track your expenses with ease',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white.withOpacity(0.8),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         appRouter.push(LoginPage());
//                       },
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         backgroundColor: Colors.teal,
//                         minimumSize: Size(double.infinity, 56),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         'Login',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     OutlinedButton(
//                       onPressed: () {
//                         appRouter.push(RegisterPage());
//                       },
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         minimumSize: Size(double.infinity, 56),
//                         side: BorderSide(color: Colors.white, width: 2),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       child: Text(
//                         'Sign Up',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
