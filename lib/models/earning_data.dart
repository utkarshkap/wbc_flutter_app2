class EarningDataYearly {
  final int year;
  double value;

  EarningDataYearly({required this.year, required this.value});
}

class EarningDataMonthly {
  final int month;
  final String monthName;
  double value;

  EarningDataMonthly(
      {required this.month, required this.monthName, required this.value});
}
