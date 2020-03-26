class CurrencyRate {
  String base;
  double rate;
  String date;

  CurrencyRate({
    this.base,
    this.rate,
    this.date,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> result, String code) {
    return CurrencyRate(
      base: result['base'],
      rate: result['rates']['$code'],
      date: result['date'],
    );
  }
}
