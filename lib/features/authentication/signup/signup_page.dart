import 'package:expensefrontend/features/Group/groupsPage/groups_page.dart';
import 'package:expensefrontend/features/authentication/login/login_page.dart';
import 'package:expensefrontend/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './core/signup_bloc.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Register'),
            leading: BackButton(
              onPressed: () {
                appRouter.push(const HomePage());
              },
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              // child: ConstrainedBox(
              //   constraints: const BoxConstraints(),
              child: BlocConsumer<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterSuccess) {
                    // print(state.userData);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("User Registered Succesfully")));
                    appRouter.push(LoginPage());
                  } else if (state is RegisterFailure) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  if (state is RegisterLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is RegisterFailure) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildRegisterForm(context),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildRegisterForm(context),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'EmailId'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
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
            decoration: InputDecoration(labelText: 'Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            obscureText: true,
          ),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<RegisterBloc>(context).add(
                  RegisterRequested(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
              }
            },
            child: Text('Signup'),
          ),
          SizedBox(height: 24.0),
          const Text("Have an account?"),
          TextButton(
            onPressed: () {
              appRouter.push(LoginPage());
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
