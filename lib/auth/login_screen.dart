import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacancy_scraper/auth/register_screen.dart';
import 'package:vacancy_scraper/custom/custom_exceptions.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';
import 'package:validators/validators.dart';

import '../custom/constants.dart';
import 'bloc/operation_events.dart';
import 'bloc/user_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final scrollController = ScrollController(initialScrollOffset: 0);

  bool isLoadingVisible = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    context.read<UserBloc>().add(LoginUser(
                        emailController.text, passwordController.text));
                  }
                },
                icon: const Icon(Icons.navigate_next),
                label: const Text('შესვლა')),
          ],
        ),
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar.large(
              title: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  var top = constraints.biggest.height;
                  if (top > 60) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 4),
                      child: AutoSizeText(
                        'ვაკანსიები',
                        maxLines: 1,
                        softWrap: false,
                        maxFontSize: 19,
                        minFontSize: 10,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    );
                  } else {
                    return AutoSizeText(
                      'ვაკანსიები',
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w500,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    );
                  }
                },
              ),
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Visibility(
                    visible: isLoadingVisible,
                    child: const LinearProgressIndicator(),
                  )),
            ),
            SliverToBoxAdapter(
              child: BlocListener<UserBloc, UserState>(
                listener: (_, state) {
                  final operationEvent = state.operationEvent;
                  if (operationEvent is SuccessfulEvent) {
                    setProgressBarVisibility(false);
                    Navigator.pop(context);
                  } else if (operationEvent is ErrorEvent) {
                    final error = operationEvent.error;
                    if (error is LoginError) {
                      showSnackBar(context, error.message);
                      setProgressBarVisibility(false);
                    }
                  } else if (operationEvent is LoadingEvent) {
                    setProgressBarVisibility(true);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 128),
                  child: ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              autofillHints: const [AutofillHints.email],
                              controller: emailController,
                              validator: (value) => !isEmail(value ?? '')
                                  ? "შეასწორეთ ელ-ფოსტა"
                                  : null,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  filled: true, label: Text('ელ-ფოსტა')),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            TextFormField(
                              autofillHints: const [AutofillHints.password],
                              controller: passwordController,
                              obscureText: true,
                              validator: (value) => (value ?? '').length <= 3
                                  ? "შეასწორეთ პაროლი"
                                  : null,
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
                                          context.read<UserBloc>().add(
                                              ResetPassword(
                                                  emailController.text));
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
                                        validator: (value) =>
                                            !isEmail(value ?? '')
                                                ? "შეასწორეთ ელ-ფოსტა"
                                                : null,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: const InputDecoration(
                                            labelText: 'ელ. ფოსტა',
                                            border: OutlineInputBorder()),
                                      ),
                                      const SizedBox(
                                        height: margin1,
                                      ),
                                      Text(
                                        'პაროლი გაიგზავნება ელ-ფოსტაზე',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
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
            )
          ],
        ));
  }

  void setProgressBarVisibility(bool visibility) {
    setState(() {
      isLoadingVisible = visibility;
    });
  }
}
