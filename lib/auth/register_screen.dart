import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacancy_scraper/custom/custom_exceptions.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';
import 'package:vacancy_scraper/models/user_model.dart';
import 'package:validators/validators.dart';

import 'bloc/operation_events.dart';
import 'bloc/user_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String categoryValue = 'ყველა კატეგორია';
  List<String> category = [
    'ყველა კატეგორია',
    'ადმინისტრაცია/მენეჯმენტი',
    'ფინანსები/სტატისტიკა',
    'გაყიდვები',
    'PR/მარკეტინგი',
    'ზოგადი ტექნიკური პერსონალი',
    'ლოგისტიკა/ტრანსპორტი/დისტრიბუცია',
    'მშენებლობა/რემონტი',
    'დასუფთავება',
    'დაცვა/უსაფრთხოება',
    'IT/პროგრამირება',
    'მედია/გამომცემლობა',
    'განათლება',
    'სამართალი',
    'მედიცინა/ფარმაცია',
    'სილამაზე/მოდა',
    'კვება',
    'სხვა',
  ];

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoadingVisible = false;

  final scrollController = ScrollController(initialScrollOffset: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          heroTag: 'registerFab',
          onPressed: () {
            if (formKey.currentState == null) {
              return;
            }

            if (formKey.currentState!.validate()) {
              context.read<UserBloc>().add(RegisterUser(User(
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  jobCategory: categoryValue,
                  savedAnnouncements: [])));
            }
          },
          icon: const Icon(Icons.navigate_next),
          label: const Text('რეგისტრაცია')),
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
                      'რეგისტრაცია',
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
                    'რეგისტრაცია',
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                if (operationEvent is ErrorEvent) {
                  final error = operationEvent.error;
                  if (error is RegisterError) {
                    showSnackBar(context, error.message);
                    setProgressBarVisibility(false);
                  }
                } else if (operationEvent is LoadingEvent) {
                  setProgressBarVisibility(true);
                } else if (operationEvent is SuccessfulEvent) {
                  setProgressBarVisibility(false);
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: ListView(
                  controller: scrollController,
                  shrinkWrap: true,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            validator: (value) =>
                                (value ?? '').isEmpty ? "შეავსეთ სახელი" : null,
                            controller: nameController,
                            decoration: const InputDecoration(
                                filled: true, label: Text('სახელი')),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          TextFormField(
                            controller: passwordController,
                            validator: (value) => (value ?? '').length < 4
                                ? (value ?? '').isEmpty
                                    ? "შეავსეთ პაროლი"
                                    : "პაროლი მოკლეა"
                                : null,
                            obscureText: true,
                            decoration: const InputDecoration(
                                filled: true, label: Text('პაროლი')),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          TextFormField(
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
                          DropdownButtonFormField(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'კატეგორია',
                                filled: true,
                              ),
                              value: 'ყველა კატეგორია',
                              items: category.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                  ),
                                );
                              }).toList(),
                              onChanged: ((value) {
                                setState(() {
                                  categoryValue = value!;
                                });
                              })),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void setProgressBarVisibility(bool visibility) {
    setState(() {
      isLoadingVisible = visibility;
    });
  }
}
