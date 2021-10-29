import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/get_profile_response.dart';
import 'package:immonot/models/responses/newsletter_response.dart';
import 'package:immonot/ui/profil/auth/auth_bloc.dart';
import 'package:immonot/ui/profil/profil/profil_bloc.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/utils/launchUrl.dart';
import 'package:immonot/utils/shared_preferences.dart';

class MyParamsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyParamsWidgetState();
}

class _MyParamsWidgetState extends State<MyParamsWidget> {
  bool _firstSwitch = false;
  bool _secondSwitch = false;
  bool _thirdSwitch = false;
  bool _fourthSwitch = false;
  final bloc = Modular.get<AuthBloc>();
  final _profileBloc = Modular.get<ProfilBloc>();
  final sharedPref = Modular.get<SharedPref>();
  bool _loading = false;

  @override
  void initState() {
    _loadInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  _loadInfos() async {
    GetProfileResponse req = GetProfileResponse.fromJson(
        await sharedPref.read(AppConstants.PROFILE_INFO_KEY));
    if (req != null) {
      setState(() {
        _firstSwitch = req.subscribeNewsletterImmonot;
        _secondSwitch = req.subscribeMagazineDesNotaires;
        _thirdSwitch = req.subscribeInfosPartenairesImmonot;
        _fourthSwitch = req.subscribeInfosPartenairesMdn;
      });
    }
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              "Mes abonnements",
              style: AppStyles.titleStyleH2,
            ),
            SizedBox(height: 20),
            _buildFirstSwitch(),
            SizedBox(height: 10),
            _buildSecondSwitch(),
            SizedBox(height: 10),
            _buildThirdSwitch(),
            SizedBox(height: 10),
            _buildFourthSwitch(),
            SizedBox(height: 30),
            _buildButton(),
            SizedBox(height: 30),
            Divider(color: AppColors.hint),
            SizedBox(height: 30),
            Center(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                      AppColors.defaultColor.withOpacity(0.2)),
                ),
                onPressed: () {
                  bloc.deleteDevice();
                  sharedPref.remove(AppConstants.TOKEN_KEY);
                  sharedPref.remove(AppConstants.EMAIL_KEY);
                  sharedPref.remove(AppConstants.PASSWORD_KEY);
                  sharedPref.remove(AppConstants.PROFILE_INFO_KEY);
                  Modular.to.pushNamedAndRemoveUntil(
                      Routes.auth, (Route<dynamic> route) => false,
                      arguments: {'openedAsDialog': false});
                },
                child: Text("Se déconnecter",
                    style: AppStyles.underlinedPinkNormalStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildFirstSwitch() {
    return Row(
      children: [
        Switch(
            activeColor: AppColors.defaultColor,
            value: _firstSwitch,
            onChanged: (value) {
              setState(() {
                _firstSwitch = value;
              });
            }),
        SizedBox(width: 10),
        Expanded(
          child: RichText(
            textAlign: TextAlign.left,
            maxLines: 10,
            overflow: TextOverflow.clip,
            text: TextSpan(
              children: [
                TextSpan(
                    text:
                        "Je souhaite recevoir gratuitement la lettre d'information d'Immonot.com.\n",
                    style: AppStyles.textNormal),
                WidgetSpan(
                  child: SizedBox(
                    height: 22,
                  ),
                ),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        NewsLetterResponse res;
                        res = await bloc.getLastNewsLetter();
                        launchUrl(res.url);
                      },
                    text: "Voir la dernière",
                    style: AppStyles.underlinedPinkNormalStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildSecondSwitch() {
    return Row(
      children: [
        Switch(
            activeColor: AppColors.defaultColor,
            value: _secondSwitch,
            onChanged: (value) {
              setState(() {
                _secondSwitch = value;
              });
            }),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            "Je souhaite recevoir gratuitement le magazine des notaires.",
            style: AppStyles.textNormal,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  _buildThirdSwitch() {
    return Row(
      children: [
        Switch(
            activeColor: AppColors.defaultColor,
            value: _thirdSwitch,
            onChanged: (value) {
              setState(() {
                _thirdSwitch = value;
              });
            }),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            "Je souhaite recevoir des informations de la part des sociétés partenaires d'Immonot.com.",
            style: AppStyles.textNormal,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  _buildFourthSwitch() {
    return Row(
      children: [
        Switch(
            activeColor: AppColors.defaultColor,
            value: _fourthSwitch,
            onChanged: (value) {
              setState(() {
                _fourthSwitch = value;
              });
            }),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            "Je souhaite recevoir des informations de la part des sociétés partenaires du site du magazine-des-notaires.com.",
            style: AppStyles.textNormal,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildButton() {
    return Container(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(
                    color: AppColors.white, strokeWidth: 1.0),
              )
            : Text("ENREGISTRER LES MODIFICATIONS",
                style: AppStyles.buttonTextWhite,
                overflow: TextOverflow.ellipsis,
                maxLines: 1),
        onPressed: () async {
          _loading ? null : _saveModifs();
        },
        style: ElevatedButton.styleFrom(
            elevation: 3,
            onPrimary: AppColors.white,
            primary: AppColors.defaultColor,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
    );
  }

  _saveModifs() async {
    setState(() {
      _loading = true;
    });
    bool resp = await _profileBloc.editParams(
        _firstSwitch, _secondSwitch, _thirdSwitch, _fourthSwitch);
    if (resp) {
      GetProfileResponse response = await _profileBloc.getProfileInfos();
      if (response != null) {
        sharedPref.save(AppConstants.PROFILE_INFO_KEY, response);
      } else {
        showErrorToast(context, "Une erreur est survenue.");
      }
      showSuccessToast(
          context, "Félicitations, votre compte a bien été modifié");
    } else {
      showErrorToast(context, "Une erreur est survenue");
    }
    setState(() {
      _loading = false;
    });
  }
}
