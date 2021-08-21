import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controller.dart';

class HomeController extends Controller {

  @override
  construct(BuildContext context) {
  }

  onTapShowTodos() {
    print('onTapShowTodos');
  }

  onTapShowActive() {
    print('onTapShowActive');
  }

  onTapShowArchive() {
    print('onTapShowArchive');
  }

  onTapNewTask() {
    print('onTapNewTask');
  }
}
