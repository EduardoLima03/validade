class RegisterModel {
  String? id;
  String? ean;
  String? description;
  String? validity;
  int? quantity;
  String? shop;
  String? zone;
  String? corridor;
  String? registrationDate;

  RegisterModel(
      {this.id,
      this.ean,
      this.description,
      this.validity,
      this.quantity,
      this.shop,
      this.zone,
      this.corridor,
      this.registrationDate});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ean = json['ean'];
    description = json['description'];
    validity = json['validity'];
    quantity = json['quantity'];
    shop = json['shop'];
    zone = json['zone'];
    corridor = json['corridor'];
    registrationDate = json['registrationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ean'] = ean;
    data['description'] = description;
    data['validity'] = validity;
    data['quantity'] = quantity;
    data['shop'] = shop;
    data['zone'] = zone;
    data['corridor'] = corridor;
    data['registrationDate'] = registrationDate;
    return data;
  }
}
