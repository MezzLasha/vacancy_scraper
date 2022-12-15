import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:vacancy_scraper/models/announcement.dart';

class User {
  final String name;
  final String email;
  final String jobCategory;
  final List<Announcement> savedAnnouncements;
  User({
    required this.name,
    required this.email,
    required this.jobCategory,
    required this.savedAnnouncements,
  });

  User copyWith({
    String? name,
    String? email,
    String? jobCategory,
    List<Announcement>? savedAnnouncements,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      jobCategory: jobCategory ?? this.jobCategory,
      savedAnnouncements: savedAnnouncements ?? this.savedAnnouncements,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'jobCategory': jobCategory,
      'savedAnnouncements': savedAnnouncements.map((x) => x.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
      jobCategory: map['jobCategory'] as String,
      savedAnnouncements: List<Announcement>.from(
        (map['savedAnnouncements'] as List<int>).map<Announcement>(
          (x) => Announcement.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, email: $email, jobCategory: $jobCategory, savedAnnouncements: $savedAnnouncements)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.jobCategory == jobCategory &&
        listEquals(other.savedAnnouncements, savedAnnouncements);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        jobCategory.hashCode ^
        savedAnnouncements.hashCode;
  }
}
