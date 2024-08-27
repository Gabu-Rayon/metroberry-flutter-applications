import 'package:cloud_firestore/cloud_firestore.dart';

class CurrencyModel {
  Timestamp? createdAt;
  String? symbol;
  String? code;
  bool? active;
  bool? symbolAtRight;
  String? name;
  int? decimalDigits;
  String? id;

  CurrencyModel({
    this.createdAt,
    this.symbol,
    this.code,
    this.active,
    this.symbolAtRight,
    this.name,
    this.decimalDigits,
    this.id,
  });

  @override
  String toString() {
    return 'CurrencyModel{createdAt: $createdAt, symbol: $symbol, code: $code, active: $active, symbolAtRight: $symbolAtRight, name: $name, decimalDigits: $decimalDigits, id: $id}';
  }

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    Timestamp? createdAt;
    if (json['createdAt'] != null &&
        json['createdAt'] is Map<String, dynamic>) {
      final timestampMap = json['createdAt'] as Map<String, dynamic>;
      final seconds = timestampMap['_seconds'] as int?;
      final nanoseconds = timestampMap['_nanoseconds'] as int?;
      if (seconds != null) {
        createdAt = Timestamp(seconds, nanoseconds ?? 0);
      }
    }

    return CurrencyModel(
      createdAt: createdAt,
      symbol: json['symbol'] as String?,
      code: json['code'] as String?,
      active: json['active'] as bool?,
      symbolAtRight: json['symbolAtRight'] as bool?,
      name: json['name'] as String?,
      decimalDigits: json['decimalDigits'] != null
          ? int.tryParse(json['decimalDigits'].toString()) ?? 2
          : 2,
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt != null
        ? {
            '_seconds': createdAt!.seconds,
            '_nanoseconds': createdAt!.nanoseconds
          }
        : null;
    data['symbol'] = symbol;
    data['code'] = code;
    data['active'] = active;
    data['symbolAtRight'] = symbolAtRight;
    data['name'] = name;
    data['decimalDigits'] = decimalDigits;
    data['id'] = id;
    return data;
  }
}
