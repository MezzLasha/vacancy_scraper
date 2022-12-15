import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';

import '../bloc/operation_events.dart';
import '../bloc/user_bloc.dart';

class LoginScreen extends StatefulWidget {
  final UserBloc homeBloc;
  const LoginScreen({super.key, required this.homeBloc});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController passwordController = TextEditingController();
TextEditingController emailController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserBloc, UserState>(
        listener: (_, state) {
          final operationEvent = state.operationEvent;
          //TODO
          if (operationEvent is ErrorEvent) {
            showSnackBar(context, operationEvent.exception.toString());
          } else if (operationEvent is LoadingEvent) {
            if (kDebugMode) {
              print('Loading');
            }
          } else if (operationEvent is SuccessfulEvent) {
            print('success, logging in with ${state.user}');
            Navigator.pop(context);
            widget.homeBloc.add(EmitUserToHome(state.user));
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
          child: Column(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('უკან')),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            filled: true, label: Text('ელ-ფოსტა')),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            filled: true, label: Text('პაროლი')),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<UserBloc>().add(LoginUser(
                            emailController.text, passwordController.text));
                      },
                      icon: const Icon(Icons.navigate_next),
                      label: const Text('შესვლა')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
