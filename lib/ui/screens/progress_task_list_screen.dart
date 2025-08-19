import 'package:flutter/material.dart';
import 'package:task_manager/data/Models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/widgets/circular_progress_indicatior.dart';
import 'package:task_manager/ui/widgets/snake_bar_messege.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  bool _getProgressTasksInProgress = false;
  List<TaskModel> _ProgressTaskList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getProgressTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Visibility(
        visible: _getProgressTasksInProgress == false,
        replacement: CenterCircularProgressIndiacator(),
        child: ListView.builder(
          itemCount: _ProgressTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskType: TaskType.progress,
              taskModel: _ProgressTaskList[index],
              onStatusUpdate: () {
                _getProgressTaskList();
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    _getProgressTasksInProgress = true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.getProgressTaskUrl,
    );

    _getProgressTasksInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _ProgressTaskList = list;
    } else {
      showSnackbarMessage(context, response.errorMessege!);
    }
    _getProgressTasksInProgress = false;
    setState(() {});
  }
}
