import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/pages/sub_page.dart';
import 'package:flutter_app/resources/widgets/active_widget.dart';
import 'package:flutter_app/resources/widgets/archived_widget.dart';
import 'package:flutter_app/resources/widgets/task_edit_widget.dart';
import 'package:flutter_app/resources/widgets/todos_widget.dart';
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

      // Add your routes here
      router.route(
          "/todos",
          (context) => SubPage(
                title: trans(context, "todos")!.capitalize(),
                child: TodosWidget(),
              ),
          transition: PageTransitionType.fade);

      router.route(
          "/active",
          (context) => SubPage(
                title: trans(context, "active")!.capitalize(),
            child: ActiveWidget(),
              ),
          transition: PageTransitionType.fade);

      router.route(
          "/archive",
          (context) => SubPage(
                title: trans(context, "archive")!.capitalize(),
              child: ArchivedWidget(),
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
            title: trans(context, "archive")!.capitalize(),
            child: TaskEditWidget(),
          ),
          transition: PageTransitionType.fade);

    });
