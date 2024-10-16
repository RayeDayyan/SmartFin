import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartfin_guide/Screens/models/user.dart';

class UserController {

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;


  Future<bool> signUp(AppUser appUser) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: appUser.email,
        password: appUser.pass,
      );

      final userID = _auth.currentUser!.uid;

      await _fireStore.collection('users').doc(userID).set(appUser.toJson());


      return true;
    } catch (e) {
      print('error occured $e');
      return false;
    }
  }

  Future<bool> addClient(AppUser appUser) async {
    try {
      // Store current admin user
      final currentAdmin = _auth.currentUser;

      if (currentAdmin == null) {
        print('No admin is logged in');
        return false;
      }

      // Store current admin credentials
      final currentUserEmail = currentAdmin.email!;
      final currentUserPassword = await _getAdminPassword(
          currentAdmin.uid); // Get admin password securely

      // Create the new client user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: appUser.email,
        password: appUser.pass,
      );

      final clientUserID = userCredential.user!.uid;

      // Save the new client data to Firestore
      await _fireStore.collection('users').doc(clientUserID).set(
          appUser.toJson());

      // After creating the client, re-login as the admin to keep admin logged in
      await _auth.signOut(); // Sign out the new client user
      await _auth.signInWithEmailAndPassword(email: currentUserEmail,
          password: currentUserPassword); // Re-authenticate admin

      return true;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

// Helper function to retrieve admin password securely
  Future<String> _getAdminPassword(String adminUid) async {
    // This should be retrieved from secure storage or Firestore (if stored securely).
    final adminData = await _fireStore.collection('users').doc(adminUid).get();
    return adminData['password']; // You should have stored the password securely in Firestore or Secure Storage
  }


  Future<int> signIn(String email, String pass) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: pass);
      final userID = _auth.currentUser!.uid;

      final userData = await _fireStore.collection('users').doc(userID).get();

      AppUser appUser = AppUser.fromJson(userData.data()!);

      String role = appUser.role!;

      if (role == 'admin') {
        return 1;
      }

      else {
        return 2;
      }
    } catch (e) {
      print('error occured $e');
      return 0;
    }
  }

  Future<bool> updateUser(Map<String, String> updatedData) async {
    try {
      String userID = _auth.currentUser!.uid;
      await _fireStore.collection('users').doc(userID).update(updatedData);
      return true;
    } catch (e) {
      print('error occurred $e');
      return false;
    }
  }

  Future<AppUser?> getUserData() async {
    try {
      final userID = _auth.currentUser!.uid;

      final data = await _fireStore.collection('users').doc(userID).get();

      final user = AppUser.fromJson(data.data()!);

      return user;
    } catch (e) {
      print('error occurred $e');
      return null;
    }
  }

  Future<bool> updatePicture(XFile image) async {
    try {
      print('inside updatePicture');
      print(image); // This confirms that the image is received

      // Convert the XFile to a regular File
      File file = File(image.path);

      print(file);
      // Check if the file exists
      if (!file.existsSync()) {
        print('File does not exist');
        return false;
      }

      // Get the current user's ID
      final userID = FirebaseAuth.instance.currentUser?.uid;
      if (userID == null) {
        print('User not logged in.');
        return false;
      }

      // Initialize the storage reference for this user's profile picture
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('ProfilePicture/$userID');

      try {
        // Upload the file to Firebase Storage
        await storageRef.putFile(file);
        print('after storing');
      } catch (uploadError) {
        print('File upload error: $uploadError');
        return false;
      }

      // Get the download URL of the uploaded file
      final String downloadURL = await storageRef.getDownloadURL();

      // Update the user's profile picture URL in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .update({'profile': downloadURL});

      return true;
    } catch (e) {
      print('Error updating picture: $e');
      return false;
    }
  }


  Future<bool> changePass(String newPass, String oldPass) async {
    try {
      final userID = _auth.currentUser!.uid;
      final data = await _fireStore.collection('users').doc(userID).get();
      final appUser = AppUser.fromJson(data.data()!);

      final pass = appUser.pass;

      if (pass != oldPass) {
        print('Wrong old password');
        return false;
      }

      await _fireStore.collection('users').doc(userID).update(
          {'password': newPass});
      return true;
    }
    catch (e) {
      print('error occurred : $e');
      return false;
    }
  }

}

