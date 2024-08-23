import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawModel {
  String? id;
  String? driverId;
  String? note;
  String? paymentStatus;
  String? adminNote;
  String? amount;
  Timestamp? createdDate;
  Timestamp? paymentDate;
  BankDetailsModel? bankDetails;

  WithdrawModel({
    this.id,
    this.driverId,
    this.note,
    this.paymentStatus,
    this.adminNote,
    this.amount,
    this.createdDate,
    this.paymentDate,
    this.bankDetails,
  });

  @override
  String toString() {
    return 'WithdrawModel{id: $id, driverId: $driverId, note: $note, paymentStatus: $paymentStatus, adminNote: $adminNote, amount: $amount, createdDate: $createdDate, paymentDate: $paymentDate, bankDetails: $bankDetails}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['driverId'] = driverId;
    data['note'] = note;
    data['paymentStatus'] = paymentStatus;
    data['adminNote'] = adminNote;
    data['amount'] = amount;
    data['createdDate'] = createdDate;
    data['paymentDate'] = paymentDate;

    if (bankDetails != null) {
      data['bank_details'] = bankDetails!.toJson();
    }
    return data;
  }

  WithdrawModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driverId'];
    note = json['note'];
    paymentStatus = json['paymentStatus'];
    adminNote = json['adminNote'];
    amount = json['amount'];
    createdDate = json['createdDate'];
    paymentDate = json['paymentDate'];
    bankDetails = json['bank_details'] != null ? BankDetailsModel.fromJson(json['bank_details']) : null;
  }
}

class BankDetailsModel {
  String? id;
  String? driverID;
  String? holderName;
  String? accountNumber;
  String? swiftCode;
  String? ifscCode;
  String? bankName;
  String? branchCity;
  String? branchCountry;

  BankDetailsModel({
    this.id,
    this.driverID,
    this.holderName,
    this.accountNumber,
    this.swiftCode,
    this.ifscCode,
    this.bankName,
    this.branchCity,
    this.branchCountry,
  });

  @override
  String toString() {
    return 'BankDetailsModel{id: $id, driverID: $driverID, holderName: $holderName, accountNumber: $accountNumber, swiftCode: $swiftCode, ifscCode: $ifscCode, bankName: $bankName, branchCity: $branchCity, branchCountry: $branchCountry}';
  }

  BankDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverID = json['driverID'];
    holderName = json['holderName'];
    accountNumber = json['accountNumber'];
    swiftCode = json['swiftCode'];
    ifscCode = json['ifscCode'];
    bankName = json['bankName'];
    branchCity = json['branchCity'];
    branchCountry = json['branchCountry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['driverID'] = driverID;
    data['holderName'] = holderName;
    data['accountNumber'] = accountNumber;
    data['swiftCode'] = swiftCode;
    data['ifscCode'] = ifscCode;
    data['bankName'] = bankName;
    data['branchCity'] = branchCity;
    data['branchCountry'] = branchCountry;
    return data;
  }
}
