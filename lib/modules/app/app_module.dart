import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/ui/calculatrice/calculatrice_bloc.dart';
import 'package:immonot/ui/calculatrice/calculatrice_screen.dart';
import 'package:immonot/ui/favoris/favoris_bloc.dart';
import 'package:immonot/ui/favoris/favoris_screen.dart';
import 'package:immonot/ui/home/details_annonce/details_annonce_screen.dart';
import 'package:immonot/ui/home/details_annonce/photo_view_screen.dart';
import 'package:immonot/ui/home/home_bloc.dart';
import 'package:immonot/ui/home/home_screen.dart';
import 'package:immonot/ui/home/search_place/search_screen.dart';
import 'package:immonot/ui/home/search_results/filter_bloc.dart';
import 'package:immonot/ui/home/search_results/search_place_filter_screen.dart';
import 'package:immonot/ui/home/search_results/search_results_screen.dart';
import 'package:immonot/ui/splash/splash_screen.dart';
import 'package:immonot/utils/user_location.dart';
import 'app_widget.dart';

class AppModule extends MainModule {
  // Provide a list of dependencies to inject into your project
  @override
  List<Bind> get binds => [
        Bind((_) => HomeBloc()), // Injecting a BLoC
        Bind((_) => FilterBloc()), // Injecting a BLoC
        Bind((_) => UserLocation()), // Injecting userLocation
        Bind((_) => FavorisBloc()), // Injecting a BLoC
        Bind((_) => CalculatriceBloc()), // Injecting a BLoC
      ];

  // Provide all the routes for your module
  @override
  List<ModularRouter> get routers => [
        ...ModularRouter.group(
          transition: TransitionType.defaultTransition,
          routes: [
          ],
        ),
        ...ModularRouter.group(
          transition: TransitionType.downToUp,
          routes: [
            ModularRouter(Routes.search,
                child: (_, args) => SearchScreen(args.data['address'])),
            ModularRouter(Routes.filterSearch,
                child: (_, args) => SearchFilterScreen(args.data['address'])),
            ModularRouter(Routes.photoView,
                child: (_, args) => PhotoViewScreenWidget(args.data['image'])),
          ],
        ),
        ...ModularRouter.group(
          transition: TransitionType.rightToLeft,
          routes: [
            ModularRouter(Routes.searchResults,
                child: (_, args) => SearchResultsScreen()),
            ModularRouter(Routes.detailsAnnonce,
                child: (_, args) => DetailAnnonceWidget(args.data['id'])),
          ],
        ),
        ...ModularRouter.group(
          transition: TransitionType.fadeIn,
          routes: [
            ModularRouter(Routes.splash, child: (_, args) => SplashScreenWidget()),
            ModularRouter(Routes.home, child: (_, args) => HomeScreen(args.data['scroll'])),
            ModularRouter(Routes.favoris, child: (_, args) => FavorisScreen()),
            ModularRouter(Routes.calculatrice,
                child: (_, args) => CalculatriceScreen(args.data['index'])),
          ],
        ),
      ];

  // Provide the root widget associated with your module
  @override
  Widget get bootstrap => AppWidget();
}
