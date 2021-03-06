import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/responses/get_profile_response.dart';
import 'package:immonot/ui/profil/auth/auth_bloc.dart';
import 'package:immonot/ui/profil/profil/profil_bloc.dart';
import 'package:immonot/ui/profil/profil/widgets/change_password_widget.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/utils/session_controller.dart';
import 'package:immonot/utils/shared_preferences.dart';

class MyProfilWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyProfilWidgetState();
}

class _MyProfilWidgetState extends State<MyProfilWidget> {
  int _civilityController = 1;
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  int _jeSuisController = 1;
  int _jeVeuxController = 1;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final sharedPref = Modular.get<SharedPref>();
  final bloc = Modular.get<ProfilBloc>();
  final auth_bloc = Modular.get<AuthBloc>();
  final sessionController = Modular.get<SessionController>();

  @override
  void initState() {
    super.initState();
    _loadInfos();
  }

  _loadInfos() async {
    GetProfileResponse req = GetProfileResponse.fromJson(
        await sharedPref.read(AppConstants.PROFILE_INFO_KEY));
    String email = await sharedPref.read(AppConstants.EMAIL_KEY);
    setState(() {
      _civilityController = req.civilite == null
          ? 1
          : req.civilite == "M"
              ? 1
              : 2;
      _prenomController.text = req.prenom == null ? "" : req.prenom;
      _nomController.text = req.nom == null ? "" : req.nom;
      _emailController.text = email == null ? "" : email;
      _zipController.text = req.codePostal == null ? "" : req.codePostal;
      _phoneController.text = req.telephone == null
          ? ""
          : req.telephone == "0000000000"
              ? null
              : req.telephone;
      _jeSuisController = req.estVendeur == null
          ? ""
          : req.estVendeur
              ? 2
              : 1;
      _jeVeuxController = req.souhaite == null
          ? ""
          : req.souhaite.toUpperCase() == "INVESTIR"
              ? 2
              : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
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
                "Mes coordonn??es",
                style: AppStyles.titleStyleH2,
              ),
              SizedBox(height: 20),
              _buildCivility(),
              SizedBox(height: 20),
              _buildPrenom(),
              SizedBox(height: 20),
              _buildNom(),
              SizedBox(height: 20),
              _buildEmail(),
              SizedBox(height: 20),
              _buildZIPCode(),
              SizedBox(height: 20),
              _buildPhone(),
              SizedBox(height: 20),
              SizedBox(height: 15),
              Text(
                "Ma situation immobili??re",
                style: AppStyles.titleStyleH2,
              ),
              SizedBox(height: 20),
              _buildJeSuisTextField(),
              SizedBox(height: 20),
              _buildJeVeuxTextField(),
              SizedBox(height: 30),
              _buildButton(),
              SizedBox(height: 30),
              ChangePasswordWidget(),
              SizedBox(height: 15),
              Divider(),
              SizedBox(height: 15),
              Center(
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        AppColors.defaultColor.withOpacity(0.2)),
                  ),
                  onPressed: () {
                    auth_bloc.deleteDevice();
                    sharedPref.remove(AppConstants.TOKEN_KEY);
                    sharedPref.remove(AppConstants.EMAIL_KEY);
                    sharedPref.remove(AppConstants.PASSWORD_KEY);
                    sharedPref.remove(AppConstants.PROFILE_INFO_KEY);
                    Modular.to.pushNamedAndRemoveUntil(
                        Routes.auth, (Route<dynamic> route) => false,
                        arguments: {'openedAsDialog': false});
                  },
                  child: Text("Se d??connecter",
                      style: AppStyles.underlinedPinkNormalStyle),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCivility() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Civilit??",
            style: AppStyles.locationAnnonces, textAlign: TextAlign.left),
        Flexible(
          child: Container(
            height: 50,
            width: double.infinity,
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  side: new BorderSide(color: AppColors.hint, width: 0.2),
                  borderRadius: BorderRadius.circular(4.0)),
              elevation: 2,
              shadowColor: AppColors.hint,
              color: AppColors.appBackground,
              child: Center(
                child: Theme(
                  // Create a unique theme with "ThemeData"
                  data: ThemeData(
                    primarySwatch: AppColors.defaultColorMaterial,
                  ),
                  child: DropdownSearch<String>(
                      searchBoxDecoration: null,
                      dropdownSearchDecoration: null,
                      maxHeight: 150,
                      mode: Mode.MENU,
                      showSelectedItem: true,
                      items: ["Monsieur", "Madame"],
                      label: "",
                      hint: "Civilit??",
                      onChanged: (value) {
                        setState(() {
                          value == "Monsieur"
                              ? _civilityController = 1
                              : _civilityController = 2;
                        });
                      },
                      selectedItem:
                          _civilityController == 1 ? "Monsieur" : "Madame"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Nom",
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
                  controller: _nomController,
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.text,
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
                    hintText: "Nom",
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
          ),
        ),
      ],
    );
  }

  Widget _buildPrenom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Pr??nom",
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
                  controller: _prenomController,
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.text,
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
                    hintText: "Pr??nom",
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
          ),
        ),
      ],
    );
  }

  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Email",
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
                    hintText: "Email",
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
          ),
        ),
      ],
    );
  }

  Widget _buildZIPCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Code postal",
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
                  controller: _zipController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'(^\d*)')),
                  ],
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.number,
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
                    hintText: "Code postal",
                    hintStyle: AppStyles.hintSearch,
                  ),
                  validator: (String value) {
                    if (value.length != 5) {
                      return "";
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

  Widget _buildPhone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("T??l??phone",
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
                  controller: _phoneController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'(^\d*)')),
                  ],
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.number,
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
                    hintText: "-",
                    hintStyle: AppStyles.hintSearch,
                  ),
                  validator: (String value) {
                    if (value.length == 0) {
                      return null;
                    }
                    if (value.length != 10) {
                      return "";
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

  Widget _buildJeSuisTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Je suis",
            style: AppStyles.locationAnnonces, textAlign: TextAlign.left),
        Flexible(
          child: Container(
            height: 50,
            width: double.infinity,
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  side: new BorderSide(color: AppColors.hint, width: 0.2),
                  borderRadius: BorderRadius.circular(4.0)),
              elevation: 2,
              shadowColor: AppColors.hint,
              color: AppColors.appBackground,
              child: Center(
                child: Theme(
                  // Create a unique theme with "ThemeData"
                  data: ThemeData(
                    primarySwatch: AppColors.defaultColorMaterial,
                  ),
                  child: DropdownSearch<String>(
                      searchBoxDecoration: null,
                      dropdownSearchDecoration: null,
                      maxHeight: 150,
                      mode: Mode.MENU,
                      showSelectedItem: true,
                      showAsSuffixIcons: false,
                      items: ["Locataire", "Propri??taire"],
                      label: "",
                      hint: "-",
                      onChanged: (value) {
                        setState(() {
                          value == "Locataire"
                              ? _jeSuisController = 1
                              : _jeSuisController = 2;
                        });
                      },
                      selectedItem: _jeSuisController == 1
                          ? "Locataire"
                          : "Propri??taire"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJeVeuxTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Je souhaite",
            style: AppStyles.locationAnnonces, textAlign: TextAlign.left),
        Flexible(
          child: Container(
            height: 50,
            width: double.infinity,
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  side: new BorderSide(color: AppColors.hint, width: 0.2),
                  borderRadius: BorderRadius.circular(4.0)),
              elevation: 2,
              shadowColor: AppColors.hint,
              color: AppColors.appBackground,
              child: Center(
                child: Theme(
                  // Create a unique theme with "ThemeData"
                  data: ThemeData(
                    primarySwatch: AppColors.defaultColorMaterial,
                  ),
                  child: DropdownSearch<String>(
                      searchBoxDecoration: null,
                      dropdownSearchDecoration: null,
                      maxHeight: 150,
                      mode: Mode.MENU,
                      showSelectedItem: true,
                      items: ["Habiter", "Investir"],
                      label: "",
                      hint: "-",
                      onChanged: (value) {
                        setState(() {
                          value == "Habiter"
                              ? _jeVeuxController = 1
                              : _jeVeuxController = 2;
                        });
                      },
                      selectedItem:
                          _jeVeuxController == 1 ? "Habiter" : "Investir"),
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
                    color: AppColors.white, strokeWidth: 1.0),
              )
            : Text("ENREGISTRER LES MODIFICATIONS",
                style: AppStyles.buttonTextWhite,
                overflow: TextOverflow.ellipsis,
                maxLines: 1),
        onPressed: () async {
          if (!_loading) _saveModifs();
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
    if (_formKey.currentState.validate()) {
      bool resp = await bloc.editProfile(
          _civilityController == 1 ? "M" : "MME",
          _prenomController.text,
          _nomController.text,
          _emailController.text,
          _zipController.text,
          _phoneController.text,
          _jeSuisController == 1 ? false : true,
          _jeVeuxController == 1 ? "Habiter" : "Investir");
      if (resp) {
        GetProfileResponse response = await bloc.getProfileInfos();
        if (response != null) {
          sharedPref.save(AppConstants.PROFILE_INFO_KEY, response);
        } else {
          showErrorToast(context, "Une erreur est survenue.");
        }
        showSuccessToast(
            context, "F??licitations, votre compte a bien ??t?? modifi??");
      } else {
        showErrorToast(context, "Une erreur est survenue");
      }
    }
    setState(() {
      _loading = false;
    });
  }
}
