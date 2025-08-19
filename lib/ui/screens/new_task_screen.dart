import 'package:flutter/material.dart';
import 'package:task_manager/data/Models/task_model.dart';
import 'package:task_manager/data/Models/task_status_count.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/circular_progress_indicatior.dart';
import 'package:task_manager/ui/widgets/snake_bar_messege.dart';

import '../widgets/task_card.dart';
import '../widgets/task_count_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getTasksListProgress = false;
  bool _getTasksStatusCountProgress = false;
  List<TaskModel> _newTaskList = [];
  List<TaskStatusCountModel> _TaskStatusCount = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getNewTaskList();
      _getTaskStatusCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Visibility(
              visible: _getTasksStatusCountProgress == false,
              replacement: CenterCircularProgressIndiacator(),
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  itemCount: _TaskStatusCount.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCountSummaryCard(
                      title: _TaskStatusCount[index].id,
                      count: _TaskStatusCount[index].count,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 4),
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: _getTasksListProgress == false,
                replacement: CenterCircularProgressIndiacator(),
                child: ListView.builder(
                  itemCount: _newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskType: TaskType.tNew,
                      taskModel: _newTaskList[index],
                      onStatusUpdate: () {
                        _getNewTaskList();
                        _getTaskStatusCount();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _getNewTaskList() async {
    _getTasksListProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getNewTaskUrl,
    );

    _getTasksListProgress = false;
    setState(() {});

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = list;
    } else {
      if (mounted) {
        showSnackbarMessage(context, response.errorMessege!);
      }
    }
    _getTasksListProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getTaskStatusCount() async {
    _getTasksStatusCountProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getTaskStatusCountUrl,
    );

    _getTasksStatusCountProgress = false;
    setState(() {});

    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
      _TaskStatusCount = list;
    } else {
      if (mounted) {
        showSnackbarMessage(context, response.errorMessege!);
      }
    }
    _getTasksListProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _onTapAddNewTaskButton() {
    Navigator.pushNamed(context, AddNewTaskScreen.name);
  }
}
