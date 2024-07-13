import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_routine/data/sources/database.dart';
import 'package:workout_routine/domain/providers/image_path_provider.dart';
import 'package:workout_routine/domain/repositories/auth_repo.dart';
import 'package:workout_routine/domain/repositories/form_repo.dart';
import 'package:workout_routine/domain/repositories/periodization_repo.dart';
import 'package:workout_routine/domain/repositories/user_repo.dart';
import 'package:workout_routine/domain/repositories/workout_repo.dart';
import 'package:workout_routine/domain/routes/app_route_observer.dart';
import 'package:workout_routine/presentation/blocs/auth/auth_bloc.dart';
import 'package:workout_routine/presentation/blocs/connection/connection_bloc.dart';
import 'package:workout_routine/presentation/blocs/home/home_cubit.dart';
import 'package:workout_routine/presentation/blocs/periodization/periodization_cubit.dart';
import 'package:workout_routine/presentation/blocs/user/user_cubit.dart';
import 'package:workout_routine/presentation/blocs/workout/workout_cubit.dart';
import 'package:workout_routine/presentation/pages/splash_screen.dart';
import 'package:workout_routine/presentation/themes/theme_color.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  widgetsBinding.addPostFrameCallback((_) async {
    final context = widgetsBinding.rootElement;

    if (context != null) {
      await Future.wait(ImagePathProvider.images.map((image) => precacheImage(AssetImage(image), context)));
    }
  });

  await Future.wait([
    Database.instance.initialize(),
    FastCachedImageConfig.init(
      subDir: (await getApplicationCacheDirectory()).path,
      clearCacheAfter: const Duration(days: 15),
    ),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(create: (_) => AuthRepo()),
        RepositoryProvider<UserRepo>(create: (_) => UserRepo()),
        RepositoryProvider<PeriodizationRepo>(create: (_) => PeriodizationRepo()),
        RepositoryProvider<WorkoutRepo>(create: (_) => WorkoutRepo()),
        RepositoryProvider<FormRepo>(create: (_) => FormRepo()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ConnectionBloc>(create: (_) => ConnectionBloc()..add(ConnectionCheck())),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepo: RepositoryProvider.of<AuthRepo>(context))..add(AuthCheck()),
          ),
          BlocProvider(
            create: (context) => UserCubit(
              userRepo: RepositoryProvider.of<UserRepo>(context),
            ),
          ),
          BlocProvider<WorkoutCubit>(
            create: (context) => WorkoutCubit(
              workoutRepo: RepositoryProvider.of<WorkoutRepo>(context),
              userRepo: RepositoryProvider.of<UserRepo>(context),
            ),
          ),
          BlocProvider<PeriodizationCubit>(
            create: (context) => PeriodizationCubit(
              periodizationRepo: RepositoryProvider.of<PeriodizationRepo>(context),
            ),
          ),
          BlocProvider<HomeCubit>(create: (context) => HomeCubit())
        ],
        child: MaterialApp(
          title: 'Strength and Conditioning',
          debugShowCheckedModeBanner: false,
          navigatorObservers: [AppRouteObserver()],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: ThemeColor.primary,
              primary: ThemeColor.primary,
              secondary: ThemeColor.secondary,
              surface: ThemeColor.black,
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
