import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/Models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/widgets/circular_progress_indicatior.dart';
import 'package:task_manager/ui/widgets/snake_bar_messege.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class ProgressTaskController extends GetxController {
  var isLoading = false.obs;
  var progressTaskList = <TaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getProgressTaskList();
  }

  Future<void> getProgressTaskList() async {
    try {
      isLoading.value = true;
      NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.getProgressTaskUrl,
      );
      isLoading.value = false;

      if (response.isSuccess) {
        List<TaskModel> list = [];
        for (Map<String, dynamic> jsonData in response.body!['data']) {
          list.add(TaskModel.fromJson(jsonData));
        }
        progressTaskList.value = list;
      } else {
        showSnackbarMessage(Get.context!, response.errorMessege!);
      }
    } catch (e) {
      isLoading.value = false;
      showSnackbarMessage(Get.context!, e.toString());
    }
  }
}

class ProgressTaskListScreen extends StatelessWidget {
  ProgressTaskListScreen({super.key});

  final ProgressTaskController controller = Get.put(ProgressTaskController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Obx(() {
        if (controller.isLoading.value) {
          return CenterCircularProgressIndiacator();
        } else if (controller.progressTaskList.isEmpty) {
          return const Center(child: Text("No tasks in progress"));
        } else {
          return ListView.builder(
            itemCount: controller.progressTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskType: TaskType.progress,
                taskModel: controller.progressTaskList[index],
                onStatusUpdate: () {
                  controller.getProgressTaskList();
                },
              );
            },
          );
        }
      }),
    );
  }
}
