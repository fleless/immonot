import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/ui/profil/auth/auth_bloc.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/widgets/bottom_navbar_widget.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class ForgottenPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final bloc = Modular.get<AuthBloc>();
  final _formKey = GlobalKey<FormState>();
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
      bottomNavigationBar: const BottomNavbar(route: Routes.auth),
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
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40, left: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    splashColor: AppColors.white,
                    onPressed: () {
                      Modular.to.pop();
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.chevronLeft,
                      color: AppColors.default_black,
                      size: 18,
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Mot de passe oublié ?", style: AppStyles.titleStyle),
                    SizedBox(height: 10),
                    Icon(
                      Icons.lock,
                      color: AppColors.defaultColor,
                      size: 60,
                    ),
                  ],
                ),
              ),
            ],
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
              text:
                  "Cette page vous permet de réinitialiser votre mot de passe afin d'accéder aux services personnalisés d'immonot.com.\n\n",
              style: AppStyles.textNormal),
          TextSpan(
              text: "Vous êtes un internaute ?\n\n",
              style: AppStyles.mediumTitleStyle),
          TextSpan(
              text:
                  "Veuillez saisir votre adresse e-mail afin que nous puissions vous faire parvenir un e-mail de réinitialisation de mot de passe.\n\n",
              style: AppStyles.textNormal),
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
                    : Text("RÉCUPÉRER MOT DE PASSE",
                        style: AppStyles.buttonTextWhite,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                onPressed: () {
                  _loading ? null : _goAction();
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
          SizedBox(height: 30),
        ],
      ),
    );
  }

  _goAction() async {
    setState(() {
      _loading = true;
    });
    if (_formKey.currentState.validate()) {
      bool resp = await bloc.forgottenPassword(_emailController.text);
      if (resp) {
        showSuccessToast(context, "Un email vous a été envoyé");
      } else {
        showErrorToast(context, "Une erreur est survenue");
      }
    }
    setState(() {
      _loading = false;
    });
  }
}
