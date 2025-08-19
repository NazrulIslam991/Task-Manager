class Urls {
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';
  static const String registationUrl = '$_baseUrl/Registration';
  static const String loginonUrl = '$_baseUrl/Login';
  static const String createTaskUrl = '$_baseUrl/createTask';
  static const String getNewTaskUrl = '$_baseUrl/listTaskByStatus/New';
  static const String getProgressTaskUrl =
      '$_baseUrl/listTaskByStatus/Progress';
  static const String getTaskStatusCountUrl = '$_baseUrl/taskStatusCount';
  static const String profileUpdateUrl = '$_baseUrl/ProfileUpdate';
  static updateTaskStatusUrl(String taskId, String status) =>
      '$_baseUrl/updateTaskStatus/$taskId/$status';
}
