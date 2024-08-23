import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyDriverModel {
  Timestamp? createAt;
  String? driverEmail;
  String? driverId;
  String? driverName;
  List<VerifyDocumentModel>? verifyDocument;

  VerifyDriverModel({
    this.createAt,
    this.driverEmail,
    this.driverId,
    this.driverName,
    this.verifyDocument,
  });

  @override
  String toString() {
    return 'VerifyDriverModel{createAt: $createAt, driverEmail: $driverEmail, driverId: $driverId, driverName: $driverName, verifyDocument: $verifyDocument}';
  }

  VerifyDriverModel.fromJson(Map<String, dynamic> json) {
    createAt = json['createAt'] != null ? Timestamp.fromMillisecondsSinceEpoch(json['createAt'].millisecondsSinceEpoch) : null;
    driverEmail = json['driverEmail'];
    driverId = json['driverId'];
    driverName = json['driverName'];
    if (json['verifyDocument'] != null) {
      verifyDocument = <VerifyDocumentModel>[];
      json['verifyDocument'].forEach((v) {
        verifyDocument!.add(VerifyDocumentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createAt'] = createAt;
    data['driverEmail'] = driverEmail;
    data['driverId'] = driverId;
    data['driverName'] = driverName;
    if (verifyDocument != null) {
      data['verifyDocument'] = verifyDocument!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VerifyDocumentModel {
  String? documentId;
  String? name;
  String? number;
  String? dob;
  List<dynamic>? documentImage;
  bool? isVerify;

  VerifyDocumentModel({
    this.documentId,
    this.name,
    this.number,
    this.dob,
    this.documentImage,
    this.isVerify,
  });

  @override
  String toString() {
    return 'VerifyDocumentModel{documentId: $documentId, name: $name, number: $number, dob: $dob, documentImage: $documentImage, isVerify: $isVerify}';
  }

  VerifyDocumentModel.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    name = json['name'];
    number = json['number'];
    dob = json['dob'];
    documentImage = json['documentImage'];
    isVerify = json['isVerify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentId'] = documentId;
    data['name'] = name;
    data['number'] = number;
    data['dob'] = dob;
    data['documentImage'] = documentImage;
    data['isVerify'] = isVerify;
    return data;
  }


  VerifyDocumentModel copyWith({
    String? documentId,
    String? name,
    String? number,
    String? dob,
    List<dynamic>? documentImage,
    bool? isVerify,
  }) {
    return VerifyDocumentModel(
      documentId: documentId ?? this.documentId,
      name: name ?? this.name,
      number: number ?? this.number,
      dob: dob ?? this.dob,
      documentImage: documentImage ?? this.documentImage,
      isVerify: isVerify ?? this.isVerify,
    );
  }

}
