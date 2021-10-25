import 'package:collection/collection.dart';

List<TypeBienEnumeration> typeBiens = [
  TypeBienEnumeration("APPT", "Appartement"),
  TypeBienEnumeration("MAIS", "Maison"),
  TypeBienEnumeration("BAGR", "Bien agricole"),
  TypeBienEnumeration("DIVE", "Divers"),
  TypeBienEnumeration("FMCO", "Fonds et/ou murs commerciaux"),
  TypeBienEnumeration("GAPA", "Garage - Parking"),
  TypeBienEnumeration("IMMR", "Immeuble"),
  TypeBienEnumeration("PROP", "Propriété"),
  TypeBienEnumeration("PROV", "Propriété viticole"),
  TypeBienEnumeration("TEBA", "Terrain à bâtir"),
  TypeBienEnumeration("TEBE", "Terrain de loisirs - bois - Etang"),
];

class TypeBienEnumeration {
  String code;
  String label;

  TypeBienEnumeration(String code, String label) {
    this.code = code;
    this.label = label;
  }

  TypeBienEnumeration.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['label'] = this.label;
    return data;
  }

  static TypeBienEnumeration findTypeBienByCode(String code) {
    return typeBiens
        .firstWhereOrNull((enumElement) => enumElement.code == code);
  }
}
