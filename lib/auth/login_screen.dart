import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacancy_scraper/auth/register_screen.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';
import 'package:validators/validators.dart';

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
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 12),
          child: SizedBox(
            height: 40,
            child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('უკან')),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            var formState = formKey.currentState;
            if (formState == null) {
              return;
            }

            if (formState.validate()) {
              context.read<UserBloc>().add(
                  LoginUser(emailController.text, passwordController.text));
            }
          },
          icon: const Icon(Icons.navigate_next),
          label: const Text('შესვლა')),
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ListView(
            shrinkWrap: true,
            children: [
              AutoSizeText(
                'ვაკანსიები',
                maxFontSize: 50,
                minFontSize: 20,
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(
                height: 48,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      validator: (value) =>
                          !isEmail(value ?? '') ? "შეასწორეთ ელ-ფოსტა" : null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          filled: true, label: Text('ელ-ფოსტა')),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) =>
                          (value ?? '').length <= 3 ? "შეასწორეთ პაროლი" : null,
                      decoration: const InputDecoration(
                          filled: true, label: Text('პაროლი')),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RegisterScreen(homeBloc: widget.homeBloc))),
                    child: Text(
                      'არ გაქვთ ანგარიში?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
