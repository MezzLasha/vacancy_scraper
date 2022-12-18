// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:vacancy_scraper/models/announcement.dart';

class User {
  final String name;
  final String email;
  final String password;
  final String jobCategory;
  final List<Announcement> savedAnnouncements;
  User({
    required this.name,
    required this.email,
    required this.password,
    required this.jobCategory,
    required this.savedAnnouncements,
  });

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? jobCategory,
    List<Announcement>? savedAnnouncements,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      jobCategory: jobCategory ?? this.jobCategory,
      savedAnnouncements: savedAnnouncements ?? this.savedAnnouncements,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'jobCategory': jobCategory,
      'savedAnnouncements': savedAnnouncements.map((x) => x.toJson()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      jobCategory: map['jobCategory'] as String,
      savedAnnouncements: List<Announcement>.from(
        (map['savedAnnouncements'] as List<String>).map<Announcement>(
          (x) => Announcement.fromJson(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, email: $email, password: $password, jobCategory: $jobCategory, savedAnnouncements: $savedAnnouncements)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.name == name &&
        other.email == email &&
        other.password == password &&
        other.jobCategory == jobCategory &&
        listEquals(other.savedAnnouncements, savedAnnouncements);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        jobCategory.hashCode ^
        savedAnnouncements.hashCode;
  }
}
