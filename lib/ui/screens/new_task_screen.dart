import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/Models/task_model.dart';
import 'package:task_manager/data/Models/task_status_count.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/circular_progress_indicatior.dart';
import 'package:task_manager/ui/widgets/snake_bar_messege.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_summary_card.dart';

class NewTaskController extends GetxController {
  var isTaskListLoading = false.obs;
  var isStatusCountLoading = false.obs;

  var newTaskList = <TaskModel>[].obs;
  var taskStatusCountList = <TaskStatusCountModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getNewTaskList();
    getTaskStatusCount();
  }

  Future<void> getNewTaskList() async {
    try {
      isTaskListLoading.value = true;
      NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.getNewTaskUrl,
      );
      isTaskListLoading.value = false;

      if (response.isSuccess) {
        List<TaskModel> list = [];
        for (Map<String, dynamic> jsonData in response.body!['data']) {
          list.add(TaskModel.fromJson(jsonData));
        }
        newTaskList.value = list;
      } else {
        showSnackbarMessage(Get.context!, response.errorMessege!);
      }
    } catch (e) {
      isTaskListLoading.value = false;
      showSnackbarMessage(Get.context!, e.toString());
    }
  }

  Future<void> getTaskStatusCount() async {
    try {
      isStatusCountLoading.value = true;
      NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.getTaskStatusCountUrl,
      );
      isStatusCountLoading.value = false;

      if (response.isSuccess) {
        List<TaskStatusCountModel> list = [];
        for (Map<String, dynamic> jsonData in response.body!['data']) {
          list.add(TaskStatusCountModel.fromJson(jsonData));
        }
        taskStatusCountList.value = list;
      } else {
        showSnackbarMessage(Get.context!, response.errorMessege!);
      }
    } catch (e) {
      isStatusCountLoading.value = false;
      showSnackbarMessage(Get.context!, e.toString());
    }
  }
}

class NewTaskScreen extends StatelessWidget {
  NewTaskScreen({super.key});

  final NewTaskController controller = Get.put(NewTaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isStatusCountLoading.value) {
                return CenterCircularProgressIndiacator();
              } else if (controller.taskStatusCountList.isEmpty) {
                return const SizedBox(height: 100);
              } else {
                return SizedBox(
                  height: 100,
                  child: ListView.separated(
                    itemCount: controller.taskStatusCountList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = controller.taskStatusCountList[index];
                      return TaskCountSummaryCard(
                        title: item.id,
                        count: item.count,
                      );
                    },
                    separatorBuilder: (context, index) =>
                    const SizedBox(width: 4),
                  ),
                );
              }
            }),
            Expanded(
              child: Obx(() {
                if (controller.isTaskListLoading.value) {
                  return CenterCircularProgressIndiacator();
                } else if (controller.newTaskList.isEmpty) {
                  return const Center(child: Text("No new tasks"));
                } else {
                  return ListView.builder(
                    itemCount: controller.newTaskList.length,
                    itemBuilder: (context, index) {
                      final task = controller.newTaskList[index];
                      return TaskCard(
                        taskType: TaskType.tNew,
                        taskModel: task,
                        onStatusUpdate: () {
                          controller.getNewTaskList();
                          controller.getTaskStatusCount();
                        },
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.name);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
