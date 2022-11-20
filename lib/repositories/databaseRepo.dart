import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'package:vacancy_scraper/models/announcement.dart';

class DatabaseRepository {
  Future<List<Announcement>> fetchAnnouncements(
      int pageKey, int pageSize, dynamic filter) async {
    final response =
        await http.get(Uri.parse('https://jobs.ge/?page=$pageKey$filter'));
    // 'https://jobs.ge/?page=$pageKey&q=&cid=0&lid=0&jid=0&in_title=0&has_salary=0&is_ge=0&for_scroll=yes'));
    var document = parse(response.body);
    // List<Element> jobNames = document.getElementsByClassName('vip');
    Element tbody = document.getElementsByTagName('tbody').first;
    List<Element> rows = tbody.getElementsByTagName('tr');
    // print(tbody.text);

    List<Announcement> announcements =
        await compute(_computeGetAnnouncements, rows);

    return announcements;
  }

  Future<List<Announcement>> getHomeAnnouncements() async {
    final response = await http.get(Uri.parse(
        'https://jobs.ge/?page=1&q=&cid=0&lid=0&jid=0&in_title=0&has_salary=0&is_ge=0&for_scroll=yes'));

    var document = parse(response.body);
    // List<Element> jobNames = document.getElementsByClassName('vip');
    Element tbody = document.getElementsByTagName('tbody').first;
    List<Element> rows = tbody.getElementsByTagName('tr');
    // print(tbody.text);

    List<Announcement> announcements =
        await compute(_computeGetAnnouncements, rows);

    return announcements;
  }

  Future<List<Announcement>> _computeGetAnnouncements(
      List<Element> rows) async {
    List<Announcement> announcements = [];
    for (Element element in rows) {
      String jobProvider = '';
      String jobName = '';
      String jobId = '';
      String jobRegion = '';
      String description = '';
      String salary = '';
      String startDate = '';
      String endDate = '';
      String imageUrl = '';
      String jobLink = '';
      try {
        Element jobNameElement =
            element.getElementsByTagName('td')[1].getElementsByTagName('a')[0];

        jobLink = 'https://jobs.ge${jobNameElement.attributes.values.first}';
        jobName = jobNameElement.text;
      } catch (e) {}

      try {
        Element jobRegionElement =
            element.getElementsByTagName('td')[1].getElementsByTagName('i')[0];
        jobRegion = jobRegionElement.text;
      } catch (e) {}

      try {
        Element imageUrlElement = element
            .getElementsByTagName('td')[2]
            .getElementsByTagName('img')[0];

        imageUrl = imageUrlElement.attributes.entries.first.value;
      } catch (e) {}

      try {
        Element startDateElement = element.getElementsByTagName('td')[4];

        startDate = startDateElement.text;
      } catch (e) {}

      try {
        Element endDateElement = element.getElementsByTagName('td')[5];

        endDate = endDateElement.text;
      } catch (e) {}

      announcements.add(Announcement(
          jobProvider: jobProvider,
          jobName: jobName,
          jobId: jobLink.split('id=')[1],
          jobRegion: jobRegion,
          description: description,
          salary: salary,
          startDate: startDate,
          endDate: endDate,
          imageUrl: imageUrl,
          jobLink: jobLink));
    }

    return announcements;
  }

  Future<Announcement> getDetailedAd(Announcement oldAnnouncement) async {
    final response = await http.get(Uri.parse(oldAnnouncement.jobLink));

    var document = parse(response.body);
    Element dtable = document.getElementsByClassName('dtable').first;
    Element tbody = dtable.getElementsByTagName('tbody').first;

    Element descriptionTr = tbody.getElementsByTagName('tr')[3];
    Element providerTr = tbody.getElementsByTagName('tr')[1];

    Element providerB = providerTr.getElementsByTagName('b').first;

    String jobProv = providerB.text.replaceAll('\n', '');
    print(jobProv);
    while (jobProv.startsWith('\t')) {
      jobProv = jobProv.substring(1);
    }

    return oldAnnouncement.copyWith(
        jobProvider: jobProv,
        description: descriptionTr.outerHtml,
        jobId: oldAnnouncement.jobLink.split('id=')[1]);
  }
}
