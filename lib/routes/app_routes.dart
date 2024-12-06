import 'package:flutter/material.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/sign_in_screen/sign_in_screen.dart';
import '../presentation/sign_up_screen/sign_up_screen.dart';
import '../presentation/userdetails_screen/userdetails_screen.dart';
import '../presentation/users_list_screen/users_list_screen.dart';
import '../presentation/users_register_screen/users_register_screen.dart';
import '../presentation/users_register_two_screen/users_register_two_screen.dart';
import '../presentation/waitlist_screen/waitlist_screen.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String signInScreen = '/sign_in_screen';
  static const String signUpScreen = '/sign_up_screen';
  static const String usersListScreen = '/users_list_screen';
  static const String usersRegisterScreen = '/users_register_screen';
  static const String usersRegisterTwoScreen = '/users_register_two_screen';
  static const String waitlistScreen = '/waitlist_screen';
  static const String userdetailsScreen = '/userdetails_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    signInScreen: (context) => SignInScreen(),
    signUpScreen: (context) => SignUpScreen(),
    usersListScreen: (context) => UsersListScreen(),
    usersRegisterScreen: (context) => UsersRegisterScreen(),
    usersRegisterTwoScreen: (context) => UsersRegisterTwoScreen(),
    waitlistScreen: (context) => WaitlistScreen(),
    // userdetailsScreen: (context) => UserdetailsScreen(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    initialRoute: (context) => SignInScreen(),
  };
}
