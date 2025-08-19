import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/cancelled_task_list_screen.dart';
import 'package:task_manager/ui/screens/completed_task_list_screen.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';
import 'package:task_manager/ui/screens/progress_task_list_screen.dart';
import 'package:task_manager/ui/widgets/app_bar.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  static const name = '/Nav_bar_screen';

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  final List<Widget> _navigation_screen = [
    NewTaskScreen(),
    ProgressTaskListScreen(),
    CompletedTaskListScreen(),
    CancelledTaskListScreen(),
  ];
  int _selected_screen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TM_appbar(),
      body: _navigation_screen[_selected_screen],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selected_screen,
        onDestinationSelected: (int index) {
          _selected_screen = index;
          setState(() {});
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.new_label_outlined),
            label: 'New',
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_circle_right_outlined),
            label: 'Progress',
          ),
          NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
          NavigationDestination(icon: Icon(Icons.close), label: 'Cancelled'),
        ],
      ),
    );
  }
}
