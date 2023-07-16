// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/blocs/blocs.dart';
import 'package:dating_app/cubits/signup/signup_cubit.dart';
import 'package:dating_app/repositories/auth/auth_repository.dart';
import 'package:dating_app/repositories/database/database_repository.dart';
import 'package:dating_app/repositories/storage/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_screens/screens.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => OnboardingScreen(),
    );
  }

  static const List<Tab> tabs = <Tab>[
    Tab(
      text: 'Start',
    ),
    Tab(
      text: 'Email',
    ),
    Tab(
      text: 'Email Verification',
    ),
    Tab(
      text: 'Demographics',
    ),
    Tab(
      text: 'Pictures',
    ),
    Tab(
      text: 'Biography',
    ),
    Tab(
      text: 'Location',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        

        return Scaffold(
          appBar: CustomAppBar(
            title: 'F-R-I-E-N-D-S',
            hasActions: false,
          ),
          body: TabBarView(
            children: [
              Start(
                tabController: tabController,
              ),
              Email(
                tabController: tabController,
              ),
              EmailVerification(
                tabController: tabController,
              ),
              Demo(
                tabController: tabController,
              ),
              Pictures(
                tabController: tabController,
              ),
              Bio(
                tabController: tabController,
              ),
              Location(
                tabController: tabController,
              ),
            ],
          ),
        );
      }),
    );
  }
}
