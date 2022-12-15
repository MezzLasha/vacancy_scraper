import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/repositories/dbProvider.dart';

import '../models/user_model.dart';

class FireRepository implements DBInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  List<Announcement> getAnnouncements() {
    // TODO: implement getAnnouncements
    throw UnimplementedError();
  }

  @override
  Future<User> loginUser(String email, String password) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final doc = await users.doc(email).get();
    final data = doc.data() as Map<String, dynamic>;
    final user = User(
        name: data['name'],
        email: email,
        password: password,
        jobCategory: data['category'],
        savedAnnouncements: []);
    return user;
  }

  @override
  void saveAnnouncement(Announcement announcement) {
    // TODO: implement saveAnnouncement
    throw UnimplementedError();
  }

  @override
  Future<void> registerUser(User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.doc(user.email).set({
      'name': user.name,
      'category': user.jobCategory,
      'password': user.password,
      'savedAnnouncements': user.savedAnnouncements
    }).then((value) => print("User Added"));
  }
}
