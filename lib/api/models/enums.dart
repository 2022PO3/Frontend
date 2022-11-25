enum ProvinceEnum { ANT, HAI, LIE, LIM, LUX, NAM, OVL, WVL, VBR, WBR }

enum ValutaEnum { EUR, USD, GBP }

class Province {
  Map<ProvinceEnum, String> provinces = {
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

  String getProvinceName(ProvinceEnum provinceAbr) {
    String? provinceName = provinces[provinceAbr];
    if (provinceName == null) {
      throw Exception("Province is not defined.");
    }
    return provinceName;
  }
}

class Valuta {
  Map<ValutaEnum, String> valutas = {
    ValutaEnum.EUR: '€',
    ValutaEnum.USD: '\$',
    ValutaEnum.GBP: '£',
  };

  String getValutaSymbol(ValutaEnum valuta) {
    String? valutaSymbol = valutas[valuta];
    if (valutaSymbol == null) {
      throw Exception("Province is not defined.");
    }
    return valutaSymbol;
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
