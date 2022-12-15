import '../models/announcement.dart';
import '../models/user_model.dart';

abstract class DBInterface {
  User getUser();
  bool saveUser(User user);

  bool saveAnnouncement(Announcement announcement);
  List<Announcement> getAnnouncements();
}
