import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/ui/alertes/alertes_bloc.dart';
import 'package:immonot/ui/alertes/alertes_screen.dart';
import 'package:immonot/ui/alertes/screens/add_modif_alerte.dart';
import 'package:immonot/ui/alertes/screens/search_places_alertes.dart';
import 'package:immonot/ui/calculatrice/calculatrice_bloc.dart';
import 'package:immonot/ui/calculatrice/calculatrice_screen.dart';
import 'package:immonot/ui/favoris/favoris_bloc.dart';
import 'package:immonot/ui/favoris/favoris_screen.dart';
import 'package:immonot/ui/home/details_annonce/details_annonce_screen.dart';
import 'package:immonot/ui/home/details_annonce/photo_view_screen.dart';
import 'package:immonot/ui/home/home_bloc.dart';
import 'package:immonot/ui/home/home_screen.dart';
import 'package:immonot/ui/home/search_places/search_screen.dart';
import 'package:immonot/ui/home/search_results/filter_bloc.dart';
import 'package:immonot/ui/home/search_results/search_results_screen.dart';
import 'package:immonot/ui/home/widgets/webviews/annuaire_webView.dart';
import 'package:immonot/ui/home/widgets/webviews/info_conseil_webView.dart';
import 'package:immonot/ui/profil/auth/auth_bloc.dart';
import 'package:immonot/ui/profil/auth/auth_screen.dart';
import 'package:immonot/ui/profil/auth/creation_compte.dart';
import 'package:immonot/ui/profil/auth/password_forgotten.dart';
import 'package:immonot/ui/profil/profil/profil_bloc.dart';
import 'package:immonot/ui/profil/profil/profil_screen.dart';
import 'package:immonot/ui/splash/splash_screen.dart';
import 'package:immonot/utils/formatter_utils.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';
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
        Bind((_) => AlertesBloc()), // Injecting a BLoC
        Bind((_) => CalculatriceBloc()), // Injecting a BLoC
        Bind((_) => AuthBloc()),
        Bind((_) => ProfilBloc()),
        Bind((_) => SharedPref()),
        Bind((_) => SessionController()),
        Bind((_) => FormatterController()),
      ];

  // Provide all the routes for your module
  @override
  List<ModularRouter> get routers => [
        ...ModularRouter.group(
          transition: TransitionType.defaultTransition,
          routes: [
            ModularRouter(Routes.photoView,
                child: (_, args) => PhotoViewScreenWidget(args.data['image'],args.data['index'])),
          ],
        ),
        ...ModularRouter.group(
          transition: TransitionType.downToUp,
          routes: [
            ModularRouter(Routes.search,
                child: (_, args) => SearchScreen(args.data['address'])),
          ],
        ),
        ...ModularRouter.group(
          transition: TransitionType.rightToLeft,
          routes: [
            ModularRouter(Routes.searchResults,
                child: (_, args) => SearchResultsScreen()),
            ModularRouter(Routes.detailsAnnonce,
                child: (_, args) => DetailAnnonceWidget(args.data['id'])),
            ModularRouter(Routes.forgottenPassword,
                child: (_, args) => ForgottenPasswordScreen()),
            ModularRouter(Routes.creationCompte,
                child: (_, args) => CreationCompteScreen()),
          ],
        ),
        ...ModularRouter.group(
          transition: TransitionType.fadeIn,
          routes: [
            ModularRouter(Routes.splash,
                child: (_, args) => SplashScreenWidget()),
            ModularRouter(Routes.home,
                child: (_, args) => HomeScreen(args.data['scroll'])),
            ModularRouter(Routes.favoris, child: (_, args) => FavorisScreen()),
            ModularRouter(Routes.calculatrice,
                child: (_, args) => CalculatriceScreen(args.data['index'])),
            ModularRouter(Routes.auth,
                child: (_, args) => AuthScreen(args.data['openedAsDialog'])),
            ModularRouter(Routes.profil, child: (_, args) => ProfilScreen()),
            ModularRouter(Routes.infoConseilWebView,
                child: (_, args) =>
                    InfoConseilWebView(args.data['url'], args.data['tag'])),
            ModularRouter(Routes.annuaireWebView,
                child: (_, args) => AnnuaireWebView(
                    args.data['url'], args.data['ville'], args.data['nom'])),
            ModularRouter(Routes.alertes, child: (_, args) => AlertesScreen()),
            ModularRouter(Routes.addModifAlertes,
                child: (_, args) => AddModifAlerteScreen(
                    args.data['isAjout'], args.data['item'])),
            ModularRouter(Routes.searchPlacesAlertes,
                child: (_, args) => SearchPlacesAlertesScreen(
                    args.data['places'], args.data['address'])),
          ],
        ),
      ];

  // Provide the root widget associated with your module
  @override
  Widget get bootstrap => AppWidget();
}
