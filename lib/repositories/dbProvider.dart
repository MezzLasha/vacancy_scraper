import '../models/announcement.dart';
import '../models/user_model.dart';

abstract class DBInterface {
  Future<User> loginUser(String email, String password);
  void registerUser(User user);

  void saveAnnouncement(Announcement announcement);
  List<Announcement> getAnnouncements();
}
