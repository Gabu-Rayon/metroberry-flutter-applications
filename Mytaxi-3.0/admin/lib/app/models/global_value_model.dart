class GlobalValueModel {
  String? distanceType;
  String? driverLocationUpdate;
  String? radius;
  String ? minimumAmountAcceptRide;

  GlobalValueModel({
    this.distanceType,
    this.driverLocationUpdate,
    this.radius,
    this.minimumAmountAcceptRide,
});

  GlobalValueModel.fromJson(Map<String, dynamic> json) {
     distanceType = json['distanceType'];
     driverLocationUpdate = json['driverLocationUpdate'];
     radius = json['radius'];
     minimumAmountAcceptRide = json['minimum_amount_accept_ride'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distanceType'] = distanceType ;
    data['driverLocationUpdate'] = driverLocationUpdate ;
    data['radius'] = radius ;
    data['minimum_amount_accept_ride'] = minimumAmountAcceptRide ?? "";
    return data;
  }


}
