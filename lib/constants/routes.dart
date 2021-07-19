import 'package:interpolation/interpolation.dart';

/// This class provides the routes used by the application.
///
class Routes {
  Routes._();

  final Interpolation interpolation = Interpolation();

  // Add your routes below
  static const String splash = '/splash';
  static const String home = '/home';
  static const String favoris = '/favoris';
  static const String search = '/search';
  static const String filterSearch = '/filterSearch';
  static const String searchResults = '/searchResults';
  static const String detailsAnnonce = '/detailsAnnonce';
  static const String photoView = '/photoView';
  static const String calculatrice = '/calculatrice';
  static const String auth = '/auth';
  static const String forgottenPassword = '/forgottenPassword';
  static const String creationCompte = '/creationCompte';
  static const String profil = '/profil';

  // Utility method used to build a dynamic route with params.
  // Example: Routes.buildRouteWithParams('/users/{id}, {'id': 1}); would generate '/users/1'
  String buildRouteWithParams(final String route, final Map<String, dynamic> params) {
    return interpolation.eval(route, params);
  }
}
