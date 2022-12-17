import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacancy_scraper/auth/login_screen.dart';
import 'package:vacancy_scraper/bloc/operation_events.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';
import 'package:vacancy_scraper/models/user_model.dart';
import 'package:validators/validators.dart';

import '../bloc/user_bloc.dart';

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
                  savedAnnouncementIDs: [])));
            }
          },
          icon: const Icon(Icons.navigate_next),
          label: const Text('რეგისტრაცია')),
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
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 16,
              ),
              AutoSizeText(
                'რეგისტრაცია',
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
                      validator: (value) =>
                          !isEmail(value ?? '') ? "შეასწორეთ ელ-ფოსტა" : null,
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
    );
  }
}
