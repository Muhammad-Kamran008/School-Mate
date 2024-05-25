import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolmate/controller/core/textstyle.dart';
import 'package:schoolmate/controller/utils/alert_diglogs.dart';
import 'package:schoolmate/view/student/fee/screen_fee.dart';
import 'package:schoolmate/view/teacher/chat/private_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolmate/controller/core/colors.dart';
import 'package:schoolmate/controller/core/functions.dart';
import 'package:schoolmate/controller/core/loading.dart';
import 'package:schoolmate/view/student/events/event_screen_student.dart';
import 'package:schoolmate/view/student/settings/settings_widget.dart';
import 'package:schoolmate/view/student/widgets/attendance_popup.dart';
import 'package:schoolmate/view/student/bloc/student_bloc.dart';
import 'package:schoolmate/view/student/tasks/student_tasks_screen.dart';
import 'package:schoolmate/view/student/widgets/student_home_widget.dart';
import 'package:schoolmate/view/teacher/school_events/school_events.dart';


class ScreenStudent extends StatefulWidget {
  const ScreenStudent({super.key});

  @override
  State<ScreenStudent> createState() => _ScreenStudentState();
}

Stream<DocumentSnapshot> studentstream = const Stream.empty();

class _ScreenStudentState extends State<ScreenStudent> {
  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(FetchStudentDataEvent());
  }

  int currentPageIndex = 0;
  int totalWorkingDays = 0;
  String id = '';
  String teacherId = '';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<StudentBloc, StudentState>(listener: (context, state) {
      if (state is StudentBottomNavigationState) {
        currentPageIndex = state.currentPageIndex;
      }
      if (state is FetchStudentDatasSuccessState) {
        teacherId = state.teacherId;
        id = state.studentId;
        totalWorkingDays = state.totalWorkingDaysCompleted;
        studentstream = state.studentstream;
      }
      if (state is LogOutState) {
        studentLogOut(context);
      }

      if (state is StudentActionsState) {
        if (state.index == 1) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScreenFeeStudent(),
          ));
        } else if (state.index == 0) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScreenStudentTasks(
                taskName: 'Home Work', studentName: state.name),
          ));
        } else if (state.index == 2) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScreenStudentTasks(
                taskName: 'Assignment', studentName: state.name),
          ));
        } else if (state.index == 3) {
          attendanceMessage(
              isTeacher: false,
              context: context,
              size: size,
              studentsMap: state.studentsMap,
              totalWorkingDaysCompleted: state.totalWorkingDaysCompleted);
        }
      }
    }, builder: (context, state) {
      return StreamBuilder<DocumentSnapshot>(
          stream: studentstream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget().studentHomeLoading(size);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              Map<String, dynamic> studentData =
                  snapshot.data!.data() as Map<String, dynamic>;
              final String name = studentData['first_name'];
              final String full_name =
                  "${studentData['first_name']} ${studentData['second_name']}";
              final String gender = studentData['gender'];

              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Student',
                    style: appbarTextStyle,
                  ),
                  actions: [
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScreenChatPrivate(
                                  name: full_name,
                                  image: 'lib/assets/images/teacher.jpg',
                                  studentId: id,
                                  gender: gender,
                                  isTeacher: false,
                                  teacherName: studentData['class_Teacher']),
                            )),
                        icon: Icon(
                          Icons.chat_outlined,
                          color: contentColor,
                        ))
                  ],
                  backgroundColor: appbarColor,
                ),
                body: IndexedStack(
                  index: currentPageIndex,
                  children: <Widget>[
                    PopScope(
                      canPop: false,
                      onPopInvoked: (didPop) async {
                        if (!didPop) {
                          if (currentPageIndex == 0) {
                            exitAlet(context);
                          }
                        }
                      },
                      child: StudentHomeWidget(
                        studentId: id,
                        students: studentData,
                        currentPageIndex: currentPageIndex,
                      ),
                    ),
                    PopScope(
                        canPop: false,
                        onPopInvoked: (didPop) async {
                          if (!didPop) {
                            context.read<StudentBloc>().add(
                                StudentBottomNavigationEvent(
                                    currentPageIndex: 0));
                          }
                        },
                        child:
                            ScreenSchoolEvents(isTeacher: false, name: name)),
                    PopScope(
                        canPop: false,
                        onPopInvoked: (didPop) async {
                          if (!didPop) {
                            context.read<StudentBloc>().add(
                                StudentBottomNavigationEvent(
                                    currentPageIndex: 0));
                          }
                        },
                        child: const ScreenEventsStudent()),
                    PopScope(
                        canPop: false,
                        onPopInvoked: (didPop) async {
                          if (!didPop) {
                            context.read<StudentBloc>().add(
                                StudentBottomNavigationEvent(
                                    currentPageIndex: 0));
                          }
                        },
                        child: const SettingsWidgetStudent()),
                  ],
                ),
                bottomNavigationBar: NavigationBar(
                  onDestinationSelected: (int index) {
                    context.read<StudentBloc>().add(
                        StudentBottomNavigationEvent(currentPageIndex: index));
                  },
                  indicatorColor: appbarColor,
                  selectedIndex: currentPageIndex,
                  destinations: const <Widget>[
                    NavigationDestination(
                      selectedIcon: Icon(
                        Icons.home,
                        color: headingColor,
                      ),
                      icon: Icon(
                        Icons.home_outlined,
                        color: headingColor,
                      ),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(
                        Icons.assignment_outlined,
                        color: headingColor,
                      ),
                      selectedIcon: Icon(
                        Icons.assignment,
                        color: headingColor,
                      ),
                      label: 'Applications',
                    ),
                    NavigationDestination(
                      icon: Icon(
                        Icons.campaign_outlined,
                        color: headingColor,
                      ),
                      selectedIcon: Icon(
                        Icons.campaign,
                        color: headingColor,
                      ),
                      label: 'Notice',
                    ),
                    NavigationDestination(
                      icon: Icon(
                        Icons.settings_outlined,
                        color: headingColor,
                      ),
                      selectedIcon: Icon(
                        Icons.settings,
                        color: headingColor,
                      ),
                      label: 'Settings',
                    ),
                  ],
                ),
              );
            } else {
              return LoadingWidget().studentHomeLoading(size);
            }
          });
    });
  }
}
