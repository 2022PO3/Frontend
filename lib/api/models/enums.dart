// ignore_for_file: constant_identifier_names

// Project imports:
import '../network/network_exception.dart';

enum ProvinceEnum {
  ANT('ANT', 'Antwerpen'),
  HAI('HAI', 'Henegouwen'),
  LIE('LIE', 'Luik'),
  LIM('LIM', 'Limburg'),
  LUX('LUX', 'Luxemburg'),
  NAM('NAM', 'Namen'),
  OVL('OVL', 'Oost-Vlaanderen'),
  WVL('WVL', 'West-Vlaanderen'),
  VBR('VBR', 'Vlaams-Brabant'),
  WBR('WBR', 'Waals-Brabant');

  final String short;
  final String name;
  const ProvinceEnum(this.short, this.name);

  factory ProvinceEnum.fromString(String province) => ProvinceEnum.values
          .firstWhere((e) => e.short == province || e.name == province,
              orElse: () {
        throw BackendException(['Province string is not a valid value.']);
      });

  factory ProvinceEnum.fromShort(String province) =>
      ProvinceEnum.values.firstWhere((e) => e.short == province, orElse: () {
        throw BackendException(['Province short is not a valid value.']);
      });

  factory ProvinceEnum.fromName(String province) =>
      ProvinceEnum.values.firstWhere((e) => e.name == province, orElse: () {
        throw BackendException(['Province name is not a valid value.']);
      });

  @override
  String toString() {
    return name;
  }

  String get databaseValue => short;
}

enum ValutaEnum {
  EUR('EUR', '€'),
  USD('USD', '\$'),
  GBP('GBP', '£');

  final String short;
  final String symbol;
  const ValutaEnum(this.short, this.symbol);

  factory ValutaEnum.fromString(String province) => ValutaEnum.values
          .firstWhere((e) => e.short == province || e.name == province,
              orElse: () {
        throw BackendException(['Valuta string is not a valid value.']);
      });

  factory ValutaEnum.fromShort(String province) =>
      ValutaEnum.values.firstWhere((e) => e.short == province, orElse: () {
        throw BackendException(['Valuta short is not a valid value.']);
      });

  factory ValutaEnum.fromName(String province) =>
      ValutaEnum.values.firstWhere((e) => e.name == province, orElse: () {
        throw BackendException(['Valuta name is not a valid value.']);
      });

  @override
  String toString() {
    return symbol;
  }

  String get databaseValue => short;
}

class WeekDays {
  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}
