import 'package:flutter/material.dart';
import 'package:task_manager/data/Models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/widgets/circular_progress_indicatior.dart';
import 'package:task_manager/ui/widgets/snake_bar_messege.dart';

enum TaskType { tNew, progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskType,
    required this.taskModel,
    required this.onStatusUpdate,
  });

  final TaskType taskType;
  final TaskModel taskModel;
  final VoidCallback onStatusUpdate;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _updateTaskProgress = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              widget.taskModel.description,
              style: TextStyle(color: Colors.black54),
            ),
            Text('Date: ${widget.taskModel.createddate}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(
                    _getTaskTypeName(),
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  backgroundColor: _getTaskChipColor(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                Visibility(
                  visible: _updateTaskProgress == false,
                  replacement: CenterCircularProgressIndiacator(),
                  child: IconButton(
                    onPressed: () {
                      _showEditTAskStatusDialog();
                    },
                    icon: Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTaskChipColor() {
    if (widget.taskType == TaskType.tNew) {
      return Colors.purple;
    } else if (widget.taskType == TaskType.progress) {
      return Colors.yellow;
    } else if (widget.taskType == TaskType.completed) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  String _getTaskTypeName() {
    switch (widget.taskType) {
      case TaskType.tNew:
        return 'New';
      case TaskType.progress:
        return 'Progress';
      case TaskType.completed:
        return 'Completed';
      case TaskType.cancelled:
        return 'Cancelled';
    }
  }

  void _showEditTAskStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Change Staus'),
          content: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                title: Text('New'),
                trailing: _getTrallingTaskStatus(TaskType.tNew),
                onTap: () {
                  if (widget.taskType == TaskType.tNew) {
                    return;
                  } else {
                    _UpdataTAskStatus("New");
                  }
                },
              ),
              ListTile(
                title: Text('In Progress'),
                trailing: _getTrallingTaskStatus(TaskType.progress),
                onTap: () {
                  if (widget.taskType == TaskType.progress) {
                    return;
                  } else {
                    _UpdataTAskStatus("Progress");
                  }
                },
              ),
              ListTile(
                title: Text('Completed'),
                trailing: _getTrallingTaskStatus(TaskType.completed),
                onTap: () {
                  if (widget.taskType == TaskType.completed) {
                    return;
                  } else {
                    _UpdataTAskStatus("Completed");
                  }
                },
              ),
              ListTile(
                title: Text('Cancelled'),
                trailing: _getTrallingTaskStatus(TaskType.cancelled),
                onTap: () {
                  if (widget.taskType == TaskType.cancelled) {
                    return;
                  } else {
                    _UpdataTAskStatus("Cancelled");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _getTrallingTaskStatus(TaskType type) {
    return widget.taskType == type ? Icon(Icons.check) : null;
  }

  Future<void> _UpdataTAskStatus(String status) async {
    Navigator.pop(context);
    _updateTaskProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
    );

    _updateTaskProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      widget.onStatusUpdate();
    } else {
      if (mounted) {
        showSnackbarMessage(context, response.errorMessege!);
      }
    }
  }
}
