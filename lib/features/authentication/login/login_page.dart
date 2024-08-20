import 'package:expensefrontend/features/Group/groupsPage/groups_page.dart';
import 'package:expensefrontend/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:expensefrontend/features/authentication/signup/signup_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../pages/home.dart';
import './core/login_bloc.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   LoginPageState createState() => LoginPageState();
// }

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // String? _emailError;
  // String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Login'),
            leading: BackButton(
              onPressed: () {
                appRouter.pushReplacement(const HomePage());
              },
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    // print(state.userData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login Success'),
                        duration: Duration(
                            seconds:
                                1), // Duration for how long the snackbar will be displayed
                      ),
                    );
                    Future.delayed(const Duration(seconds: 1), () {
                      // appRouter.push(GroupsPage());
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                        (Route<dynamic> route) => false,
                      );

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ProfilePage()));
                    });
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is LoginFailure) {
                    print(state.error);
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildLoginForm(context),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildLoginForm(context),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            // onChanged: (value) {
            //   setState(() {
            //     _emailError = null;
            //   });
            // },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              // Regex for email validation
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            // onChanged: (value) {
            //   setState(() {
            //     _passwordError = null;
            //   });
            // },
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<LoginBloc>(context).add(
                  LoginRequested(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
              }
            },
            child: const Text('Login'),
          ),
          SizedBox(height: 24.0),
          const Text("Don't have an account"),
          TextButton(
            onPressed: () {
              appRouter.push(RegisterPage());
            },
            child: const Text('Signup'),
          ),
        ],
      ),
    );
  }
}
