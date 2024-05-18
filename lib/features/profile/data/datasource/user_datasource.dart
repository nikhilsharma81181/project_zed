// user_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_zed/features/profile/data/model/user_model.dart';
import 'package:project_zed/core/error/exceptions.dart';

abstract class UserDataSource {
  Future<UserModel> getUser(String userId);
  Future<void> updateUser(UserModel user);
  Future<void> createUser(UserModel user);
  Future<String> getCurrentUID();
}

class FirebaseUserDataSource implements UserDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseUserDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })   : _firestore = firestore,
        _auth = auth;

  @override
  Future<UserModel> getUser(String userId) async {
    final docRef = _firestore.collection('users').doc(userId);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      return UserModel.fromJson(data);
    } else {
      throw ServerException('User with ID $userId not found');
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final docRef = _firestore.collection('users').doc(user.userId);
    await docRef.update(user.toJson());
  }

  @override
  Future<void> createUser(UserModel user) async {
    final docRef = _firestore.collection('users').doc(user.userId);
    await docRef.set(user.toJson());
  }

  @override
  Future<String> getCurrentUID() async {
    if (_auth.currentUser != null) {
      return _auth.currentUser!.uid;
    } else {
      throw ServerException("No UserID found");
    }
  }
}
