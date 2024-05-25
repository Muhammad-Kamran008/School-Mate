import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolmate/controller/core/functions.dart';
import 'package:schoolmate/controller/core/textstyle.dart';
import 'package:schoolmate/view/admin/bloc/admin_bloc.dart';
import 'package:schoolmate/view/student/settings/privacy_screen.dart';
import 'package:schoolmate/view/widgets/my_appbar.dart';

bool? isSelected = false;

class ScreenSettingsAdmin extends StatelessWidget {
  const ScreenSettingsAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppbar('Settings'),
        body: BlocConsumer<AdminBloc, AdminState>(
          listener: (context, state) {
            if (state is LogOutState) {
              adminLogOut(context);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  ListTile(
                    title:  Text('Sign out', style: contentTextStyle,), 
                    trailing: const Icon(Icons.power_settings_new_outlined),
                    onTap: () => context.read<AdminBloc>().add(LogOutEvent()),
                  ),
                  const Divider(),
                  // ListTile(
                  //   title: Text( 
                  //     'Privacy Policy',
                  //     style: contentTextStyle,
                  //   ),
                  //   onTap: () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //             const ScreenPrivacyPolicyStudent(),
                  //       )),
                  // ),
                ],
              ),
            );
          },
        ));
  }
}
