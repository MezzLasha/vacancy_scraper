// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Announcement {
  String jobProvider;
  String jobProviderLink;
  String jobId;
  String website;
  String jobName;
  String jobRegion;
  String description;
  bool salary;
  bool newAdvert;
  bool aboutToExpire;
  String startDate;
  String endDate;
  String imageUrl;
  String attachmentUrl;
  String jobLink;
  Announcement({
    required this.jobProvider,
    required this.jobProviderLink,
    required this.jobId,
    required this.website,
    required this.jobName,
    required this.jobRegion,
    required this.description,
    required this.salary,
    required this.newAdvert,
    required this.aboutToExpire,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.attachmentUrl,
    required this.jobLink,
  });

  Announcement copyWith({
    String? jobProvider,
    String? jobProviderLink,
    String? jobId,
    String? website,
    String? jobName,
    String? jobRegion,
    String? description,
    bool? salary,
    bool? newAdvert,
    bool? aboutToExpire,
    String? startDate,
    String? endDate,
    String? imageUrl,
    String? attachmentUrl,
    String? jobLink,
  }) {
    return Announcement(
      jobProvider: jobProvider ?? this.jobProvider,
      jobProviderLink: jobProviderLink ?? this.jobProviderLink,
      jobId: jobId ?? this.jobId,
      website: website ?? this.website,
      jobName: jobName ?? this.jobName,
      jobRegion: jobRegion ?? this.jobRegion,
      description: description ?? this.description,
      salary: salary ?? this.salary,
      newAdvert: newAdvert ?? this.newAdvert,
      aboutToExpire: aboutToExpire ?? this.aboutToExpire,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      imageUrl: imageUrl ?? this.imageUrl,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      jobLink: jobLink ?? this.jobLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobProvider': jobProvider,
      'jobProviderLink': jobProviderLink,
      'jobId': jobId,
      'website': website,
      'jobName': jobName,
      'jobRegion': jobRegion,
      'description': description,
      'salary': salary,
      'newAdvert': newAdvert,
      'aboutToExpire': aboutToExpire,
      'startDate': startDate,
      'endDate': endDate,
      'imageUrl': imageUrl,
      'attachmentUrl': attachmentUrl,
      'jobLink': jobLink,
    };
  }

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      jobProvider: map['jobProvider'] as String,
      jobProviderLink: map['jobProviderLink'] as String,
      jobId: map['jobId'] as String,
      website: map['website'] as String,
      jobName: map['jobName'] as String,
      jobRegion: map['jobRegion'] as String,
      description: map['description'] as String,
      salary: map['salary'] as bool,
      newAdvert: map['newAdvert'] as bool,
      aboutToExpire: map['aboutToExpire'] as bool,
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      imageUrl: map['imageUrl'] as String,
      attachmentUrl: map['attachmentUrl'] as String,
      jobLink: map['jobLink'] as String,
    );
  }

  factory Announcement.fromFireStore(Map<String, dynamic> map, String jobId) {
    return Announcement(
      jobProvider: map['jobProvider'] as String,
      jobProviderLink: map['jobProviderLink'] as String,
      jobId: jobId,
      website: '',
      jobName: map['jobName'] as String,
      jobRegion: '',
      description: '',
      salary: map['salary'] as bool,
      newAdvert: map['newAdvert'] as bool,
      aboutToExpire: map['aboutToExpire'] as bool,
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      imageUrl: map['imageUrl'] as String,
      attachmentUrl: '',
      jobLink: map['jobLink'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Announcement.fromJson(String source) =>
      Announcement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Announcement(jobProvider: $jobProvider, jobProviderLink: $jobProviderLink, jobId: $jobId, website: $website, jobName: $jobName, jobRegion: $jobRegion, description: $description, salary: $salary, newAdvert: $newAdvert, aboutToExpire: $aboutToExpire, startDate: $startDate, endDate: $endDate, imageUrl: $imageUrl, attachmentUrl: $attachmentUrl, jobLink: $jobLink)';
  }

  @override
  bool operator ==(covariant Announcement other) {
    if (identical(this, other)) return true;

    return other.jobProvider == jobProvider &&
        other.jobProviderLink == jobProviderLink &&
        other.jobId == jobId &&
        other.website == website &&
        other.jobName == jobName &&
        other.jobRegion == jobRegion &&
        other.description == description &&
        other.salary == salary &&
        other.newAdvert == newAdvert &&
        other.aboutToExpire == aboutToExpire &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.imageUrl == imageUrl &&
        other.attachmentUrl == attachmentUrl &&
        other.jobLink == jobLink;
  }

  @override
  int get hashCode {
    return jobProvider.hashCode ^
        jobProviderLink.hashCode ^
        jobId.hashCode ^
        website.hashCode ^
        jobName.hashCode ^
        jobRegion.hashCode ^
        description.hashCode ^
        salary.hashCode ^
        newAdvert.hashCode ^
        aboutToExpire.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        imageUrl.hashCode ^
        attachmentUrl.hashCode ^
        jobLink.hashCode;
  }
}
