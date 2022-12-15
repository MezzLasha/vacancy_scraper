import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacancy_scraper/auth/login_screen.dart';
import 'package:vacancy_scraper/bloc/operation_events.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';
import 'package:vacancy_scraper/models/user_model.dart';

import '../bloc/user_bloc.dart';

class RegisterScreen extends StatefulWidget {
  final UserBloc homeBloc;
  const RegisterScreen({super.key, required this.homeBloc});

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
            widget.homeBloc.add(EmitUserToHome(state.user));
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
          child: ListView(
            shrinkWrap: true,
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
                  const SizedBox(
                    height: 30,
                  ),
                  const CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                      'https://lh3.googleusercontent.com/gK__LLaM4jqISqweP0_fxKpBhJuJgSJPqb7wuwRyqMwSBRnj1RJtgXrw69gdLsy2lyH33idBUO5whDJl1TYaHT50hMZc-tj1L49Iq0ctbynuU-0FbFk=w1080',
                    ),
                    child: Icon(
                      Icons.upload_file,
                      color: Color.fromARGB(255, 50, 82, 50),
                      size: 100,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 64,
                        ),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              filled: true, label: Text('სახელი')),
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
                        const SizedBox(
                          height: 32,
                        ),
                        TextField(
                          controller: emailController,
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
                        const SizedBox(
                          height: 32,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 40,
                              child: FilledButton.tonal(
                                child: const Text(
                                  'უკვე გაქვს ანგარიში?',
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen(
                                            homeBloc: widget.homeBloc))),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
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
                        } else {
                          showSnackBar(context, 'ჩაასწორეთ მონაცემები');
                        }
                      },
                      icon: const Icon(Icons.navigate_next),
                      label: const Text('შემდეგი')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
