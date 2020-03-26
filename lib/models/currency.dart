class Currency {
  Currency({
    this.name,
    this.code,
    this.symbol,
  });

  String name;
  String code;
  String symbol;

  factory Currency.fromJson(Map<String, dynamic> result) {
    if ((result['results'] as List).length > 0) {
      return Currency(
        name: result['results'][0]['annotations']['currency']['name'],
        code: result['results'][0]['annotations']['currency']['iso_code'],
        symbol: result['results'][0]['annotations']['currency']['symbol'],
      );
    }
    return null;
  }
}
