import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/repositories/dbProvider.dart';

import '../models/user_model.dart';

class CacheRepository implements DBInterface {
  @override
  List<Announcement> getAnnouncements() {
    // TODO: implement getAnnouncements
    throw UnimplementedError();
  }

  @override
  User getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  bool saveAnnouncement(Announcement announcement) {
    // TODO: implement saveAnnouncement
    throw UnimplementedError();
  }

  @override
  bool saveUser(User user) {
    return true;
  }
}
