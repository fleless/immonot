import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/get_profile_response.dart';
import 'package:immonot/models/responses/loginResponse.dart';
import 'package:immonot/ui/profil/auth/auth_bloc.dart';
import 'package:immonot/ui/profil/profil/profil_bloc.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';
import 'package:immonot/widgets/bottom_navbar_widget.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class AuthScreen extends StatefulWidget {
  bool openedAsDialog = false;

  AuthScreen(this.openedAsDialog);

  @override
  State<StatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final bloc = Modular.get<AuthBloc>();
  final _profileBloc = Modular.get<ProfilBloc>();
  final sessionController = Modular.get<SessionController>();
  final _formKey = GlobalKey<FormState>();
  final sharedPref = Modular.get<SharedPref>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  Future<void> initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: _buildText(),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: _buildForm(),
                ),
              ],
            ),
          ),
        ),
      ),
      //LoadingIndicator(loading: _bloc.loading),
      //NetworkErrorMessages(error: _bloc.error),
      bottomNavigationBar:
          widget.openedAsDialog ? null : const BottomNavbar(route: Routes.auth),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      color: Colors.transparent,
      child: ClipPath(
        clipper: WaveClipperTwo(),
        child: Container(
          height: double.infinity,
          color: AppColors.defaultColor.withOpacity(0.25),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Connectez-vous", style: AppStyles.titleStyle),
                SizedBox(height: 10),
                Icon(
                  Icons.lock,
                  color: AppColors.defaultColor,
                  size: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return RichText(
      textAlign: TextAlign.left,
      maxLines: 10,
      overflow: TextOverflow.clip,
      text: TextSpan(
        children: [
          TextSpan(
              text: "Pour retrouver et gérer ", style: AppStyles.textNormal),
          TextSpan(
              text: "vos recherches sauvegardées et vos alertes\n",
              style: AppStyles.mediumTitleStyle),
          TextSpan(
              text: "Pour consulter et gérer ", style: AppStyles.textNormal),
          TextSpan(
              text: "vos annonces favorites",
              style: AppStyles.mediumTitleStyle),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: AppColors.hint, width: 0.2),
                borderRadius: BorderRadius.circular(4.0)),
            elevation: 2,
            shadowColor: AppColors.hint,
            color: AppColors.appBackground,
            child: Center(
              child: TextFormField(
                controller: _emailController,
                cursorColor: AppColors.defaultColor,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _formKey.currentState.validate(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.hint, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.hint, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.alert, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.defaultColor, width: 1),
                  ),
                  contentPadding: EdgeInsets.only(
                      bottom: 0.0, left: 10.0, right: 0.0, top: 0.0),
                  errorStyle: TextStyle(height: 0),
                  hintText: "Email *",
                  hintStyle: AppStyles.hintSearch,
                ),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return "";
                  } else if (!EmailValidator.validate(value)) {
                    return "";
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 15),
          Card(
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: AppColors.hint, width: 0.2),
                borderRadius: BorderRadius.circular(4.0)),
            elevation: 2,
            shadowColor: AppColors.hint,
            color: AppColors.appBackground,
            child: Center(
              child: TextFormField(
                controller: _passwordController,
                cursorColor: AppColors.defaultColor,
                onChanged: (value) => _formKey.currentState.validate(),
                enableSuggestions: false,
                autocorrect: false,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.hint, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.hint, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.alert, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.defaultColor, width: 1),
                  ),
                  contentPadding: EdgeInsets.only(
                      bottom: 0.0, left: 10.0, right: 0.0, top: 0.0),
                  errorStyle: TextStyle(height: 0),
                  hintText: "Mot de passe",
                  hintStyle: AppStyles.hintSearch,
                ),
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return "";
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                  (states) => AppColors.defaultColor.withOpacity(0.2),
                ),
              ),
              onPressed: () {
                Modular.to.pushNamed(Routes.forgottenPassword);
              },
              child: Text(
                "Mot de passe oublié",
                style: AppStyles.underlinedPinkNormalStyle,
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 50,
            width: double.infinity,
            decoration: new BoxDecoration(
              color: AppColors.defaultColor,
              borderRadius: BorderRadius.all(
                  Radius.circular(AppConstants.BTN_CMN_RADIUS)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.BTN_CMN_RADIUS),
              child: ElevatedButton(
                child: _loading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: AppColors.white, strokeWidth: 1.0),
                      )
                    : Text("ME CONNECTER",
                        style: AppStyles.buttonTextWhite,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                onPressed: () {
                  _loading ? null : _goLogin();
                },
                style: ElevatedButton.styleFrom(
                    elevation: 3,
                    onPrimary: AppColors.white,
                    primary: AppColors.defaultColor,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 50,
            width: double.infinity,
            decoration: new BoxDecoration(
              color: AppColors.faceBookColor,
              borderRadius: BorderRadius.all(
                  Radius.circular(AppConstants.BTN_CMN_RADIUS)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.BTN_CMN_RADIUS),
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppIcons.fb),
                    SizedBox(width: 20),
                    Text("ME CONNECTER AVEC FACEBOOK",
                        style: AppStyles.buttonTextWhite,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ],
                ),
                onPressed: () async {
                  return null;
                },
                style: ElevatedButton.styleFrom(
                    elevation: 3,
                    onPrimary: AppColors.white,
                    primary: AppColors.faceBookColor,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 50,
            width: double.infinity,
            decoration: new BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.defaultColor, width: 1.5),
              borderRadius: BorderRadius.all(
                  Radius.circular(AppConstants.BTN_CMN_RADIUS)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.BTN_CMN_RADIUS),
              child: ElevatedButton(
                child: Text("CRÉER UN COMPTE",
                    style: AppStyles.buttonTextPink,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                onPressed: () {
                  Modular.to.pushNamed(Routes.creationCompte);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 3,
                    onPrimary: AppColors.defaultColor,
                    primary: AppColors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  _goLogin() async {
    setState(() {
      _loading = true;
    });
    if (_formKey.currentState.validate()) {
      LoginResponse resp =
          await bloc.login(_emailController.text, _passwordController.text);
      if (resp.accessToken == null) {
        showErrorToast(context, "Identifiant et/ou mot de passe incorrect.");
      } else {
        sharedPref.save(AppConstants.TOKEN_KEY, resp.accessToken);
        sharedPref.save(AppConstants.EMAIL_KEY, _emailController.text);
        sharedPref.save(AppConstants.PASSWORD_KEY, _passwordController.text);
        GetProfileResponse response = await _profileBloc.getProfileInfos();
        if (response != null) {
          sharedPref.save(AppConstants.PROFILE_INFO_KEY, response);
        } else {
          showErrorToast(context, "Une erreur est survenue.");
        }
        widget.openedAsDialog
            ? Modular.to.pop()
            : Modular.to.popAndPushNamed(Routes.profil);
      }
    }
    print("not validate");
    setState(() {
      _loading = false;
    });
  }
}
