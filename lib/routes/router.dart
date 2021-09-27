import 'package:Klinsy/resources/pages/home_page.dart';
import 'package:Klinsy/resources/pages/sub_page.dart';
import 'package:Klinsy/resources/widgets/active_widget.dart';
import 'package:Klinsy/resources/widgets/archived_widget.dart';
import 'package:Klinsy/resources/widgets/settings_widget.dart';
import 'package:Klinsy/resources/widgets/task_edit_widget.dart';
import 'package:Klinsy/resources/widgets/todos_widget.dart';
import 'package:nylo_support/helpers/helper.dart';
import 'package:nylo_support/router/router.dart';
import 'package:page_transition/page_transition.dart';

/*
|--------------------------------------------------------------------------
| App Router
|
| * [Tip] Create pages faster 🚀
| // Run the below in the terminal to create new a page and controller.
| // 'flutter pub run nylo_framework:main make:page my_page -c'
| // Learn more https://nylo.dev/docs/1.x/router
|--------------------------------------------------------------------------
*/

buildRouter() => nyCreateRoutes((router) {
      router.route(
          '/',
          (context) => SubPage(
                isHomeScreen: true,
                title: getEnv('APP_NAME'),
                child: MyHomePage(),
              ),
          transition: PageTransitionType.fade);

      // Add your routes here
      router.route(
          '/todos',
          (context) => SubPage(
                title: trans(context, 'todos')!.capitalize(),
                child: TodosWidget(),
              ),
          transition: PageTransitionType.fade);

      router.route(
          '/active',
          (context) => SubPage(
                title: trans(context, 'active')!.capitalize(),
                child: ActiveWidget(),
              ),
          transition: PageTransitionType.fade);

      router.route(
          '/archive',
          (context) => SubPage(
                title: trans(context, 'archive')!.capitalize(),
                child: ArchivedWidget(),
              ),
          transition: PageTransitionType.fade);

      router.route(
          '/new',
          (context) => SubPage(
                title: trans(context, 'new task')!.capitalize(),
                child: TaskEditWidget(),
              ),
          transition: PageTransitionType.fade);

      router.route(
          '/edit',
          (context) => SubPage(
                title: trans(context, 'archive')!.capitalize(),
                child: TaskEditWidget(),
              ),
          transition: PageTransitionType.fade);

      router.route(
          '/settings',
          (context) => SubPage(
                title: trans(context, 'settings')!.capitalize(),
                child: SettingsWidget(),
              ),
          transition: PageTransitionType.fade);

    });
