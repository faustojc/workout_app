import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:workout_routine/domain/routes/routes.dart';
import 'package:workout_routine/presentation/blocs/connection/connection_bloc.dart';
import 'package:workout_routine/presentation/blocs/home/home_cubit.dart';
import 'package:workout_routine/presentation/components/home/home_tab.dart';
import 'package:workout_routine/presentation/components/home/tabs/home_overview_tab.dart';
import 'package:workout_routine/presentation/components/home/tabs/inbox_tab.dart';
import 'package:workout_routine/presentation/components/home/tabs/records_tab.dart';
import 'package:workout_routine/presentation/components/home/tabs/settings_tab.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TabController tabController = useTabController(initialLength: 5);

    return BlocListener<ConnectionBloc, InternetStatus>(
      listener: (context, state) {
        if (state == InternetStatus.disconnected) {
          toastification.dismissAll();
          toastification.show(
            context: context,
            autoCloseDuration: const Duration(seconds: 3),
            alignment: Alignment.topCenter,
            backgroundColor: ThemeColor.grey,
            foregroundColor: ThemeColor.primary,
            primaryColor: ThemeColor.primary,
            type: ToastificationType.info,
            style: ToastificationStyle.flatColored,
            title: const Text('No internet connection, going offline'),
          );
        } else {
          toastification.dismissAll();
          toastification.show(
            context: context,
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 3),
            primaryColor: Colors.greenAccent,
            foregroundColor: Colors.greenAccent,
            backgroundColor: ThemeColor.grey,
            type: ToastificationType.success,
            style: ToastificationStyle.flatColored,
            title: const Text('Connected to the internet', style: TextStyle(color: Colors.white)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context, Routes.periodization),
          elevation: 4,
          backgroundColor: ThemeColor.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.fitness_center, color: ThemeColor.black),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          height: 60,
          color: ThemeColor.grey,
          child: TabBar(
            controller: tabController,
            dividerColor: Colors.transparent,
            indicatorColor: ThemeColor.primary,
            onTap: (index) => context.read<HomeCubit>().onSetPage(index),
            splashFactory: NoSplash.splashFactory,
            tabs: const [
              HomeTab(index: 0, icon: Icons.home),
              HomeTab(index: 1, icon: Icons.history),
              IgnorePointer(child: SizedBox.shrink()),
              HomeTab(index: 3, icon: Icons.inbox),
              HomeTab(index: 4, icon: Icons.person),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocListener<HomeCubit, int>(
            listener: (context, state) {
              tabController.animateTo(state, duration: const Duration(milliseconds: 300), curve: Curves.easeInOutCubicEmphasized);
            },
            child: TabBarView(
              controller: tabController,
              children: const [
                HomeOverviewTab(),
                RecentRecordsTab(),
                SizedBox.shrink(),
                InboxTab(),
                SettingsTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
