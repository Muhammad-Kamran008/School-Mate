import 'package:schoolmate/view/teacher/chat/bloc/chat_teacher_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolmate/controller/core/colors.dart';
import 'package:schoolmate/view/admin/bloc/admin_bloc.dart';
import 'package:schoolmate/view/requests/bloc/admin_request_bloc.dart';
import 'package:schoolmate/view/student/bloc/student_bloc.dart';
import 'package:schoolmate/view/teacher/controllers/teacherBloc1/teacher_bloc.dart';
import 'package:schoolmate/view/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import 'package:schoolmate/view/welcome/bloc/welcome_bloc.dart';
import 'package:schoolmate/view/welcome/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WelcomeBloc(),
        ),
        BlocProvider(
          create: (context) => AdminBloc(),
        ),
        BlocProvider(
          create: (context) => AdminRequestBloc(),
        ),
        BlocProvider(
          create: (context) => TeacherBloc(),
        ),
        BlocProvider(
          create: (context) => TeacherSecondBloc(),
        ),
        BlocProvider(
          create: (context) => StudentBloc(),
        ),
        BlocProvider(
          create: (context) => ChatTeacherBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'School App',
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const ScreenSplash(),
      ),
    );
  }
}
