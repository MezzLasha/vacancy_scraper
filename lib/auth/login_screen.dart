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
import '../custom/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: FloatingActionButton.extended(
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                heroTag: 'registerFab',
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen())),
                label: Text(
                  'რეგისტრაცია',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                )),
          ),
          FloatingActionButton.extended(
              heroTag: 'AuthPages',
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
        ],
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (_, state) {
          final operationEvent = state.operationEvent;
          //TODO
          if (operationEvent is ErrorEvent) {
            showSnackBar(context, operationEvent.exception.toString());
          } else if (operationEvent is LoadingEvent) {
          } else if (operationEvent is SuccessfulEvent) {
            Navigator.pop(context);
            // context.read<UserBloc>().add(EmitUserToHome(state.user));
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
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  context
                                      .read<UserBloc>()
                                      .add(ResetPassword(emailController.text));
                                  Navigator.pop(context);
                                },
                                child: const Text('გაგზავნა'))
                          ],
                          title: const Text('პაროლის აღდგენა'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: emailController,
                                validator: (value) => !isEmail(value ?? '')
                                    ? "შეასწორეთ ელ-ფოსტა"
                                    : null,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    labelText: 'ელ. ფოსტა',
                                    border: OutlineInputBorder()),
                              ),
                              const SizedBox(
                                height: margin1,
                              ),
                              Text(
                                'პაროლი გაიგზავნება ელ-ფოსტაზე',
                                style: Theme.of(context).textTheme.labelLarge,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    child: Text(
                      'პაროლი დაგავიწყდა?',
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
