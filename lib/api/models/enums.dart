import 'package:enum_to_string/enum_to_string.dart';

import '../network/network_exception.dart';

enum ProvinceEnum { ANT, HAI, LIE, LIM, LUX, NAM, OVL, WVL, VBR, WBR }

enum ValutaEnum { EUR, USD, GBP }

class Province {
  static Map<ProvinceEnum, String> provinces = {
    ProvinceEnum.ANT: "Antwerpen",
    ProvinceEnum.HAI: "Henegouwen",
    ProvinceEnum.LIE: "Luik",
    ProvinceEnum.LIM: "Limburg",
    ProvinceEnum.LUX: "Luxemburg",
    ProvinceEnum.NAM: "Namen",
    ProvinceEnum.OVL: "Oost-Vlaandern",
    ProvinceEnum.WVL: "West-Vlaanderen",
    ProvinceEnum.VBR: "Vlaams-Brabant",
    ProvinceEnum.WBR: "Waals-Brabant",
  };

  static String getProvinceName(ProvinceEnum provinceAbr) {
    String? provinceName = provinces[provinceAbr];
    if (provinceName == null) {
      throw Exception("Province is not defined.");
    }
    return provinceName;
  }

  static ProvinceEnum? toProvinceEnum(String? province) {
    if (province == null) {
      return null;
    }
    ProvinceEnum? prov = EnumToString.fromString(ProvinceEnum.values, province);
    if (prov == null) {
      throw BackendException(['Province is not a valid value.']);
    }
    return prov;
  }
}

class Valuta {
  static Map<ValutaEnum, String> valutas = {
    ValutaEnum.EUR: '€',
    ValutaEnum.USD: '\$',
    ValutaEnum.GBP: '£',
  };

  static String getValutaSymbol(ValutaEnum valuta) {
    String? valutaSymbol = valutas[valuta];
    if (valutaSymbol == null) {
      throw Exception("Province is not defined.");
    }
    return valutaSymbol;
  }

  static ValutaEnum toValutaEnum(String string) {
    switch (string) {
      case 'EUR':
        return ValutaEnum.EUR;
      case 'USD':
        return ValutaEnum.USD;
      case 'GBP':
        return ValutaEnum.GBP;
      default:
        throw UnimplementedError('Valuta $string is not yet implemented.');
    }
  }
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
