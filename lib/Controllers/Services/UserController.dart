import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartfin_guide/Screens/models/user.dart';

class UserController{

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  Future<bool> signUp(AppUser appUser) async{
    try{


      final user = await _auth.createUserWithEmailAndPassword(
        email: appUser.email,
        password: appUser.pass,
      );

      final userID = _auth.currentUser!.uid;

      await _fireStore.collection('users').doc(userID).set(appUser.toJson());


      return true;


  }catch(e){
      print('error occured $e');
      return false;
  }

  }

  Future<int> signIn(String email,String pass) async{
    try{
      final user = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      final userID = _auth.currentUser!.uid;

      final userData = await _fireStore.collection('users').doc(userID).get();

      AppUser appUser = AppUser.fromJson(userData.data()!);

      String role = appUser.role!;

      if(role=='admin'){
        return 1;
      }

      else{
        return 2;
      }





    }catch(e){
      print('error occured $e');
      return 0;
    }
  }


}

