List<TypeVentesEnumeration> typeVentes = [
  TypeVentesEnumeration("LOCA","Location"),
  TypeVentesEnumeration("VENC","Vente aux enchères"),
  TypeVentesEnumeration("VIAG","Viager"),
  TypeVentesEnumeration("VENT","Achat"),
  TypeVentesEnumeration("VENT","Vente aux enchères en ligne"),
];

class TypeVentesEnumeration {
  String code;
  String label;

  TypeVentesEnumeration(String code, String label){
    this.code = code;
    this.label = label;
  }
}