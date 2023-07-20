import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

import '/models/models.dart';
import '/repositories/repositories.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<User> getUser(String userId) {
    print('getting uer images from DB');
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

   @override
  Stream<List<User>> getUsers(User user) {
    return _firebaseFirestore
        .collection('users')
        .where('gender', whereIn: _selectGender(user))
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> updateUserPictures(User user, String imageName) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);

    return _firebaseFirestore.collection('users').doc(user.id).update({
      'imageUrls': FieldValue.arrayUnion([downloadUrl])
    });
  }

  @override
  Future<void> createUser(User user) async {
    await _firebaseFirestore.collection('users').doc(user.id).set(user.toMap());
  }

  @override
  Future<void> updateUser(User user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toMap())
        .then((value) => print('User document update'));
  }

 

  @override
  Stream<List<User>> getUsersToSwipe(User user) {
    return Rx.combineLatest2(
      getUser(user.id!),
      getUsers(user),
      (
        User currentUser,
        List<User> users,
      ) {
        return users.where(
          (user) {
            bool isCurrentUser = user.id == currentUser.id;
            bool wasSwipedLeft = currentUser.swipeLeft!.contains(user.id);
            bool wasSwipedRight = currentUser.swipeRight!.contains(user.id);
            bool isMatch = currentUser.matches!.contains(user.id);
            bool isWithinAgeRange =
                user.age >= currentUser.ageRangePreference![0] &&
                    user.age <= currentUser.ageRangePreference![1];

            if (isCurrentUser) return false;
            if (wasSwipedLeft) return false;
            if (wasSwipedRight) return false;
            if (isMatch) return false;
            if (!isWithinAgeRange) return false;

            return true;
          },
        ).toList();
      },
    );
  }

  @override
  Future<void> updateUserMatch(String userId, String matchId) async {
    // update the current user document
    await _firebaseFirestore.collection('users').doc(userId).update({
      'matches': FieldValue.arrayUnion([matchId])
    });

    // add the match in the other user docment
    await _firebaseFirestore.collection('users').doc(matchId).update({
      'matches': FieldValue.arrayUnion([userId])
    });
  }

  @override
  Stream<List<Match>> getMatches(User user) {
    return Rx.combineLatest2(
      getUser(user.id!),
      getUsers(user),
      (
        User currentUser,
        List<User> users,
      ) {
        return users
            .where((user) => currentUser.matches!.contains(user.id))
            .map(
              (user) => Match(
                userId: user.id!,
                matchUser: user,
                chat: Chat(id: '1', userIds: [
                  '1',
                  '2'
                ], messages: [
                  Message(
                    senderId: '1',
                    receiverId: '2',
                    message: 'hey, how do you do?',
                    dateTime: DateTime.now(),
                    timeString: DateFormat('jm').format(
                      DateTime.now(),
                    ),
                  )
                ]),
              ),
            )
            .toList();
      },
    );
  }

  @override
  Future<void> updateUserSwipe(
    String userId,
    String matchId,
    bool isSwipeRight,
  ) async {
    if (isSwipeRight) {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'swipeRight': FieldValue.arrayUnion([matchId])
      });
    } else {
      await _firebaseFirestore.collection('users').doc(userId).update({
        'swipeLeft': FieldValue.arrayUnion([matchId])
      });
    }
  }

  _selectGender(User user) {
    if (user.genderPreference!.isEmpty) {
      return ['Male', 'Female'];
    }
    return user.genderPreference;
  }
}
