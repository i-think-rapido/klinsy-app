import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/reminder_model.dart';
import '../models/task_model.dart';

typedef TasksFound = Iterable<ITask>;

class TaskService {

  final String _tblTask = 'task';
  final String _colId = 'id';
  final String _colContent = 'content';

  final String _filename = 'tasks.db';
  Database? _db;

  TaskService._privateConstructor();
  static final TaskService _instance = TaskService._privateConstructor();
  factory TaskService() {
    return _instance;
  }

  Future<void> connect() async {
    if (_db == null) {
      final path = join(await getDatabasesPath(), _filename);
      _db = await openDatabase(path, version: 1, onOpen: (db) {}, onCreate:
      // create Database
          (Database db, int version) async {
        await db.execute('''
            
              CREATE TABLE $_tblTask ($_colId STRING PRIMARY KEY, $_colContent TEXT);
            
            ''');
      }
      );
    }
  }

  Future<void> close() async {
    await _db!.close();
    _db = null;
  }
  bool isClosed() => _db == null;

  Future<bool> hasId(String id) async {
    await connect();
    List<Map> maps = await _db!.query(_tblTask, columns: [_colId, _colContent], where: '$_colId = ?', whereArgs: [id]);
    return maps.length > 0;
  }

  Future<ITask> persist(ITask task) async {
    await connect();
    String stringified = json.encode(task.toJson());
    if (await hasId(task.id)) {
      // update
      await _db!.rawUpdate('''
        UPDATE $_tblTask SET $_colContent = ? WHERE $_colId = ?
      ''',
          [stringified, task.id]
      );
    }
    else {
      // create
      await _db!.rawInsert('''
        INSERT INTO $_tblTask($_colId, $_colContent) VALUES (?, ?)
      ''',
          [task.id, stringified]
      );
    }

    return task;
  }



  Future<ITask?> findById(String id) async {
    await connect();
    List<Map<String, Object?>> maps = await _db!.query(_tblTask, columns: [_colId, _colContent], where: '$_colId = ?', whereArgs: [id]);
    if (maps.length == 0) {
      return null;
    }
    else {
      return maps.map((JsonMap j) => Task.fromJsonCompatible(TaskJsonCompatible.fromJson(j['content']), json.decode(j['content']))).first;
    }
  }

  Future<TasksFound> findAll() async {
    await connect();
    List<Map<String, Object?>> maps = await _db!.query(_tblTask, columns: [_colId, _colContent]);

    var iter = maps.map((JsonMap j)
    {
      var decoded = json.decode(j['content']);
      var out = Task.fromJsonCompatible(
          TaskJsonCompatible.fromJson(decoded), decoded
      );
      return out;
    });

    var out = iter.toList();
    out.sort((a, b) => b.alert.millisecondsSinceEpoch - a.alert.millisecondsSinceEpoch);

    return out;
  }

  Future<TasksFound> findAllArchived() async => (await findAll())
      .where((task) => task.isArchived == true)
  ;

  Future<TasksFound> findAllActive() async => (await findAll())
      .where((task) => task.isArchived == false)
  ;

  Future<TasksFound> findAllTodos() async => (await findAllActive())
      .where((task) => task.hasToBeDone())
  ;

  Future<void> delete(ITask task) async {
    deleteById(task.id);
  }
  Future<void> deleteById(String id) async {
    await connect();
    await _db!.delete(_tblTask, where: '$_colId = ?', whereArgs: [id]);
  }

  Future<void> clear() async {
    await connect();
    await _db!.delete(_tblTask);
  }

  Future<int> count() async {
    return (await findAll()).length;
  }

  static ITask defaultTask() => Task(
        title: "play soccer",
        timeOfDay: TimeOfDay.now(),
        alert: DateTime.now(),
        reminder: DaysReminder(days: 1),
        picturePath: '<none>',
      );


}

