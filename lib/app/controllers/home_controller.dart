import 'package:flutter/widgets.dart';
import 'package:nylo_support/router/router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controller.dart';

class HomeController extends Controller {

  @override
  construct(BuildContext context) {
  }

  onTapShowTodos() {
    Navigator.pushNamed(context!, '/todos');
  }

  onTapShowActive() {
    Navigator.pushNamed(context!, '/active');
  }

  onTapShowArchive() {
    Navigator.pushNamed(context!, '/archive');
  }

  onTapNewTask() {
    Navigator.pushNamed(context!, '/new');
  }
}
