import 'package:events/controllers/consumer/home_controller.dart';
import 'package:get/get.dart';

import 'navigator.dart';

class Routes {
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const SIGN_IN = '/sign-in';
  static const SIGN_UP = '/sign-up';
  static const NAVIGATOR = '/navigator';

  static final routes = [
    GetPage(
      name: NAVIGATOR,
      page: () => NavigatorPage(),
      binding: BindingsBuilder(() {
        Get.put(HomeController(), permanent: true);
      }),
    ),
  ];

}