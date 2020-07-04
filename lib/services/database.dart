import 'package:brewcrew/models/brew.dart';
import 'package:brewcrew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((e) => Brew(
            name: e.data['name'] ?? '',
            sugars: e.data['sugars'] ?? 0,
            strength: e.data['strength'] ?? '0'))
        .toList();
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.data['uid'],
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
    );
  }

  // collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  Future<void> updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
