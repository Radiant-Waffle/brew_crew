import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String uid;
  DataBaseService({this.uid});
  // collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');
  Future updateUserData(
      String sugars, String cream, String name, bool strength, int size) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'cream': cream,
      'name': name,
      'strength': strength,
      'size': size,
    });
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      cream: snapshot.data['cream'],
      strength: snapshot.data['strength'],
      size: snapshot.data['size'],
    );
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
          name: doc.data['name'] ?? '',
          strength: doc.data['strength'] ?? false,
          sugars: doc.data['sugars'] ?? "0",
          cream: doc.data['cream'] ?? "0",
          size: doc.data['size' ?? 0]);
    }).toList();
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
