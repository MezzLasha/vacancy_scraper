// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
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

    List<Announcement> savedAnnouncements = [];
    List<dynamic> savedAnnouncementIDs = data['savedAnnouncements'];
    if (savedAnnouncementIDs.isNotEmpty) {
      CollectionReference announcementsRef =
          FirebaseFirestore.instance.collection('announcements');

      for (String fsJobId in savedAnnouncementIDs) {
        try {
          final el = await announcementsRef.doc(fsJobId).get();
          savedAnnouncements.add(Announcement.fromFireStore(
              el.data() as Map<String, dynamic>, fsJobId));
        } catch (e) {}
      }
    }

    final user = User(
        name: data['name'],
        email: email,
        password: password,
        jobCategory: data['category'],
        savedAnnouncements: savedAnnouncements);
    return user;
  }

  @override
  Future<List<Announcement>> saveAnnouncement(
      Announcement announcement, User user) async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    CollectionReference announcementsRef =
        FirebaseFirestore.instance.collection('announcements');
    Map<String, dynamic> userData;
    Map<String, dynamic> announcementData;

    var userDoc;

    await usersRef.doc(user.email).get().then((value) => userDoc = value);

    final oldListOfIds = userDoc['savedAnnouncements'] as List<dynamic>;

    if (oldListOfIds.contains(announcement.jobId)) {
      //REMOVE
      user.savedAnnouncements.remove(announcement);

      await usersRef.doc(user.email).set({
        'name': user.name,
        'category': user.jobCategory,
        'password': user.password,
        'savedAnnouncements':
            user.savedAnnouncements.map((e) => e.jobId).toList()
      });
    } else {
      //ADD / OVERWRITE IF EXSITS
      await announcementsRef.doc(announcement.jobId).set({
        'imageUrl': announcement.imageUrl,
        'jobLink': announcement.jobLink,
        'jobName': announcement.jobName,
        'jobProvider': announcement.jobProvider,
        'jobProviderLink': announcement.jobProviderLink,
        'salary': announcement.salary,
        'startDate': announcement.startDate,
        'endDate': announcement.endDate,
        'newAdvert': announcement.newAdvert,
        'aboutToExpire': announcement.aboutToExpire,
      });

      user.savedAnnouncements.add(announcement);

      await usersRef.doc(user.email).set({
        'name': user.name,
        'category': user.jobCategory,
        'password': user.password,
        'savedAnnouncements':
            user.savedAnnouncements.map((e) => e.jobId).toList()
      });
    }
    return user.savedAnnouncements;
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
        'savedAnnouncements': user.savedAnnouncements
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
