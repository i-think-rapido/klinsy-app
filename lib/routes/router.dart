import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/pages/sub_page.dart';
import 'package:nylo_support/helpers/helper.dart';
import 'package:nylo_support/router/router.dart';
import 'package:page_transition/page_transition.dart';

/*
|--------------------------------------------------------------------------
| App Router
|
| * [Tip] Create pages faster 🚀
| // Run the below in the terminal to create new a page and controller.
| // "flutter pub run nylo_framework:main make:page my_page -c"
| // Learn more https://nylo.dev/docs/1.x/router
|--------------------------------------------------------------------------
*/

buildRouter() => nyCreateRoutes((router) {
      router.route(
          "/",
          (context) => MyHomePage(
                title: getEnv("APP_NAME"),
              ),
          transition: PageTransitionType.fade);

      router.route(
          "/todos",
          (context) => SubPage(
                title: trans(context, "todos")!.capitalize(),
                child: Text('asdfasdf'),
              ),
          transition: PageTransitionType.fade);

      router.route(
          "/active",
          (context) => SubPage(
                title: trans(context, "active")!.capitalize(),
                child: Text('asdfasdf'),
              ),
          transition: PageTransitionType.fade);

      router.route(
          "/archive",
          (context) => SubPage(
                title: trans(context, "archive")!.capitalize(),
                child: Text('asdfasdf'),
              ),
          transition: PageTransitionType.fade);

      router.route(
          "/new",
          (context) => SubPage(
                title: trans(context, "new task")!.capitalize(),
                child: Text('asdfasdf'),
              ),
          transition: PageTransitionType.fade);

      router.route(
          "/edit",
          (context) => SubPage(
                title: trans(context, "edit task")!.capitalize(),
                child: Text('asdfasdf'),
              ),
          transition: PageTransitionType.fade);

      // Add your routes here

      // router.route("/new-page", (context) => NewPage());
    });
