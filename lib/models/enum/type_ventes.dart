import 'package:collection/collection.dart';

List<TypeVentesEnumeration> typeVentes = [
  TypeVentesEnumeration("LOCA", "Location"),
  TypeVentesEnumeration("VENC", "Vente aux enchères"),
  TypeVentesEnumeration("VIAG", "Viager"),
  TypeVentesEnumeration("VENT", "Achat"),
  TypeVentesEnumeration("VENT", "Vente aux enchères en ligne"),
];

class TypeVentesEnumeration {
  String code;
  String label;

  TypeVentesEnumeration(String code, String label) {
    this.code = code;
    this.label = label;
  }

  TypeVentesEnumeration.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['label'] = this.label;
    return data;
  }

  static TypeVentesEnumeration findTypeVenteByCode(String code) {
    return typeVentes
        .firstWhereOrNull((enumElement) => enumElement.code == code);
  }
}
