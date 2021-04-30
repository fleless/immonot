import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/ui/home/home_bloc.dart';
import 'package:immonot/ui/home/home_screen.dart';
import 'package:immonot/ui/home/search_place/search_screen.dart';
import 'package:immonot/ui/home/search_results/filter_bloc.dart';
import 'package:immonot/ui/home/search_results/filter_screen.dart';
import 'package:immonot/ui/home/search_results/search_place_filter_screen.dart';
import 'package:immonot/ui/home/search_results/search_results_screen.dart';
import 'package:immonot/utils/user_location.dart';
import 'app_widget.dart';

class AppModule extends MainModule {
  // Provide a list of dependencies to inject into your project
  @override
  List<Bind> get binds => [
        Bind((_) => HomeBloc()), // Injecting a BLoC
        Bind((_) => FilterBloc()), // Injecting a BLoC
        Bind((_) => UserLocation()), // Injecting userLocation
      ];

  // Provide all the routes for your module
  @override
  List<ModularRouter> get routers => [
        ...ModularRouter.group(
          transition: TransitionType.defaultTransition,
          routes: [
            ModularRouter(Routes.home, child: (_, args) => HomeScreen()),
          ],
        ),
        ...ModularRouter.group(
          transition: TransitionType.downToUp,
          routes: [
            ModularRouter(Routes.search,
                child: (_, args) => SearchScreen(args.data['address'])),
            ModularRouter(Routes.filterSearch,
                child: (_, args) => SearchFilterScreen(args.data['address'])),
          ],
        ),
        ...ModularRouter.group(
          transition: TransitionType.rightToLeft,
          routes: [
            ModularRouter(Routes.searchResults,
                child: (_, args) => SearchResultsScreen()),
          ],
        ),
        ...ModularRouter.group(
          transition: TransitionType.fadeIn,
          routes: [],
        ),
      ];

  // Provide the root widget associated with your module
  @override
  Widget get bootstrap => AppWidget();
}
