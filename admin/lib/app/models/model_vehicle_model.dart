class ModelVehicleModel {
  String? id;
  String? brandId;
  String? title;
  bool? isEnable;

  ModelVehicleModel({this.id, this.brandId,this.title, this.isEnable});

  ModelVehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brandId'];
    title = json['title'];
    isEnable = json['isEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brandId'] = brandId;
    data['title'] = title;
    data['isEnable'] = isEnable;
    return data;
  }
}
