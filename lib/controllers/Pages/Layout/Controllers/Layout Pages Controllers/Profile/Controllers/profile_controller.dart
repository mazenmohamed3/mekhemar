import 'package:flutter/material.dart';
import 'package:mekhemar/controllers/Pages/Auth/sources/auth_datasource.dart';

class ProfileController {
  ProfileController({required AuthDatasource authDatasource}) : _authDatasource = authDatasource;

  final AuthDatasource _authDatasource;

  void logout(BuildContext context) {
    _authDatasource.logout(context);
  }
}