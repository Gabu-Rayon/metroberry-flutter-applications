class AdminModel {
  String? name;
  String? email;
  String? password;
  String? image;
  String? contactNumber;
  bool? isDemo;

  AdminModel({this.name, this.email, this.password, this.image, this.contactNumber, this.isDemo});

  AdminModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    image = json['image'];
    contactNumber = json['contactNumber'];
    isDemo = json['isDemo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['image'] = image ?? "";
    data['contactNumber'] = contactNumber ?? "";
    data['isDemo'] = isDemo ?? false;
    return data;
  }
}
