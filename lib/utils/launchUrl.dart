import 'package:url_launcher/url_launcher.dart';

launchUrl(String url) async {
  if (await canLaunch(url))
    await launch(url);
  else
    // can't launch url, there is some error
    throw "Could not launch $url";
}