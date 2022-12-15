import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 64,
                    ),
                    const TextField(
                      decoration:
                          InputDecoration(filled: true, label: Text('სახელი')),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const TextField(
                      obscureText: true,
                      decoration:
                          InputDecoration(filled: true, label: Text('პაროლი')),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
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
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.navigate_next),
                    label: const Text('შემდეგი')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
