class BrandModel {
  String? id;
  String? title;
  bool? isEnable;

  BrandModel({this.id, this.title, this.isEnable});

  @override
  String toString() {
    return 'BrandModel{id: $id, title: $title, isEnable: $isEnable}';
  }

  BrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isEnable = json['isEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['isEnable'] = isEnable;
    return data;
  }
}
