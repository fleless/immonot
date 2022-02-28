import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/get_profile_response.dart';
import 'package:immonot/ui/profil/profil/profil_bloc.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/utils/shared_preferences.dart';

class ChangePasswordWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final bloc = Modular.get<ProfilBloc>();
  final sharedPref = Modular.get<SharedPref>();
  int _civilityController = 1;
  final _mdpController = TextEditingController();
  final _newMdpController = TextEditingController();
  final _confirmMdpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _isPwdHidden = false;
  bool _isNewPwdHidden = false;
  bool _isConfirmPwdHidden = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  void _togglePasswordView() {
    setState(() {
      _isPwdHidden = !_isPwdHidden;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isConfirmPwdHidden = !_isConfirmPwdHidden;
    });
  }

  void _toggleNewPasswordView() {
    setState(() {
      _isNewPwdHidden = !_isNewPwdHidden;
    });
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Text(
                "Modifier mon mot de passe",
                style: AppStyles.titleStyleH2,
              ),
              SizedBox(height: 20),
              _buildMdp(),
              SizedBox(height: 20),
              _buildNewMdp(),
              SizedBox(height: 20),
              _buildConfirmMdp(),
              SizedBox(height: 30),
              _buildButton(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMdp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Mot de passe actuel",
            style: AppStyles.locationAnnonces, textAlign: TextAlign.left),
        Flexible(
          child: Container(
            height: 50,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              elevation: 2,
              shadowColor: AppColors.hint,
              color: AppColors.appBackground,
              child: Center(
                child: TextFormField(
                  controller: _mdpController,
                  obscureText: _isPwdHidden,
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.text,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 5, top: 0),
                      child: InkWell(
                        onTap: () {
                          _togglePasswordView();
                        },
                        child: Container(
                          width: 25,
                          height: double.infinity,
                          alignment: Alignment.centerRight,
                          child: Icon(
                            _isPwdHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.defaultColor,
                          ),
                        ),
                      ),
                    ),
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
                    if ((value.trim().isEmpty) || (value.length < 8)) {
                      return "";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text("- Le mot de passe doit contenir au moins 8 caractères",
            style: AppStyles.bottomNavTextNotSelectedStyle,
            textAlign: TextAlign.left),
        SizedBox(height: 3),
      ],
    );
  }

  Widget _buildNewMdp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Nouveau mot de passe",
            style: AppStyles.locationAnnonces, textAlign: TextAlign.left),
        Flexible(
          child: Container(
            height: 50,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              elevation: 2,
              shadowColor: AppColors.hint,
              color: AppColors.appBackground,
              child: Center(
                child: TextFormField(
                  controller: _newMdpController,
                  obscureText: _isNewPwdHidden,
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 5, top: 0),
                      child: InkWell(
                        onTap: () {
                          _toggleNewPasswordView();
                        },
                        child: Container(
                          height: double.infinity,
                          child: Icon(
                            _isNewPwdHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.defaultColor,
                          ),
                        ),
                      ),
                    ),
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
                    if ((value.trim().isEmpty) || (value.length < 8)) {
                      return "";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text("- Le mot de passe doit contenir au moins 8 caractères",
            style: AppStyles.bottomNavTextNotSelectedStyle,
            textAlign: TextAlign.left),
        SizedBox(height: 3),
      ],
    );
  }

  Widget _buildConfirmMdp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Confirmation mot de passe",
            style: AppStyles.locationAnnonces, textAlign: TextAlign.left),
        Flexible(
          child: Container(
            height: 50,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              elevation: 2,
              shadowColor: AppColors.hint,
              color: AppColors.appBackground,
              child: Center(
                child: TextFormField(
                  controller: _confirmMdpController,
                  obscureText: _isConfirmPwdHidden,
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 5, top: 0),
                      child: InkWell(
                        onTap: () {
                          _toggleConfirmPasswordView();
                        },
                        child: Container(
                          height: double.infinity,
                          child: Icon(
                            _isConfirmPwdHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.defaultColor,
                          ),
                        ),
                      ),
                    ),
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
                    hintText: "Confirmation mot de passe",
                    hintStyle: AppStyles.hintSearch,
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return "";
                    }
                    if (value != _newMdpController.text) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(
                    color: AppColors.defaultColor, strokeWidth: 1.0),
              )
            : Text("MODIFIER MON MOT DE PASSE",
                style: AppStyles.buttonTextPink,
                overflow: TextOverflow.ellipsis,
                maxLines: 1),
        onPressed: () async {
          _saveModifs();
        },
        style: ElevatedButton.styleFrom(
            side: BorderSide(width: 1.5, color: AppColors.defaultColor),
            elevation: 3,
            onPrimary: AppColors.defaultColor,
            primary: AppColors.white,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
    );
  }

  _saveModifs() async {
    setState(() {
      _loading = true;
    });
    String pass = await sharedPref.read(AppConstants.PASSWORD_KEY);
    if (_formKey.currentState.validate()) {
      if (_mdpController.text != pass) {
        showErrorToast(context, "le mot de passe actuel n'est pas correct");
      } else {
        bool resp = await bloc.resetPassword(
            _newMdpController.text, _mdpController.text);
        if (resp) {
          showSuccessToast(context, "Mot de passe changé avec succès");
        } else {
          showErrorToast(context, "Une erreur est survenue");
        }
      }
    }
    setState(() {
      _loading = false;
    });
  }
}
