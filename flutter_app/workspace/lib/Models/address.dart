import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
    Address({
        this.name,
        this.topLevelDomain,
        this.alpha2Code,
        this.alpha3Code,
        this.callingCodes,
        this.capital,
        this.altSpellings,
        this.region,
        this.subregion,
        this.population,
        this.latlng,
        this.demonym,
        this.area,
        this.gini,
        this.timezones,
        this.borders,
        this.nativeName,
        this.numericCode,
        //this.currencies,
        //this.languages,
        //this.translations,
        this.flag,
        //this.regionalBlocs,
        this.cioc,
    });

    String name;
    List<String> topLevelDomain;
    String alpha2Code;
    String alpha3Code;
    List<String> callingCodes;
    String capital;
    List<String> altSpellings;
    String region;
    String subregion;
    String population;
    List<String> latlng;
    String demonym;
    String area;
    String gini;
    List<String> timezones;
    List<String> borders;
    String nativeName;
    String numericCode;
    //List<Currency> currencies;
    //List<Language> languages;
    //Translations translations;
    String flag;
    //List<RegionalBloc> regionalBlocs;
    String cioc;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        name: json["name"],
        topLevelDomain: null,//List<String>.from(json["topLevelDomain"].map((x) => x)),
        alpha2Code: null,//json["alpha2Code"],
        alpha3Code: null,//json["alpha3Code"],
        callingCodes: null,//List<String>.from(json["callingCodes"].map((x) => x)),
        capital: null,//json["capital"],
        altSpellings: null,//List<String>.from(json["altSpellings"].map((x) => x)),
        region: json["region"],
        subregion: null,//json["subregion"],
        population: null,//json["population"],
        latlng: null,//List<String>.from(json["latlng"].map((x) => x)),
        demonym: null,//json["demonym"],
        area: null,//json["area"],
        gini: null,//json["gini"],
        timezones: null,//List<String>.from(json["timezones"].map((x) => x)),
        borders: null,//List<String>.from(json["borders"].map((x) => x)),
        nativeName: null,//json["nativeName"],
        numericCode: null,//json["numericCode"],
        //currencies: List<Currency>.from(json["currencies"].map((x) => Currency.fromJson(x))),
        //languages: List<Language>.from(json["languages"].map((x) => Language.fromJson(x))),
        //translations: Translations.fromJson(json["translations"]),
        flag: null,//json["flag"],
        //regionalBlocs: List<RegionalBloc>.from(json["regionalBlocs"].map((x) => RegionalBloc.fromJson(x))),
        cioc: null,//json["cioc"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "topLevelDomain": List<dynamic>.from(topLevelDomain.map((x) => x)),
        "alpha2Code": alpha2Code,
        "alpha3Code": alpha3Code,
        "callingCodes": List<dynamic>.from(callingCodes.map((x) => x)),
        "capital": capital,
        "altSpellings": List<dynamic>.from(altSpellings.map((x) => x)),
        "region": region,
        "subregion": subregion,
        "population": population,
        "latlng": List<dynamic>.from(latlng.map((x) => x)),
        "demonym": demonym,
        "area": area,
        "gini": gini,
        "timezones": List<dynamic>.from(timezones.map((x) => x)),
        "borders": List<dynamic>.from(borders.map((x) => x)),
        "nativeName": nativeName,
        "numericCode": numericCode,
        //"currencies": List<dynamic>.from(currencies.map((x) => x.toJson())),
        //"languages": List<dynamic>.from(languages.map((x) => x.toJson())),
        //"translations": translations.toJson(),
        "flag": flag,
        //"regionalBlocs": List<dynamic>.from(regionalBlocs.map((x) => x.toJson())),
        "cioc": cioc,
    };
}

class Currency {
    Currency({
        this.code,
        this.name,
        this.symbol,
    });

    String code;
    String name;
    String symbol;

    factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        code: json["code"],
        name: json["name"],
        symbol: json["symbol"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "symbol": symbol,
    };
}

class Language {
    Language({
        this.iso6391,
        this.iso6392,
        this.name,
        this.nativeName,
    });

    String iso6391;
    String iso6392;
    String name;
    String nativeName;

    factory Language.fromJson(Map<String, dynamic> json) => Language(
        iso6391: json["iso639_1"],
        iso6392: json["iso639_2"],
        name: json["name"],
        nativeName: json["nativeName"],
    );

    Map<String, dynamic> toJson() => {
        "iso639_1": iso6391,
        "iso639_2": iso6392,
        "name": name,
        "nativeName": nativeName,
    };
}

class RegionalBloc {
    RegionalBloc({
        this.acronym,
        this.name,
        this.otherAcronyms,
        this.otherNames,
    });

    String acronym;
    String name;
    List<dynamic> otherAcronyms;
    List<dynamic> otherNames;

    factory RegionalBloc.fromJson(Map<String, dynamic> json) => RegionalBloc(
        acronym: json["acronym"],
        name: json["name"],
        otherAcronyms: List<dynamic>.from(json["otherAcronyms"].map((x) => x)),
        otherNames: List<dynamic>.from(json["otherNames"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "acronym": acronym,
        "name": name,
        "otherAcronyms": List<dynamic>.from(otherAcronyms.map((x) => x)),
        "otherNames": List<dynamic>.from(otherNames.map((x) => x)),
    };
}

class Translations {
    Translations({
        this.de,
        this.es,
        this.fr,
        this.ja,
        this.it,
        this.br,
        this.pt,
        this.nl,
        this.hr,
        this.fa,
    });

    String de;
    String es;
    String fr;
    String ja;
    String it;
    String br;
    String pt;
    String nl;
    String hr;
    String fa;

    factory Translations.fromJson(Map<String, dynamic> json) => Translations(
        de: json["de"],
        es: json["es"],
        fr: json["fr"],
        ja: json["ja"],
        it: json["it"],
        br: json["br"],
        pt: json["pt"],
        nl: json["nl"],
        hr: json["hr"],
        fa: json["fa"],
    );

    Map<String, dynamic> toJson() => {
        "de": de,
        "es": es,
        "fr": fr,
        "ja": ja,
        "it": it,
        "br": br,
        "pt": pt,
        "nl": nl,
        "hr": hr,
        "fa": fa,
    };
}