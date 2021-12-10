import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:immonot/constants/styles/app_styles.dart';
import 'package:immonot/utils/flushbar_utils.dart';
import 'package:immonot/utils/launchUrl.dart';

import '../../home_bloc.dart';
import "dart:ui" as ui;

class SendContactMessageDialog extends StatefulWidget {
  String idAnnonce;

  SendContactMessageDialog(this.idAnnonce);

  @override
  State<StatefulWidget> createState() => _SendContactMessageDialog();
}

class _SendContactMessageDialog extends State<SendContactMessageDialog> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _accepting = false;
  bool _loading = false;
  final bloc = Modular.get<HomeBloc>();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _messageController.text =
        "Bonjour,\n\nJe souhaite avoir des informations complémentaires concernant le bien que vous proposez sur Immonot.com :";
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
      //drawer: DrawerWidget(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Container(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Container(
              color: AppColors.appBackground,
              child: _buildTitle(),
            ),
            Divider(color: AppColors.hint),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                primary: true,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Container(
                    width: double.infinity,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          _buildNom(),
                          SizedBox(height: 20),
                          _buildPrenom(),
                          SizedBox(height: 20),
                          _buildPhone(),
                          SizedBox(height: 20),
                          _buildEmail(),
                          SizedBox(height: 20),
                          _buildMessage(),
                          SizedBox(height: 20),
                          _buildSwitcher(),
                          SizedBox(height: 20),
                          buildRGPD(),
                          SizedBox(height: 20),
                          _buildButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Material(
      color: AppColors.appBackground,
      child: ListTile(
        tileColor: AppColors.appBackground,
        title: Center(
          child: Text(
            "Formulaire de contact",
            style: AppStyles.titleStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            maxLines: 2,
          ),
        ),
        trailing: InkWell(
          onTap: () {
            Modular.to.pop();
          },
          child: FaIcon(
            FontAwesomeIcons.times,
            size: 22,
            color: AppColors.default_black,
          ),
        ),
      ),
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
                  side: new BorderSide(color: AppColors.hint, width: 0.2),
                  borderRadius: BorderRadius.circular(4.0)),
              elevation: 2,
              shadowColor: AppColors.hint,
              color: AppColors.appBackground,
              child: Center(
                child: TextFormField(
                  controller: _nomController,
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.alert)),
                    contentPadding: EdgeInsets.only(
                        bottom: 5.0, left: 10.0, right: 0.0, top: 0.0),
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
        Text("Prénom",
            style: AppStyles.locationAnnonces, textAlign: TextAlign.left),
        Flexible(
          child: Container(
            height: 50,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  side: new BorderSide(color: AppColors.hint, width: 0.2),
                  borderRadius: BorderRadius.circular(4.0)),
              elevation: 2,
              shadowColor: AppColors.hint,
              color: AppColors.appBackground,
              child: Center(
                child: TextFormField(
                  controller: _prenomController,
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        bottom: 5.0, left: 10.0, right: 0.0, top: 0.0),
                    errorStyle: TextStyle(height: 0),
                    hintText: "Prénom",
                    hintStyle: AppStyles.hintSearch,
                  ),
                  validator: (String value) {
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
        Text("Téléphone",
            style: AppStyles.locationAnnonces, textAlign: TextAlign.left),
        Flexible(
          child: Container(
            height: 50,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  side: new BorderSide(color: AppColors.hint, width: 0.2),
                  borderRadius: BorderRadius.circular(4.0)),
              elevation: 2,
              shadowColor: AppColors.hint,
              color: AppColors.appBackground,
              child: Center(
                child: TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'(^\d*)')),
                  ],
                  controller: _phoneController,
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        bottom: 5.0, left: 10.0, right: 0.0, top: 0.0),
                    errorStyle: TextStyle(height: 0),
                    hintText: "Tél",
                    hintStyle: AppStyles.hintSearch,
                  ),
                  validator: (String value) {
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
              clipBehavior: Clip.antiAlias,
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
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.alert)),
                    contentPadding: EdgeInsets.only(
                        bottom: 5.0, left: 10.0, right: 0.0, top: 0.0),
                    errorStyle: TextStyle(height: 0),
                    hintText: "Email",
                    hintStyle: AppStyles.hintSearch,
                  ),
                  validator: (String value) {
                    if (EmailValidator.validate(value) == false) {
                      return "";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Message *",
            style: AppStyles.locationAnnonces, textAlign: TextAlign.left),
        Flexible(
          child: Container(
            height: 150,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  side: new BorderSide(color: AppColors.hint, width: 0.2),
                  borderRadius: BorderRadius.circular(4.0)),
              elevation: 2,
              shadowColor: AppColors.hint,
              color: AppColors.appBackground,
              child: Align(
                alignment: Alignment.topLeft,
                child: TextFormField(
                  expands: true,
                  controller: _messageController,
                  maxLines: null,
                  cursorColor: AppColors.defaultColor,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.alert)),
                    contentPadding: EdgeInsets.only(
                        bottom: 5.0, left: 10.0, right: 0.0, top: 0.0),
                    errorStyle: TextStyle(height: 0),
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

  Widget _buildSwitcher() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Switch(
          activeColor: AppColors.defaultColor,
          value: _accepting,
          onChanged: (value) {
            setState(() {
              _accepting = value;
            });
          }),
      SizedBox(width: 10),
      Expanded(
        child: Text("J'accepte d'être mis en relation avec l'office notarial.",
            style: AppStyles.textNormal,
            overflow: TextOverflow.ellipsis,
            maxLines: 10),
      ),
    ]);
  }

  Widget buildRGPD() {
    return Align(
      alignment: Alignment.center,
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

  Widget _buildButton() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                elevation: 3,
                alignment: Alignment.center,
                onPrimary: AppColors.defaultColor,
                primary: _accepting ? AppColors.defaultColor : AppColors.grey,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                textStyle:
                    TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            onPressed: () {
              FocusScope.of(context).unfocus();
              _loading
                  ? null
                  : !_accepting
                      ? null
                      : _formKey.currentState.validate()
                          ? _goSend()
                          : null;
            },
            icon: _loading
                ? SizedBox(height: 1)
                : Icon(
                    Icons.send,
                    color: AppColors.white,
                  ),
            label: _loading
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.white),
                  )
                : Text(
                    "   CONTACTER L'OFFICE NOTARIAL",
                    style: AppStyles.buttonTextWhite,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )));
  }

  _goSend() async {
    setState(() {
      _loading = true;
    });
    String rep = await bloc.contactAnnonce(
        widget.idAnnonce,
        _nomController.text,
        _prenomController.text,
        _phoneController.text == "" ? 0 : int.parse(_phoneController.text),
        _emailController.text,
        _messageController.text);
    Modular.to.pop();
    showSuccessToast(context, "Votre message a été envoyé.");
    setState(() {
      _loading = false;
    });
  }
}
