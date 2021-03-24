class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String sugars;
  final String cream;
  final bool strength;
  final int size;

  UserData(
      {this.uid, this.name, this.sugars, this.cream, this.strength, this.size});
}
