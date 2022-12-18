import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/models/provider_model.dart';

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
      String jobProviderLink = '';
      String jobName = '';
      String jobId = '';
      String websiteLink = '';
      String jobRegion = '';
      String description = '';
      bool salary = false;
      bool newAdvert = false;
      bool aboutToExpire = false;
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
        var jobAttributesElement =
            element.getElementsByTagName('td')[1].getElementsByTagName('img');

        if (jobAttributesElement.any(
            (element) => element.attributes.containsValue('/i/salary.gif'))) {
          salary = true;
        }
        if (jobAttributesElement
            .any((element) => element.attributes.containsValue('/i/new.gif'))) {
          newAdvert = true;
        }
        if (jobAttributesElement
            .any((element) => element.attributes.containsValue('/i/exp.gif'))) {
          aboutToExpire = true;
        }
      } catch (e) {}

      try {
        Element jobRegionElement =
            element.getElementsByTagName('td')[1].getElementsByTagName('i')[0];
        jobRegion = jobRegionElement.text.substring(3);
      } catch (e) {}

      try {
        Element imageUrlElement = element
            .getElementsByTagName('td')[2]
            .getElementsByTagName('img')[0];

        imageUrl = imageUrlElement.attributes.entries.first.value;
      } catch (e) {}

      try {
        Element websiteUrlElement =
            element.getElementsByTagName('td')[2].getElementsByTagName('a')[0];

        websiteLink = websiteUrlElement.attributes.entries.first.value;

        if (!websiteLink.startsWith('http')) {
          websiteLink = '';
        }
      } catch (e) {}
      try {
        Element jobProviderLinkElement =
            element.getElementsByTagName('td')[3].getElementsByTagName('a')[0];
        jobProviderLink = jobProviderLinkElement.attributes.entries.first.value;
      } catch (e) {}

      try {
        Element jobProviderElement =
            element.getElementsByTagName('td')[3].getElementsByTagName('a')[0];

        jobProvider = jobProviderElement.text
            .substring(8, jobProviderElement.text.length - 6);
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
          jobProviderLink: 'https://www.jobs.ge${jobProviderLink}',
          jobName: jobName,
          jobId: jobLink.split('id=')[1],
          jobRegion: jobRegion,
          description: description,
          salary: salary,
          website: websiteLink,
          aboutToExpire: aboutToExpire,
          newAdvert: newAdvert,
          startDate: startDate,
          attachmentUrl: '',
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

    Element descriptionTr = tbody.getElementsByTagName('tr').last;
    String attachedFileUrl = '';
    if (tbody.text.contains('Attached File:') ||
        tbody.text.contains('თანდართული ფაილი:')) {
      Element attachedTr = tbody.getElementsByTagName('tr')[3];
      Element attachedA = attachedTr.getElementsByTagName('a').first;
      attachedFileUrl =
          'https://jobs.ge${attachedA.attributes.entries.firstWhere((element) => element.key == 'href').value}';
    }

    Element providerTr = tbody.getElementsByTagName('tr')[1];

    Element providerB = providerTr.getElementsByTagName('b').first;

    String jobProv = providerB.text.replaceAll('\n', '');
    while (jobProv.startsWith('\t')) {
      jobProv = jobProv.substring(1);
    }

    return oldAnnouncement.copyWith(
        jobProvider: jobProv,
        description: descriptionTr.outerHtml,
        attachmentUrl: attachedFileUrl,
        jobId: oldAnnouncement.jobLink.split('id=')[1]);
  }

  Future<Announcement> getDetailedAdFromID(String announcementID) async {
    final response = await http
        .get(Uri.parse('https://jobs.ge/ge/?view=jobs&id=$announcementID'));

    var document = parse(response.body);

    Element dtable = document.getElementsByClassName('dtable').first;
    Element tbody = dtable.getElementsByTagName('tbody').first;

    Element title =
        document.getElementById('job')!.getElementsByTagName('span').first;

    Element descriptionTr = tbody.getElementsByTagName('tr').last;
    String attachedFileUrl = '';
    if (tbody.text.contains('Attached File:')) {
      Element attachedTr = tbody.getElementsByTagName('tr')[3];
      Element attachedA = attachedTr.getElementsByTagName('a').first;
      attachedFileUrl =
          'https://jobs.ge${attachedA.attributes.entries.firstWhere((element) => element.key == 'href').value}';
    }

    Element providerTr = tbody.getElementsByTagName('tr')[1];

    Element providerB = providerTr.getElementsByTagName('b').first;

    Element dateElement = tbody.getElementsByTagName('td')[2];
    Element startDate = dateElement.getElementsByTagName('b')[0];
    Element endDate = dateElement.getElementsByTagName('b')[1];

    String jobProv = providerB.text.replaceAll('\n', '');
    while (jobProv.startsWith('\t')) {
      jobProv = jobProv.substring(1);
    }

    return Announcement(
        jobProvider: jobProv.replaceAll('\t', ''),
        description: descriptionTr.outerHtml,
        attachmentUrl: attachedFileUrl,
        jobId: announcementID,
        aboutToExpire: false,
        endDate: '${endDate.text}        ',
        imageUrl: '',
        jobLink: 'https://jobs.ge/ge/?view=jobs&id=${announcementID}',
        jobName: title.text.replaceAll('\t', '').replaceAll('\n', ''),
        jobRegion: '',
        jobProviderLink:
            'https://jobs.ge/ge/${providerTr.getElementsByTagName('a').first.attributes.entries.first.value}',
        newAdvert: false,
        salary: false,
        startDate: startDate.text,
        website: '');
  }

  Future<JobProvider> getProviderDetails(String providerLink) async {
    final response = await http.get(Uri.parse(providerLink));

    var document = parse(response.body);

    Element mainDiv = document.getElementsByClassName('content').first;
    String name = mainDiv.getElementsByTagName('h1').first.text;

    Element providerDetailsTR = mainDiv.getElementsByTagName('tr').first;

    String imageUrl = mainDiv
        .getElementsByTagName('img')
        .first
        .attributes
        .entries
        .firstWhere((element) => element.key == 'src')
        .value;
    //#wrapper > div.content > table > tbody > tr > td:nth-child(2) > p
    String description = '';
    try {
      description = providerDetailsTR.getElementsByTagName('p').first.outerHtml;
    } catch (e) {
      print(e);
    }

    Element announcementsDiv =
        document.getElementsByClassName('regularEntries').first;
    Element tbody = announcementsDiv.getElementsByTagName('tbody').first;
    List<Element> rows = tbody.getElementsByTagName('tr');
    rows.removeAt(0);
    List<Announcement> announcements =
        await compute(_computeGetAnnouncements, rows);

    String websiteLink = '';

    try {
      websiteLink =
          announcements.firstWhere((element) => element.website != '').website;
    } catch (e) {
      print(e);
    }

    final jobprovider = JobProvider(
        name: name,
        imageUrl: imageUrl,
        websiteLink: websiteLink,
        description: description,
        announcements: announcements);

    return jobprovider;
  }
}
