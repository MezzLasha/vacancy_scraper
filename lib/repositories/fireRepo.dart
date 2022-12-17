// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mailjet/mailjet.dart';

import 'package:vacancy_scraper/custom/apiKey.dart';
import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/repositories/dbProvider.dart';

import '../models/user_model.dart';

class FireRepository implements DBInterface {
  final FirebaseFirestore firestore;

  FireRepository(
    this.firestore,
  );

  @override
  List<Announcement> getAnnouncements() {
    // handled by scraping for now in databaseRepo.dart
    throw UnimplementedError();
  }

  @override
  Future<User> loginUser(String email, String password) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final doc = await users.doc(email).get();
    final data = doc.data() as Map<String, dynamic>;

    if (data['password'] != password) {
      throw Exception('არასწორი პაროლი');
    }

    final user = User(
        name: data['name'],
        email: email,
        password: password,
        jobCategory: data['category'],
        savedAnnouncementIDs: []);
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
    Map<String, dynamic> data;

    try {
      final doc = await users.doc(user.email).get();
      data = doc.data() as Map<String, dynamic>;
    } catch (e) {
      await users.doc(user.email).set({
        'name': user.name,
        'category': user.jobCategory,
        'password': user.password,
        'savedAnnouncements': user.savedAnnouncementIDs
      });
      return;
    }

    throw Exception('ეს ელ-ფოსტა უკვე რეგისტრირებულია');
  }

  @override
  Future<void> resetPassword(String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Map<String, dynamic> data;
    try {
      final doc = await users.doc(email).get();
      data = doc.data() as Map<String, dynamic>;
    } catch (e) {
      //არ არსებობს
      throw Exception('ელ-ფოსტა ვერ მოიძებნა');
    }

    MailJet mailJet = MailJet(
      apiKey: mailJetApiKey,
      secretKey: mailJetSecretKey,
    );

    await mailJet.sendEmail(
      subject: "ვაკანსიები - პაროლის აღდგენა",
      sender: Sender(
        email: senderEmail, //in apiKey.dart
        name: "ვაკანსიები",
      ),
      reciepients: [
        Recipient(
          email: email,
          name: data['name'],
        ),
      ],
      htmlEmail: """
<h3>პაროლი:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ${data['password']}</h3>
""",
    );
  }
}
