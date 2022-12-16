// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:vacancy_scraper/models/announcement.dart';

class User {
  final String name;
  final String email;
  final String password;
  final String jobCategory;
  final List<String> savedAnnouncementIDs;
  User({
    required this.name,
    required this.email,
    required this.password,
    required this.jobCategory,
    required this.savedAnnouncementIDs,
  });

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? jobCategory,
    List<String>? savedAnnouncementIDs,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      jobCategory: jobCategory ?? this.jobCategory,
      savedAnnouncementIDs: savedAnnouncementIDs ?? this.savedAnnouncementIDs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'jobCategory': jobCategory,
      'savedAnnouncementIDs': savedAnnouncementIDs,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        name: map['name'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        jobCategory: map['jobCategory'] as String,
        savedAnnouncementIDs: List<String>.from(
          (map['savedAnnouncementIDs'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, email: $email, password: $password, jobCategory: $jobCategory, savedAnnouncementIDs: $savedAnnouncementIDs)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.password == password &&
        other.jobCategory == jobCategory &&
        listEquals(other.savedAnnouncementIDs, savedAnnouncementIDs);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        jobCategory.hashCode ^
        savedAnnouncementIDs.hashCode;
  }
}
