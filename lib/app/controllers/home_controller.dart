import 'package:Klinsy/app/models/task_model.dart';
import 'package:Klinsy/app/services/task_service.dart';
import 'package:flutter/widgets.dart';

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
    Navigator.pushNamed(context!, '/new', arguments: TaskProxy(TaskService.defaultTask()));
  }
}
