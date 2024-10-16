
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartfin_guide/Controllers/Services/UserController.dart';
import 'package:smartfin_guide/Screens/models/user.dart';

final userController = UserController();

final userProvider = FutureProvider<AppUser?>((ref)async{
  final user = userController.getUserData();
  return user;
});
