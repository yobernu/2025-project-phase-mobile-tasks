
class UserData {
  final String userName;

  UserData({
    required this.userName,
  });

  String getUserName() {
    return userName;
  }
}
final UserData userData = UserData(userName: 'Yohannes');