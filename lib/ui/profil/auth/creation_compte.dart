import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/app_constants.dart';
import 'package:immonot/constants/app_icons.dart';
import 'package:immonot/constants/routes.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/models/requests/create_account_request.dart';
import 'package:immonot/models/responses/newsletter_response.dart';
import 'package:immonot/ui/profil/auth/auth_bloc.dart';
import 'package:immonot/ui/profil/profil/profil_bloc.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/utils/launchUrl.dart';
import 'package:immonot/widgets/bottom_navbar_widget.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class CreationCompteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreationCompteScreenState();
}

class _CreationCompteScreenState extends State<CreationCompteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final bloc = Modular.get<AuthBloc>();
  final _profilBloc = Modular.get<ProfilBloc>();
  final _formKey = GlobalKey<FormState>();

  // 1 pour homme ; 2 pour femme
  int _civilityController = 1;
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _zipController = TextEditingController();
  final _mdpController = TextEditingController();
  final _confirmMdpController = TextEditingController();
  bool _newsLetter = false;
  bool _magazine = false;
  bool _info = false;
  bool _loading = false;
  bool _isPwdHidden = false;
  bool _isConfirmPwdHidden = false;

  @override
  Future<void> initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                    Text("Créer un compte", style: AppStyles.titleStyle),
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

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildCivility(),
          SizedBox(height: 20),
          _buildNom(),
          SizedBox(height: 20),
          _buildPrenom(),
          SizedBox(height: 20),
          _buildEmail(),
          SizedBox(height: 20),
          _buildZIPCode(),
          SizedBox(height: 20),
          _buildMDP(),
          SizedBox(height: 20),
          _buildConfirmMDP(),
          SizedBox(height: 15),
          _buildNews(),
          SizedBox(height: 15),
          buildRGPD(),
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
                    : Text("CRÉER MON COMPTE",
                        style: AppStyles.buttonTextWhite,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  if (_formKey.currentState.validate()) {
                    CreateAccountRequest data = CreateAccountRequest(
                        backlink:
                            "https://core-immonot.notariat.services/inbound/registration-confirmation",
                        civilite: _civilityController == 1 ? "M" : "MME",
                        nom: _nomController.text,
                        prenom: _prenomController.text,
                        codePostal: _zipController.text,
                        email: _emailController.text,
                        password: _mdpController.text,
                        confirmPassword: _confirmMdpController.text,
                        subscribeMagazineDesNotaires: _magazine,
                        subscribeInfosPartenaires: _info,
                        subscribeNewsletterImmonot: _newsLetter);
                    int resp = await _profilBloc.createAccount(data);
                    if (resp == 1) {
                      Modular.to.popAndPushNamed(Routes.auth,
                          arguments: {'openedAsDialog': false});
                      showSuccessToast(context, "Utilisateur créé avec succès");
                    } else if (resp == 2) {
                      showErrorToast(
                          context, "Cet utilisateur a déjà un compte");
                    } else {
                      showErrorToast(context, "Une erreur est survenue");
                    }
                  }
                  setState(() {
                    _loading = false;
                  });
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

  Widget _buildCivility() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Civilité",
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
                      items: ["M.", "Mme"],
                      label: "",
                      hint: "Civilité",
                      onChanged: (value) {
                        setState(() {
                          value == "M."
                              ? _civilityController = 1
                              : _civilityController = 2;
                        });
                      },
                      selectedItem: "M."),
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
        Text("Nom *",
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
        Text("Prénom *",
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
                    hintText: "Prénom",
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
        Text("Email *",
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
        Text("Code postal *",
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

  Widget _buildMDP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Mot de passe *",
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
                  onChanged: (value) => _formKey.currentState.validate(),
                  decoration: InputDecoration(
                    suffix: Padding(
                      padding: EdgeInsets.only(right: 5, top: 0),
                      child: InkWell(
                        onTap: () {
                          _togglePasswordView();
                        },
                        child: Icon(
                          _isPwdHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.defaultColor,
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
        Text("- Le mot de passe doit contenir au moins 4 caractères",
            style: AppStyles.bottomNavTextNotSelectedStyle,
            textAlign: TextAlign.left),
        SizedBox(height: 3),
      ],
    );
  }

  Widget _buildConfirmMDP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Confirmation mot de passe *",
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
                  onChanged: (value) => _formKey.currentState.validate(),
                  decoration: InputDecoration(
                    suffix: Padding(
                      padding: EdgeInsets.only(right: 5, top: 0),
                      child: InkWell(
                        onTap: () {
                          _toggleConfirmPasswordView();
                        },
                        child: Icon(
                          _isConfirmPwdHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.defaultColor,
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
                    if (value != _mdpController.text) {
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

  Widget _buildNews() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Switch(
                  activeColor: AppColors.defaultColor,
                  value: _newsLetter,
                  onChanged: (value) {
                    setState(() {
                      _newsLetter = value;
                    });
                  }),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.left,
                  maxLines: 10,
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text:
                              "Je souhaite recevoir gratuitement la newsletter d'Immonot.com. ",
                          style: AppStyles.textNormal),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              NewsLetterResponse res;
                              res = await bloc.getLastNewsLetter();
                              launchUrl(res.url);
                            },
                          text: "Voir la dernière",
                          style: AppStyles.pinkTextDescriptionStyle),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Switch(
                  activeColor: AppColors.defaultColor,
                  value: _magazine,
                  onChanged: (value) {
                    setState(() {
                      _magazine = value;
                    });
                  }),
              Expanded(
                child: Text(
                    "Je souhaite recevoir gratuitement le Magazine des Notaires.",
                    style: AppStyles.textNormal),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Switch(
                  activeColor: AppColors.defaultColor,
                  value: _info,
                  onChanged: (value) {
                    setState(() {
                      _info = value;
                    });
                  }),
              Expanded(
                child: Text(
                    "Je souhaite recevoir des informations de la part des sociétés partenaires d'Immonot.com.",
                    style: AppStyles.textNormal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRGPD() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith(
              (states) => AppColors.defaultColor.withOpacity(0.2),
            ),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: RichText(
                            textAlign: TextAlign.center,
                            maxLines: 1000,
                            overflow: TextOverflow.clip,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        "Les données communiquées via ce formulaire sont collectées avec votre consentement et sont destinées à Notariat Services S.A. en sa qualité de responsable du traitement.\n\n ",
                                    style: AppStyles.textDescriptionStyle),
                                TextSpan(
                                    text:
                                        "Les données de ce formulaire sont collectées afin de créer votre espace personnel, d'effectuer des statistiques sur le nombre d'inscrits par département ainsi que pour pouvoir personnaliser le contenu des alertes immobilières avec votre nom et votre prénom. Les données sont conservées jusqu'à ce que vous supprimiez votre compte Immonot, puis durant trente-six (36) mois.\n\n",
                                    style: AppStyles.textDescriptionStyle),
                                TextSpan(
                                    text:
                                        'Conformément à la loi "informatique et libertés"" et au RGPD, vous pouvez exercer vos droits d\'opposition, d\'accès, de rectification, d\'effacement, de limitation et de portabilité en effectuant une demande à l\'adresse suivante : ',
                                    style: AppStyles.textDescriptionStyle),
                                TextSpan(
                                    text: 'https://gdpr.notariat-services.com',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(
                                            "https://gdpr.notariat-services.com");
                                      },
                                    style: AppStyles
                                        .textDescriptionDefaultColorStyle),
                                TextSpan(
                                    text:
                                        '. Vous pouvez également adresser une réclamation auprès de la CNIL directement via son site internet ',
                                    style: AppStyles.textDescriptionStyle),
                                TextSpan(
                                    text: 'www.cnil.fr',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl("https://www.cnil.fr/");
                                      },
                                    style: AppStyles
                                        .textDescriptionDefaultColorStyle),
                                TextSpan(
                                    text: '.',
                                    style: AppStyles.textDescriptionStyle),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                });
          },
          child: Text("Confidentialité et conformité au RGPD.",
              style: AppStyles.underlinedPinkNormalStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 2)),
    );
  }
}
