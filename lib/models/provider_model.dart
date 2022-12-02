// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:vacancy_scraper/models/announcement.dart';

class JobProvider {
  String name;
  String imageUrl;
  String description;
  List<Announcement> announcements;
  JobProvider({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.announcements,
  });

  JobProvider copyWith({
    String? name,
    String? imageUrl,
    String? description,
    List<Announcement>? announcements,
  }) {
    return JobProvider(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      announcements: announcements ?? this.announcements,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'announcements': announcements.map((x) => x.toMap()).toList(),
    };
  }

  factory JobProvider.fromMap(Map<String, dynamic> map) {
    return JobProvider(
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
      announcements: List<Announcement>.from(
        (map['announcements'] as List<int>).map<Announcement>(
          (x) => Announcement.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory JobProvider.fromJson(String source) =>
      JobProvider.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'JobProvider(name: $name, imageUrl: $imageUrl, description: $description, announcements: $announcements)';
  }

  @override
  bool operator ==(covariant JobProvider other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.imageUrl == imageUrl &&
        other.description == description &&
        listEquals(other.announcements, announcements);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        imageUrl.hashCode ^
        description.hashCode ^
        announcements.hashCode;
  }
}
